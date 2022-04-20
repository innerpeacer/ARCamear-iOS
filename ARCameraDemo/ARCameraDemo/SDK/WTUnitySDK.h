//
//  WTUnitySDK.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <UnityFramework/UnityFramework.h>

@interface WTUnityContainerView : UIView

@end

@protocol WTUnityOverlayViewDelegate <NSObject>

@optional
- (WTUnityContainerView *)viewToOverlayInUnity;

@end

@protocol WTUnityViewControllerDelegate <NSObject>

@optional
- (void)unityDidReturnToNativeWindow:(UIViewController *)fromController;

@end

typedef enum _WTShootingParams {
    WTShooting_SD,
    WTShooting_HD
} WTShootingParams;


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
- (void)switchToScene:(NSString *)sceneName;


#pragma Select Model
- (void)useMantisVisionModel:(NSString *)modelPath;
- (void)useCommon3DModel:(NSString *)modelPath;

#pragma Shooting
- (void)setShootingParams:(WTShootingParams)params;
- (void)takePhoto:(NSString *)pID;
- (void)startRecordingVideo:(NSString *)vID;
- (void)stopRecordingVideo;

#pragma Preview
- (void)previewMantisVisionModel:(NSString *)modelPath;
- (void)setPreviewCameraDistance:(float)d;

@end
