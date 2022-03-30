//
//  AppDelegate.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[WTUnitySDK sharedSDK] setLaunchOptions:launchOptions];
    [[WTUnitySDK sharedSDK] setMainWindow:self.window];
    return YES;
}

- (void)showMainView {
//    if (![self unityInitialized]) {
//        ShowAlert(@"Unity Is Not Initialized!", @"Initialize Unity first.");
//    } else {
//        [[self ufw] showUnityWindow];
//    }
}

@end
