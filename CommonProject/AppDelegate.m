//
//  AppDelegate.m
//  CommonProject
//
//  Created by wuyoujian on 16/4/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "AppDelegate.h"
#import "SharedManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate*)shareMyApplication {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (void)setupMainVC {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainControllerManager *mainController = [[MainControllerManager alloc] init];
    self.mainVC = mainController;
    self.window.rootViewController = mainController;
    [_window makeKeyAndVisible];
}

- (void)registerSharedSDK {
    SharedPlatformSDKInfo *sdk1 = [SharedPlatformSDKInfo platform:AISharedPlatformWechat appId:WeiXinSDKAppId secret:WeiXinSDKAppSecret];
    SharedPlatformSDKInfo *sdk2 = [SharedPlatformSDKInfo platform:AISharedPlatformQQ appId:QQSDKAppId secret:QQSDKAppKey];
    [[SharedManager sharedSharedManager] registerSharedPlatform:[NSArray arrayWithObjects:sdk1,sdk2, nil]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[url absoluteString] hasPrefix:WeiXinSDKAppId]) {
        //
        return [WXApi handleOpenURL:url delegate:[SharedManager sharedSharedManager].wxCallback];
    } else if ([[url absoluteString] hasPrefix:QQSDKAppId]) {
        return [QQApiInterface handleOpenURL:url delegate:[SharedManager sharedSharedManager].qqCallback];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[url absoluteString] hasPrefix:WeiXinSDKAppId]) {
        //
        return [WXApi handleOpenURL:url delegate:[SharedManager sharedSharedManager].wxCallback];
    } else if ([[url absoluteString] hasPrefix:QQSDKAppId]) {
        return [QQApiInterface handleOpenURL:url delegate:[SharedManager sharedSharedManager].qqCallback];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([[url absoluteString] hasPrefix:WeiXinSDKAppId]) {
        //
        return [WXApi handleOpenURL:url delegate:[SharedManager sharedSharedManager].wxCallback];
    } else if ([[url absoluteString] hasPrefix:QQSDKAppId]) {
        return [QQApiInterface handleOpenURL:url delegate:[SharedManager sharedSharedManager].qqCallback];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupMainVC];
    
    [self registerSharedSDK];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
