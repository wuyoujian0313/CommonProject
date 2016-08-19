//
//  DataManageViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "DataManageViewController.h"
#import "LocalAbilityManager.h"
#import "UIImage+ResizeMagick.h"
#import "FileCache.h"
#import "GDataXMLNode.h"
#import "FileStreamOperation.h"
#import "AIBase.h"


static NSString *const jsonString   = @"{\"key1\":\"value1\",\"key2\":\"value2\",\"key3\":\"value3\"}";
static NSString *const xmlString    = @"<key><key1>value1</key1><key2>value2</key2><key3>value3</key3></key>";

@interface DataManageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView           *abilityTableView;
@property (nonatomic, strong) NSArray               *abilitys;

@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@end

@implementation DataManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"数据处理"];
    [self configAbilitys];
    
    //
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo  navigationBarHeight]) style:UITableViewStylePlain];
    [self setAbilityTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor colorWithHex:0xebeef0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:tableView];
    
    [self setTableViewFooterView:0];
}

-(void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _abilityTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_abilityTableView setTableFooterView:view];
}

- (void)configAbilitys {
    self.abilitys = @[@{@"name":@"选择图片压缩缓存"},
                      @{@"name":@"json解析"},
                      @{@"name":@"Xpath解析"},
                      @{@"name":@"文件流操作"},
                      ];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_abilitys count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *config = [_abilitys objectAtIndex:indexPath.row];
    NSString *name = config[@"name"];
    if ([name isEqualToString:@"选择图片压缩缓存"]) {
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        self.localAbilityMgr = obj;
        [obj pickerCameraController:self type:LocalAbilityTypePickerImage_ForbidEditing finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (type == ImagePickerTypeImage) {
                CGSize scaleSize = [DeviceInfo getDeviceScreenSize];
                UIImage *image = (UIImage*)data;
                UIImage *imageScale = [image resizedImageByMagick:[NSString stringWithFormat:@"%ldx%ld",(long)scaleSize.width,(long)scaleSize.height]];
                
                NSData *imageSrcData = UIImagePNGRepresentation(image);
                NSData *imageData = UIImagePNGRepresentation(imageScale);
                NSLog(@"原始大小：%lu\t 缩放后：%lu",(unsigned long)[imageSrcData length],(unsigned long)[imageData length]);
                NSString *fileKey = [FileCache fileKey];
                
                NSString *docPath = [DeviceInfo getDocumentsPath];
                [[FileCache sharedFileCache] writeData:imageData path:[docPath stringByAppendingPathComponent:fileKey]];
                
                NSString *fileKeySrc = [FileCache fileKey];
                [[FileCache sharedFileCache] writeData:imageSrcData path:[docPath stringByAppendingPathComponent:fileKeySrc]];
                
            }
            
        }];
    } else if ([name isEqualToString:@"json解析"] || [name isEqualToString:@"Xpath解析"]) {
        
        NSString *msg = nil;
        if ([name isEqualToString:@"json解析"]) {
            NSError * error = nil;
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            msg = [jsonDictionary description];
        } else {
            GDataXMLDocument* xdoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
            
            NSString *xpath = [NSString stringWithFormat:@"/key/*"];
            NSArray* elements = [xdoc nodesForXPath:xpath error:nil];
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:0];
            for (int i = 0; i < [elements count]; i++) {
                GDataXMLElement* element = [elements objectAtIndex:i];
                if ([element kind] == GDataXMLElementKind) {
                    if ([element stringValue] && [element name])
                        [tempDict setObject:[element stringValue] forKey:[element name]];
                }
            }
            
            msg = [tempDict description];
        }
        
        UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"解析结果" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:aAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([name isEqualToString:@"文件流操作"]) {
        
        NSString *bundlePath = [DeviceInfo getMainBundlePath];
        NSString *readPath = [bundlePath stringByAppendingPathComponent:@"upload.JPG"];
        FileStreamOperation *readOperation = [[FileStreamOperation alloc] initFileOperationAtPath:readPath forReadOperation:YES];
        
        NSString *docPath = [DeviceInfo getDocumentsPath];
        NSString *writePath = [docPath stringByAppendingPathComponent:@"upload1.JPG"];
        FileStreamOperation *writeOperation = [[FileStreamOperation alloc] initFileOperationAtPath:writePath forReadOperation:NO];

        // 一次性写入
//        NSData *d = [readOperation readDataToEndOfFile];
//        [writeOperation writeData:d];
      
        // 分块写入
        for (FileFragment *fragment in [readOperation fileFragments]) {
            NSData * d = [readOperation readDateOfFragment:fragment];
            [writeOperation writeData:d];
        }
        
        [readOperation closeFile];
        [writeOperation closeFile];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommonTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIView *selBGView = [[UIView alloc] initWithFrame:cell.bounds];
        [selBGView setBackgroundColor:[UIColor colorWithHex:0xeeeeee]];
        cell.selectedBackgroundView = selBGView;
    }
    
    NSDictionary *config = [_abilitys objectAtIndex:indexPath.row];
    cell.textLabel.text = config[@"name"];
    
    if ([config[@"name"] hasPrefix:@"json"] || [config[@"name"] hasPrefix:@"Xpath"] ) {
        if ([config[@"name"] hasPrefix:@"json"]) {
            cell.detailTextLabel.text = jsonString;
        } else {
            cell.detailTextLabel.text = xmlString;
        }
        
    } else {
        cell.detailTextLabel.text = nil;
    }
    

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
