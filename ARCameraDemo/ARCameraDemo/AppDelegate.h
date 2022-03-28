//
//  AppDelegate.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import <UIKit/UIKit.h>
#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property UnityFramework *ufw;
@property bool didQuit;

+ (AppDelegate *)sharedInstance;
- (bool)unityInitialized;

- (bool)initUnity;

@end

