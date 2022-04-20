//
//  WTUnitySDK.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/30.
//

#import "WTUnitySDK.h"

void ShowAlert(NSString *title, NSString *msg) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];

    auto delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

UnityFramework *LoadUnityFramework() {
//    NSLog(@"UnityFrameworkLoad");
    
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *bundlePath = [mainBundlePath stringByAppendingString:@"/Frameworks/UnityFramework.framework"];

    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([bundle isLoaded] == false) {
//        NSLog(@"[bundle load]");
        [bundle load];
    }
//    NSLog(@"isLoaded: %d", [bundle isLoaded]);

    UnityFramework *ufw = [bundle.principalClass getInstance];
    if (![ufw appController]) {
        [ufw setExecuteHeader:&_mh_execute_header];
    }
    return ufw;
}

@interface WTUnitySDK() <UnityFrameworkListener> {
    int gArgc;
    char **gArgv;
    NSDictionary *appLaunchOpts;
    
    UIWindow *mainWindow;
}

@property UnityFramework *ufw;
@property BOOL quitted;

@property (nonatomic, weak) UIViewController<WTUnityOverlayViewDelegate> *nativeUIController;
@property (nonatomic, weak) UIViewController<WTUnityViewControllerDelegate> *fromController;

@end

@implementation WTUnitySDK

#define AR_CAMERA_CONTROLLER "ARCameraSceneController"
#define AR_PREVIEW_CONTROLLER "ARPreviewSceneController"

- (id)init {
    self = [super init];
    if (self) {
        gArgc = 0;
        gArgv = nullptr;
    }
    return self;
}

+ (WTUnitySDK *)sharedSDK
{
    static dispatch_once_t onceToken;
    static WTUnitySDK *sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[WTUnitySDK alloc] init];
    });
    
    return sharedInstance;
}

+ (UnityFramework *)ufw
{
    return [WTUnitySDK sharedSDK].ufw;
}

- (BOOL)isUnityInitialized
{
//    return _ufw && [_ufw appController];
    return _ufw;
}

- (BOOL)isQuitted
{
    return _quitted;
}

-(void)runInMainWithArgc:(int)argc argv:(char **)argv {
    gArgc = argc;
    gArgv = argv;
}

- (void)setLaunchOptions:(NSDictionary *)opts {
    appLaunchOpts = opts;
}

- (void)setMainWindow:(UIWindow *)window
{
    mainWindow = window;
}

- (void)preloadIfNeed
{
    NSLog(@"[WTUnitySDK].preload");
    if ([self isUnityInitialized]) {
        return;
    }
    
    if (self.quitted) {
        return;
    }
    
    if (_ufw == nil) {
        _ufw = LoadUnityFramework();
        [_ufw setDataBundleId:"com.unity3d.framework"];
    }
}

- (BOOL)initUnity
{
    if ([self isUnityInitialized]) {
        ShowAlert(@"Unity already initilized", @"Unload Unity first");
        return NO;
    }
    
    if (self.quitted) {
        ShowAlert(@"Unity cannot be initilized after quit", @"Use unload instead");
        return NO;
    }
    
    if (_ufw == nil) {
        _ufw = LoadUnityFramework();
        [_ufw setDataBundleId:"com.unity3d.framework"];
    }
    
    [_ufw registerFrameworkListener:self];
    //    [NSClassFromString(@"WTUnityCallbackUtils") registerApiForTestingCallbacks:self];
    [_ufw runEmbeddedWithArgc:gArgc argv:gArgv appLaunchOpts:appLaunchOpts];
    
    [_ufw appController].quitHandler  = ^(){
        NSLog(@"AppController.quitHander called");
    };
    return YES;
}

- (void)showNativeWindow
{
    if (self.nativeUIController) {
        [self.nativeUIController dismissModalViewControllerAnimated:YES];
        self.nativeUIController = nil;
    }
    auto view = [[[WTUnitySDK ufw] appController] rootView];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [self unloadUnity];
    
    [mainWindow makeKeyAndVisible];
    if ([self.fromController respondsToSelector:@selector(unityDidReturnToNativeWindow:)]) {
        [self.fromController unityDidReturnToNativeWindow:self.fromController];
    }
    self.fromController = nil;
}

- (void)showUnityWindowFrom:(UIViewController<WTUnityViewControllerDelegate> *)fromController withController:(UIViewController<WTUnityOverlayViewDelegate> *)uiController
{
    NSLog(@"[WTUnitySDK].showUnityWindow");
    self.fromController = fromController;
    self.nativeUIController = uiController;
    [self initUnity];
    [self.fromController presentModalViewController:self.nativeUIController animated:YES];
    
    auto view = [[[WTUnitySDK ufw] appController] rootView];
    if (uiController && [uiController respondsToSelector:@selector(viewToOverlayInUnity)]) {
        [view addSubview:[uiController viewToOverlayInUnity]];
    }
}

- (void)switchToScene:(NSString *)sceneName
{
    [[self ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"SwitchScene" message:sceneName.UTF8String];
}

- (void)useMantisVisionModel:(NSString *)modelPath
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"UseMvx" message:modelPath.UTF8String];
}

- (void)useCommon3DModel:(NSString *)modelPath
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"UseModel" message:modelPath.UTF8String];
}

- (void)setShootingParams:(WTShootingParams)params
{
    double photoSuperSize = 1;
    double videoSuperSize = 0.5;
    int videoFrameRate = 24;
    
    if (params == WTShooting_HD) {
        photoSuperSize = 2;
        videoSuperSize = 1;
        videoFrameRate = 60;
    }
    
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"SetPhotoSuperSize" message:[NSString stringWithFormat:@"%f", photoSuperSize].UTF8String];
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"SetVideoSuperSize" message:[NSString stringWithFormat:@"%f", videoSuperSize].UTF8String];
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"SetVideoFrameRate" message:[NSString stringWithFormat:@"%d", videoFrameRate].UTF8String];
}

- (void)takePhoto:(NSString *)pID
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"TakePhoto" message:pID.UTF8String];
}

- (void)startRecordingVideo:(NSString *)vID
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"StartRecordingVideo" message:vID.UTF8String];
}

- (void)stopRecordingVideo
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_CAMERA_CONTROLLER functionName:"StopRecordingVideo" message:""];
}

- (void)previewMantisVisionModel:(NSString *)modelPath
{
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_PREVIEW_CONTROLLER functionName:"PreviewMvxModel" message:modelPath.UTF8String];
}

- (void)setPreviewCameraDistance:(float)d
{
    if (d <= 0) {
        return;
    }
    [[WTUnitySDK ufw] sendMessageToGOWithName:AR_PREVIEW_CONTROLLER functionName:"SetCameraPositionZ" message:[NSString stringWithFormat:@"%f", -d].UTF8String];
}

- (void)unloadUnity
{
    if (![self isUnityInitialized]) {
        ShowAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [_ufw unloadApplication];
    }
}

- (void)quitUnity
{
    if (![self isUnityInitialized]) {
        ShowAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [_ufw quitApplication:0];
    }
}

#pragma mark Framework LifeCycle
- (void)applicationWillResignActive:(UIApplication *)application {
    [[_ufw appController] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[_ufw appController] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[_ufw appController] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[_ufw appController] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[_ufw appController] applicationWillTerminate:application];
}

- (void)unityDidUnload:(NSNotification *)notification
{
//    NSLog(@"unityDidUnload");
    [_ufw unregisterFrameworkListener:self];
    _ufw = nil;
//    [self showHostMainWindow:@""];
}

- (void)unityDidQuit:(NSNotification *)notification
{
//    NSLog(@"unityDidQuit");
    [_ufw unregisterFrameworkListener:self];
    _ufw = nil;
    _quitted = YES;
//    [self showHostMainWindow:@""];
}

@end


@implementation WTUnityContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint pointInSubview = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:pointInSubview withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
    }
    return nil;
}

@end
