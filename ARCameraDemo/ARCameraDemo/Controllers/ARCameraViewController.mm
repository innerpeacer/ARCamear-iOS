//
//  ARCameraViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/4.
//

#import "ARCameraViewController.h"
#import <UnityFramework/WTNativeCallUnityProxy.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"
#import "MockingFileHelper.h"


@interface ARCameraViewController() <WTUnityOverlayViewDelegate, WTUnityShootingCallbackProtocol>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *shootingView;
@property (weak, nonatomic) IBOutlet UIView *modelView;
@property (weak, nonatomic) IBOutlet UIButton *modelButton;
@property (weak, nonatomic) IBOutlet UIButton *mvxButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *startVideoButton;
@property (nonatomic, strong) UIButton *stopVideoButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation ARCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ARCameraViewController.viewDidLoad");
    
    [WTUnityCallbackUtils registerApiForShootingCallbacks:self];
    [[WTUnitySDK sharedSDK] setShootingParams:WTShooting_SD];
}

- (UIView *)viewToOverlayInUnity
{
    float width = self.modelView.frame.size.width;
    
//    self.modelView.hidden = YES;
    self.shootingView.hidden = YES;
    
    {
        UIButton *button = [self createButtonWithTitle:@"Photo" Color:[UIColor greenColor] Action:@selector(takePhotoClicked:)];
        button.center = CGPointMake(100, 50);
        [self.shootingView addSubview:button];
        self.takePhotoButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Start Video" Color:[UIColor greenColor] Action:@selector(startVideoClicked:)];
        button.center = CGPointMake(width-120, 50);
        [self.shootingView addSubview:button];
        self.startVideoButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Stop Video" Color:[UIColor greenColor] Action:@selector(stopVideoClicked:)];
        button.center = CGPointMake(width-120, 150);
        [self.shootingView addSubview:button];
        self.stopVideoButton = button;
        self.stopVideoButton.enabled = NO;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Back To Main" Color:[UIColor redColor] Action:@selector(backButtonClicked:)];
        button.center = CGPointMake(100, 150);
        [self.shootingView addSubview:button];
        self.backButton = button;
    }
    
    [self.modelButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.mvxButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchButton addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];


    return self.containerView;
}

- (IBAction)modelSelected:(id)sender
{
    NSLog(@"modelSelected");
    if (sender == self.mvxButton) {
        NSLog(@"Use Mvx");
        NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
        NSString *modelName = @"1.mvx";
        NSString *modelPath = [dir stringByAppendingPathComponent:modelName];
        [[WTUnitySDK sharedSDK] useMantisVisionModel:modelPath];
    } else if (sender == self.modelButton) {
        NSLog(@"Use Model");
        NSString *dir = [MockingFileHelper modelRootDirectory];
        NSString *modelName = @"Flamingo.glb";
        NSString *modelPath = [dir stringByAppendingPathComponent:modelName];
        [[WTUnitySDK sharedSDK] useCommon3DModel:modelPath];
    }
    [self switchView];
}

- (void)switchView
{
    self.modelView.hidden = !self.modelView.hidden;
    self.shootingView.hidden = !self.shootingView.hidden;
}

- (void)switchButtonClicked:(id)sender
{
    [self switchView];
}

- (void)backButtonClicked:(id)sender
{
    [[WTUnitySDK sharedSDK] showNativeWindow];
}

- (void)takePhotoClicked:(id)sender
{
    NSLog(@"takePhotoClicked");
    [[WTUnitySDK sharedSDK] takePhoto:@"HD"];
}

- (void)startVideoClicked:(id)sender
{
    NSLog(@"startVideoClicked");
    [[WTUnitySDK sharedSDK] startRecordingVideo:@"HD"];
    self.startVideoButton.enabled = NO;
    self.stopVideoButton.enabled = YES;
}

- (void)stopVideoClicked:(id)sender
{
    NSLog(@"stopVideoClicked");
    [[WTUnitySDK sharedSDK] stopRecordingVideo];
    self.startVideoButton.enabled = YES;
    self.stopVideoButton.enabled = NO;
}

- (UIButton *)createButtonWithTitle:(NSString *)title Color:(UIColor *)color Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 120, 44);
    button.backgroundColor = color;
    [button addTarget:self action:action forControlEvents:UIControlEventPrimaryActionTriggered];
    return button;
}


- (void)unityDidFinishPhotoing:(NSString *)pID withPath:(NSString *)path
{
    NSLog(@"unityDidFinishPhotoing: %@, %@", pID, path);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSLog(@"Exist: %d", isExist);
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSLog(@"Image: %d/%d", (int)image.size.width, (int)image.size.height);
}

- (void)unityDidStartRecording:(NSString *)vID
{
    NSLog(@"unityDidStartRecording: %@", vID);
}


- (void)unityDidFinishRecording:(NSString *)vID withPath:(NSString *)path
{
    NSLog(@"unityDidFinishRecording: %@, %@", vID, path);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSLog(@"Exist: %d", isExist);
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
    unsigned long long length = [fileAttributes fileSize];
    float fileSize = length/1024.0/1024.0;
    NSLog(@"VideSize: %.2f MB", fileSize);

}

@end
