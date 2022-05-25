//
//  AppDelegate.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "AppDelegate.h"
#import "WTUnitySDK.h"
#import "MockingFileHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MockingFileHelper checkMockingFile];
    
    [[WTUnitySDK sharedSDK] setLaunchOptions:launchOptions];
    [[WTUnitySDK sharedSDK] setMainWindow:self.window];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[WTUnitySDK sharedSDK] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[WTUnitySDK sharedSDK] applicationWillEnterForeground:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[WTUnitySDK sharedSDK] applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[WTUnitySDK sharedSDK] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[WTUnitySDK sharedSDK] applicationWillTerminate:application];
}

@end
