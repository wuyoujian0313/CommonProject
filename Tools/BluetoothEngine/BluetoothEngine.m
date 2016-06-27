//
//  BluetoothEngine.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/24.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "BluetoothEngine.h"

NSString *EADSessionDataReceivedNotification = @"EADSessionDataReceivedNotification";

@interface BluetoothEngine ()<EAAccessoryDelegate,NSStreamDelegate>
@property (nonatomic, strong)NSMutableArray *accessoryList;
@property (nonatomic, strong)EASession      *session;
@property (nonatomic, strong)EAAccessory    *accessory;

@property (nonatomic, copy) NSString        *protocolString;
@property (nonatomic, strong)NSMutableData  *writeData;
@property (nonatomic, strong)NSMutableData  *readData;

@end

@implementation BluetoothEngine

+ (BluetoothEngine *)sharedBluetoothEngine {
    
    static BluetoothEngine *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void)registerBluetoothEngine {
    
    [self unregisterBluetoothEngine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnectNotification:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnectNotification:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    self.accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    
}


- (void)unregisterBluetoothEngine {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];
    
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    if (_accessoryList) {
        [_accessoryList removeAllObjects];
        _accessoryList = nil;
    }
    
    [self closeBlutoothSessionWithAccessory];
}

- (NSArray *)accessoryList {
    return _accessoryList;
}

- (BOOL)isConnectReady {
    
    if (_accessoryList && [_accessoryList count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)openBlutoothSessionWithAccessory:(EAAccessory*)accessory forProtocol:(NSString *)protocolString {
    
    self.accessory = accessory;
    self.protocolString = protocolString;
    
    [_accessory setDelegate:self];
    self.session = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocolString];
    
    if (_session) {
        [[_session inputStream] setDelegate:self];
        [[_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session inputStream] open];
        
        [[_session outputStream] setDelegate:self];
        [[_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session outputStream] open];
    } else {
        NSLog(@"creating session failed");
    }
    
    return (_session != nil);
}


- (void)closeBlutoothSessionWithAccessory {
    
    [[_session inputStream] close];
    [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session inputStream] setDelegate:nil];
    [[_session outputStream] close];
    [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session outputStream] setDelegate:nil];
    
    _session = nil;
    _writeData = nil;
    _readData = nil;
}

- (void)writeData:(NSData *)data {
    if (_writeData == nil) {
        _writeData = [[NSMutableData alloc] init];
    }
    
    [_writeData appendData:data];
    [self writeDataToBluetooth];
}

- (void)writeHexString:(NSString *)hexString {
    const char *buf = [hexString UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf) {
        
        uint32_t len = (uint32_t)strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint64_t i = 0 ; i < len; i+=2) {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) ) {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp) length:1];
            } else {
                break;
            }
        }
        
        [self writeData:data];
    }
}

- (NSData *)readData:(NSUInteger)bytesToRead {
    NSData *data = nil;
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    return data;
}

- (NSUInteger)readBytesAvailable {
    return [_readData length];
}

- (void)writeDataToBluetooth {
    
    while (([[_session outputStream] hasSpaceAvailable]) && ([_writeData length] > 0)) {
        NSInteger bytesWritten = [[_session outputStream] write:[_writeData bytes] maxLength:[_writeData length]];
        if (bytesWritten == -1) {
            NSLog(@"write error");
            break;
        } else if (bytesWritten > 0) {
            [_writeData replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}

- (void)readBluetoothData {
    
#define EAD_INPUT_BUFFER_SIZE 128
    uint8_t buf[EAD_INPUT_BUFFER_SIZE];
    while ([[_session inputStream] hasBytesAvailable]) {
        NSInteger bytesRead = [[_session inputStream] read:buf maxLength:EAD_INPUT_BUFFER_SIZE];
        if (_readData == nil) {
            _readData = [[NSMutableData alloc] init];
        }
        [_readData appendBytes:(void *)buf length:bytesRead];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionDataReceivedNotification object:self userInfo:nil];
}

#pragma mark EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)accessory {
    // do something ...
}

#pragma mark NSStreamDelegateEventExtensions
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
            [self readBluetoothData];
            break;
        case NSStreamEventHasSpaceAvailable:
            [self writeDataToBluetooth];
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            break;
    }
}

#pragma mark - NSNotification
- (void)accessoryDidConnectNotification:(NSNotification *)notification {
    
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    if (connectedAccessory) {
        [_accessoryList addObject:connectedAccessory];
    }
}

- (void)accessoryDidDisconnectNotification:(NSNotification *)notification {
    
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    int disconnectedAccessoryIndex = 0;
    for(EAAccessory *accessory in _accessoryList) {
        if ([disconnectedAccessory connectionID] == [accessory connectionID]) {
            break;
        }
        disconnectedAccessoryIndex++;
    }
    
    if (disconnectedAccessoryIndex < [_accessoryList count]) {
        [_accessoryList removeObjectAtIndex:disconnectedAccessoryIndex];
    } else {
        NSLog(@"could not find disconnected accessory in accessory list");
    }
}

@end
