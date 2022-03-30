//
//  WTUnitySDK.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <UnityFramework/UnityFramework.h>

@interface WTUnitySDK : NSObject

+ (WTUnitySDK *)sharedSDK;
+ (UnityFramework *)ufw;

-(void)runInMainWithArgc:(int)argc argv:(char **)argv;
- (void)setLaunchOptions:(NSDictionary *)opts;

- (BOOL)isUnityInitialized;
- (BOOL)isQuitted;

- (void)preloadIfNeed;
- (BOOL)initUnity;
- (void)unloadUnity;
- (void)quitUnity;

- (void)showNativeWindow;
//- (void)showUnityWindow;
- (void)setMainWindow:(UIWindow *)window;

@end
