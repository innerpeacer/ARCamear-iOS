//
//  WTUnitySDK.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <UnityFramework/UnityFramework.h>

@protocol WTUnityOverlayViewDelegate <NSObject>

@optional
- (UIView *)viewToOverlayInUnity;

@end

@protocol WTUnityViewControllerDelegate <NSObject>

@optional
- (void)unityDidReturnToNativeWindow:(UIViewController *)fromController;

@end


@interface WTUnitySDK : NSObject

+ (WTUnitySDK *)sharedSDK;
+ (UnityFramework *)ufw;

#pragma Config Methods
-(void)runInMainWithArgc:(int)argc argv:(char **)argv;
- (void)setLaunchOptions:(NSDictionary *)opts;
- (void)setMainWindow:(UIWindow *)window;

#pragma Operation Methods
- (void)showNativeWindow;
- (void)showUnityWindowFrom:(UIViewController *)fromController withController:(UIViewController *)uiController;

@end
