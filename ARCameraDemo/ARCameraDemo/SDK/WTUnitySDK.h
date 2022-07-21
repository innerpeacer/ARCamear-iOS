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

typedef enum _WTModelType {
    WTModel_Unknown = 0,
    WTModel_Common3D = 1,
    WTModel_MantisVisionHD = 2,
//    WTModel_MantisVisionSD = 3,
} WTModelType;

typedef enum _WTMovingDirection {
    WTMovingDirection_Forward = 1,
    WTMovingDirection_Right = 2,
    WTMovingDirection_Backward = 3,
    WTMovingDirection_Left = 4,
} WTMovingDirection;

@interface WTUnitySDK : NSObject

+ (WTUnitySDK *)sharedSDK;
+ (UnityFramework *)ufw;

+ (NSString *)cameraScene;
+ (NSString *)previewScene;
+ (NSString *)virtualWorldScene;

#pragma Config Methods
-(void)runInMainWithArgc:(int)argc argv:(char **)argv;
- (void)setLaunchOptions:(NSDictionary *)opts;
- (void)setMainWindow:(UIWindow *)window;
- (BOOL)isUnityInitialized;

#pragma Operation Methods
- (void)showNativeWindow;
- (void)showNativeWindow:(BOOL)anmiated;
- (void)showUnityWindowFrom:(UIViewController *)fromController withController:(UIViewController *)uiController;
- (void)showUnityWindowFrom:(UIViewController *)fromController withController:(UIViewController *)uiController animated:(BOOL)animated;
- (void)switchToScene:(NSString *)sceneName;

#pragma Camera
- (void)setCameraMvxFrameParamsWithTargetFPS:(NSNumber *)targetFPS skipFrame:(NSNumber *)skipFrame;

#pragma Model Handling
- (void)useMantisVisionModel:(NSString *)modelPath;
- (void)useCommon3DModel:(NSString *)modelPath;
- (void)useCommon3DModelAsync:(NSString *)modelPath;
- (void)removeModelObject:(NSString *)objectID;
- (void)setEditModeWaitingInterval:(float)timeInterval;

#pragma Shooting
- (void)setShootingParams:(WTShootingParams)params;
- (void)takePhoto:(NSString *)pID;
- (void)startRecordingVideo:(NSString *)vID;
- (void)stopRecordingVideo;

#pragma Preview
- (void)previewMantisVisionModel:(NSString *)modelPath;
- (void)previewCommon3DModel:(NSString *)modelPath;
- (void)previewModelWithPath:(NSString *)modelPath InfoPath:(NSString *)modelInfoPath;
- (void)loadModelInfo:(NSString *)modelInfoPath;
- (void)setPreviewCamareRectWithX:(float)x Y:(float)y Width:(float)width Height:(float)height;
//- (void)setPreviewCameraDistance:(float)d;
//- (void)setPreviewCameraFieldWithXmin:(float)xMin XMax:(float)xMax YMin:(float)yMin YMax:(float)yMax ZMin:(float)zMin ZMax:(float)zMax;
- (void)setPreviewBackgroundColorWithRed:(float)r Blue:(float)b Green:(float)g Alpha:(float)alpha;
- (void)setPreviewMvxFrameParamsWithTargetFPS:(NSNumber *)targetFPS skipFrame:(NSNumber *)skipFrame;

#pragma VirtualWorldDemo
- (void)virtualWorldLoadModelWithPath:(NSString *)modelPath;
- (void)virtualWorldSetModelPositionWithX:(float)x Y:(float)y Z:(float)z;
- (void)virtualWorldSetMovingSpeed:(float)speed;
- (void)virtaulWorldStartMoving:(WTMovingDirection)direction;
- (void)virtaulWorldStopMoving;
- (void)virtualWorldTakePhoto:(NSString *)pID;
- (void)virtualWorldStartRecordingVideo:(NSString *)vID;
- (void)virtualWorldStopRecordingVideo;

#pragma Application LifeCycle
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

@end
