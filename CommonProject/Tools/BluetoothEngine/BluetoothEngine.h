//
//  BluetoothEngine.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/24.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>


@interface BluetoothEngine : NSObject

// Notification object 是BluetoothEngine
extern NSString *EADSessionDataReceivedNotification;

+ (BluetoothEngine *)sharedBluetoothEngine;

@property (nonatomic, readonly) EAAccessory                     *accessory;
@property (nonatomic, readonly) NSString                        *protocolString;
@property (nonatomic, readonly) NSArray<EAAccessory*>           *accessoryList;

- (void)registerBluetoothEngine;
- (void)unregisterBluetoothEngine;

- (BOOL)isConnectReady;

- (BOOL)openBlutoothSessionWithAccessory:(EAAccessory*)accessory forProtocol:(NSString *)protocolString;
- (void)closeBlutoothSessionWithAccessory;

- (void)writeData:(NSData *)data;
- (void)writeHexString:(NSString *)hexString;

- (NSUInteger)readBytesAvailable;
- (NSData *)readData:(NSUInteger)bytesToRead;

@end
