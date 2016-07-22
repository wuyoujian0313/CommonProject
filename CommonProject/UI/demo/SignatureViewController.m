//
//  SignatureViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/16.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "SignatureViewController.h"
#import "SignatureView.h"
#import "DeviceInfo.h"


@interface SignatureViewController ()
@property (nonatomic, strong) SignatureView *signView;
@property (nonatomic, strong) UIBarButtonItem *undoItem;
@property (nonatomic, strong) UIBarButtonItem *redoItem;
@end

@implementation SignatureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"手写签名"];
    [self setContentViewBackgroundColor:[UIColor whiteColor]];
    
    [self layoutSignatureView];
    [self setToolBarView];
}

- (void)layoutSignatureView {
    
    self.signView = [[SignatureView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight] - 44) status:^(SigntureStatus status) {
        //
        
        if (status == SignatureStatusBegin) {
            [_undoItem setEnabled:YES];
        }
    }];
    
    [_signView setPenSize:3.0];
    [self.view addSubview:_signView];
}

- (void)toolBarAction:(UIBarButtonItem*)sender {
    
    switch (sender.tag) {
        case 10: {
            [_signView undoSignature];
            if ([_signView canRedoSignature]) {
                [_redoItem setEnabled:YES];
            }
            
            [_undoItem setEnabled:[_signView canUndoSignature]];
            break;
        }
        case 11:
            [_signView redoSignature];
            if ([_signView canUndoSignature]) {
                [_undoItem setEnabled:YES];
            }
            
            [_redoItem setEnabled:[_signView canRedoSignature]];
            break;
        case 12:
            [_signView clear];
            [_redoItem setEnabled:NO];
            [_undoItem setEnabled:NO];
            break;
        case 13: {
            
            NSString *signFile = [[DeviceInfo getDocumentsPath] stringByAppendingPathComponent:@"signture.png"];
            [_signView saveImage2PNGAtPath:signFile];
            
            // 发送给服务器
            
            break;
        }
        default:
            break;
    }
}

- (void)setToolBarView {
    
    self.undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(toolBarAction:)];
    _undoItem.tag = 10;
    
    self.redoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(toolBarAction:)];
    _redoItem.tag = 11;
    
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarAction:)];
    trashItem.tag = 12;
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolBarAction:)];
    okItem.tag = 13;
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(toolBarAction:)];
    flexItem.tag = 14;
    
    NSArray *items = @[flexItem,_undoItem,flexItem,_redoItem,flexItem,trashItem,flexItem,okItem,flexItem];
    
    
    [_redoItem setEnabled:NO];
    [_undoItem setEnabled:NO];
    
    UIToolbar *tooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [DeviceInfo screenHeight] - 44, [DeviceInfo screenWidth], 44)];
    [tooBar setItems:items];
    [self.view addSubview:tooBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
