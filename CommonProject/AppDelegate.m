//
//  AppDelegate.m
//  CommonProject
//
//  Created by wuyoujian on 16/4/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "AppDelegate.h"

#import "ZipEx.h"

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupMainVC];
    
    
    NSString *sPath = [[NSBundle mainBundle] bundlePath];
    NSString* file1 = [sPath stringByAppendingString:@"/read_me.txt"];
    NSString* file2 = [sPath stringByAppendingString:@"/JSPatch.js"];
    NSString* file3 = [sPath stringByAppendingString:@"/template.html"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* unzipto = [documentsDirectory stringByAppendingString:@"/zip"];
    //[fileManager createDirectoryAtPath:unzipto withIntermediateDirectories:YES attributes:nil error:nil];
    NSString* ZipTo = [unzipto stringByAppendingString:@"/test.zip"];
    unzipto = [unzipto stringByAppendingString:@"/test"];
    
    NSArray *arr = [NSArray arrayWithObjects:file1,file2,file3,nil];
   // [ZipEx zipWithPassword:@"wuyoujian" sourceFiles:arr outZipFile:ZipTo];
    
    [ZipEx unZipWithPassword:@"wuyoujian" sourceFile:ZipTo outDirectory:unzipto];
    
    
    
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
