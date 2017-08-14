//
//  AppDelegate.m
//  YYdemo
//
//  Created by 胡杨林 on 2017/8/10.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>

@interface AppDelegate () <BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化地图SDK
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    if ([mapManager start:@"5jkGTr5K1GImggDLIFMlo688woEuUDNX" generalDelegate:self]) {
        NSLog(@"manager启动成功");
    }
    //设置鹰眼SDK的基础信息
    BTKServiceOption *basicInfoOption = [[BTKServiceOption alloc]initWithAK:@"5jkGTr5K1GImggDLIFMlo688woEuUDNX" mcode:@"com.practice.testProject.StepCount" serviceID:147404 keepAlive:YES];
    if ([[BTKAction sharedInstance] initInfo:basicInfoOption]) {
        NSLog(@"鹰眼轨迹初始化成功");
    }
    return YES;
}

-(void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
