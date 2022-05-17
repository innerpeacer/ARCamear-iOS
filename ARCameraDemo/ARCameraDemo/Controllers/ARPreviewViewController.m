//
//  ARPreviewViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/20.
//

#import "ARPreviewViewController.h"
#import "AppDelegate.h"
#import <UnityFramework/WTNativeCallUnityProxy.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"
#import "MockingFileHelper.h"

@interface ARPreviewViewController () <WTUnityOverlayViewDelegate, WTUnitySceneControllerCallbackProtocol>

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
    
    [WTUnityCallbackUtils registerApiForSceneControllerCallbacks:self];
    [[WTUnitySDK sharedSDK] switchToScene:@"ARPreviewScene"];
}

- (void)unityDidLoadScene:(NSString *)sceneName
{
//    NSLog(@"======== Did Load Scene: %@", sceneName);
    if ([sceneName isEqualToString:@"ARPreviewScene"]) {
        [[WTUnitySDK sharedSDK] setPreviewBackgroundColorWithRed:1.0 Blue:0.0 Green:0.0 Alpha:1.0f];
        [self previewModel1];
    }
}

- (void)unityDidUnloadScene:(NSString *)sceneName
{
//    NSLog(@"======== Did UnLoad Scene: %@", sceneName);
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
        UIButton *button = [self createButtonWithTitle:@"Preview 1" Color:[UIColor blueColor] Action:@selector(previewModel1)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.previewButton1 = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Preview 2" Color:[UIColor blueColor] Action:@selector(previewModel2)];
        button.center = CGPointMake(300, 200);
        [self.containerView addSubview:button];
        self.previewButton2 = button;
    }
}

- (void)previewModel1
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
    NSString *modelName = @"1.mvx";
    NSString *modelPath = [dir stringByAppendingPathComponent:modelName];

    [[WTUnitySDK sharedSDK] previewMantisVisionModel:modelPath];
    [[WTUnitySDK sharedSDK] setPreviewCameraDistance:2];
}

- (void)previewModel2
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
    NSString *modelName = @"2.mvx";
    NSString *modelPath = [dir stringByAppendingPathComponent:modelName];

    [[WTUnitySDK sharedSDK] previewMantisVisionModel:modelPath];
    [[WTUnitySDK sharedSDK] setPreviewCameraDistance:5];
}

@end
