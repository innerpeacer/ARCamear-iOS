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


@interface ARCameraViewController() <WTUnityOverlayViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *shootingView;
@property (weak, nonatomic) IBOutlet UIView *modelView;
@property (weak, nonatomic) IBOutlet UIButton *modelButton;
@property (weak, nonatomic) IBOutlet UIButton *mvxButton;

@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *takeVideoButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation ARCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ARCameraViewController.viewDidLoad");
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
        UIButton *button = [self createButtonWithTitle:@"Video" Color:[UIColor greenColor] Action:@selector(takeVideoClicked:)];
        button.center = CGPointMake(width-100, 50);
        [self.shootingView addSubview:button];
        self.takeVideoButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Back To Main" Color:[UIColor redColor] Action:@selector(backButtonClicked:)];
        button.center = CGPointMake(100, 150);
        [self.shootingView addSubview:button];
        self.backButton = button;
    }
    
    [self.modelButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.mvxButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];


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
        [[WTUnitySDK ufw] sendMessageToGOWithName:"AppObject" functionName:"UseMvx" message:modelPath.UTF8String];
    } else if (sender == self.modelButton) {
        NSLog(@"Use Model");
        NSString *dir = [MockingFileHelper modelRootDirectory];
        NSString *modelName = @"Flamingo.glb";
        NSString *modelPath = [dir stringByAppendingPathComponent:modelName];
        [[WTUnitySDK ufw] sendMessageToGOWithName:"AppObject" functionName:"UseModel" message:modelPath.UTF8String];
    }
}

- (void)backButtonClicked:(id)sender
{
    [[WTUnitySDK sharedSDK] showNativeWindow];
}

- (void)takePhotoClicked:(id)sender
{
    NSLog(@"takePhotoClicked");
}

- (void)takeVideoClicked:(id)sender
{
    NSLog(@"takeVideoClicked");
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

@end
