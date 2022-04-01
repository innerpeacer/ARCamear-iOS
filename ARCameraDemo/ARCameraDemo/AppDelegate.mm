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

@end
