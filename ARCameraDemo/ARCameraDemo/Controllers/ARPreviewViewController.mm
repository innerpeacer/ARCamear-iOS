//
//  ARPreviewViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/20.
//

#import "ARPreviewViewController.h"
#import "AppDelegate.h"
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"
#import "WTModelInfo.h"
#import "MockingFileHelper.h"

@interface ARPreviewViewController () <WTUnityOverlayViewDelegate, WTUnitySceneControllerCallbackProtocol, WTModelHandlingCallbackProtocol>

{
    WTModelInfo *currentModelInfo;
    int testAnimationIndex;
}
@property(nonatomic, strong) WTUnityContainerView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *sendMessageButton;
@property(nonatomic, strong) UIButton *callUnityApiButton;
@property(nonatomic, strong) UIButton *previewButton1;
@property(nonatomic, strong) UIButton *previewButton2;

@end

@implementation ARPreviewViewController

- (id)init
{
    if (self = [super init]) {
        [self initButtons];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)unityDidLoadEntryScene
{
//    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"Images"];
//    NSString *bgPath = [dir stringByAppendingPathComponent:@"bg2.jpg"];
//    [[WTUnitySDK sharedSDK] setGlobalBackgroundImage:bgPath];
    [[WTUnitySDK sharedSDK] setGlobalBackgroundColorWithRed:1.0 Blue:0.0 Green:0.5 Alpha:1.0f];
    [[WTUnitySDK sharedSDK] switchToScene:[WTUnitySDK previewScene]];
}

- (void)unityDidLoadScene:(NSString *)sceneName
{
    NSLog(@"======== Did Load Scene: %@", sceneName);
    if ([sceneName isEqualToString:[WTUnitySDK previewScene]]) {
//        [[WTUnitySDK sharedSDK] setPreviewBackgroundColorWithRed:1.0 Blue:0.0 Green:0.5 Alpha:1.0f];
//        [[WTUnitySDK sharedSDK] setPreviewCamareRectWithX:0.0 Y:0.1 Width:1 Height:0.8];
        [[WTUnitySDK sharedSDK] setPreviewMvxFrameParamsWithTargetFPS:@24 skipFrame:@2];
        [self previewModel1];
    }
}

- (void)unityDidUnloadScene:(NSString *)sceneName
{
    NSLog(@"======== Did UnLoad Scene: %@", sceneName);
}

- (void)showNativeWindow
{
    NSLog(@"showNativeWindow");
    [[WTUnitySDK sharedSDK] showNativeWindow];
}

- (UIView *)viewToOverlayInUnity
{
    return self.containerView;
}

- (UIButton *)createButtonWithTitle:(NSString *)title Color:(UIColor *)color Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 150, 44);
    button.backgroundColor = color;
    [button addTarget:self action:action forControlEvents:UIControlEventPrimaryActionTriggered];
    return button;
}

- (void)initButtons {
    NSLog(@"initButtons");
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.containerView = [[WTUnityContainerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    {
        UIButton *button = [self createButtonWithTitle:@"Return To Native" Color:[UIColor greenColor] Action:@selector(showNativeWindow)];
        button.center = CGPointMake(100, 100);
        [self.containerView addSubview:button];
        self.returnToNativeButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Play Animation" Color:[UIColor greenColor] Action:@selector(playAnimation:)];
        button.center = CGPointMake(300, 300);
        [self.containerView addSubview:button];
    }

    {
//        UIButton *button = [self createButtonWithTitle:@"Send Unity Message" Color:[UIColor yellowColor] Action:@selector(sendUnityMessage)];
//        button.center = CGPointMake(100, screenSize.height - 100);
//        [self.containerView addSubview:button];
//        self.sendMessageButton = button;
    }
    
    {
//        UIButton *button = [self createButtonWithTitle:@"Call Unity API" Color:[UIColor yellowColor] Action:@selector(callUnityApi)];
//        button.center = CGPointMake(300, screenSize.height - 100);
//        [self.containerView addSubview:button];
//        self.callUnityApiButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Preview 1" Color:[UIColor blueColor] Action:@selector(btnPreview1Clicked:)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.previewButton1 = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Preview 2" Color:[UIColor blueColor] Action:@selector(btnPreview2Clicked:)];
        button.center = CGPointMake(300, 200);
        [self.containerView addSubview:button];
        self.previewButton2 = button;
    }
}

- (void)btnPreview1Clicked:(id)sender
{
    [self previewModel1];
}

- (void)btnPreview2Clicked:(id)sender
{
    int random = arc4random() % 2;
    if (random == 0) {
        [self previewModel2];
    } else {
        [self previewWABModel:@"techgirl"];
    }
}

- (void)previewModel1
{
    NSString *modelName = @"1";
    [self preivewMVXModel:modelName];
}

- (void)previewModel2
{
    NSString *modelName = @"Flamingo";
    //    modelName = @"AlloyArmor";
    [self previewGLBModel:modelName];
}

- (void)preivewMVXModel:(NSString *)modelName
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
    NSString *modelPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mvx", modelName]];
    NSString *modelInfoPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", modelName]];
    [[WTUnitySDK sharedSDK] previewModelWithPath:modelPath InfoPath:modelInfoPath];
}

- (void)previewGLBModel:(NSString *)modelName
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"GLB"];
    NSString *modelPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.glb", modelName]];
    NSString *modelInfoPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", modelName]];
    [[WTUnitySDK sharedSDK] previewModelWithPath:modelPath InfoPath:modelInfoPath];
}

- (void)previewWABModel:(NSString *)modelName
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"WAB"];
    NSString *modelPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wab", modelName]];
    NSString *modelInfoPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", modelName]];
    [[WTUnitySDK sharedSDK] previewModelWithPath:modelPath InfoPath:modelInfoPath];
}

- (IBAction)playAnimation:(id)sender
{
    NSLog(@"======== PlayAnimation");
    if (currentModelInfo == nil) {
        return;
    }
    
    if (testAnimationIndex >= currentModelInfo.animation.clips.count) {
        testAnimationIndex = 0;
    }

    WTAnimatinoClip *clip = currentModelInfo.animation.clips[testAnimationIndex++];
    [[WTUnitySDK sharedSDK] playPreviewAnimation:clip.clipName];
}

- (void)unityDidFinishLoadingModel:(int)modelType withPath:(NSString *)path infoPath:(NSString *)infoPath
{
    NSLog(@"Did Load Model: %@", path);
    currentModelInfo = [WTModelInfo modelInfoFromFile:infoPath];
}

- (void)unityDidFailedLoadingModel:(int)modelType withPath:(NSString *)path infoPath:(nonnull NSString *)infoPath  description:(NSString *)description
{
    NSLog(@"Failed Load Model: %@", description);
}

@end
