//
//  UnityAppTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "TestUnityViewController.h"
#import "AppDelegate.h"
#import <UnityFramework/WTNativeCallUnityProxy.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"

@interface TestUnityViewController () <WTUnityOverlayViewDelegate, WTUnityTestingCallbackProtocol>

@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *sendMessageButton;
@property(nonatomic, strong) UIButton *callUnityApiButton;

@end

@implementation TestUnityViewController

- (id)init
{
    if (self = [super init]) {
        [self initButtons];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSClassFromString(@"WTUnityCallbackUtils") registerApiForTestingCallbacks:self];
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

- (void)initButtons {
    NSLog(@"initButtons");
    self.containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    {
        self.returnToNativeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.returnToNativeButton setTitle:@"Return to Native" forState:UIControlStateNormal];
        self.returnToNativeButton.frame = CGRectMake(0, 0, 150, 44);
        self.returnToNativeButton.center = CGPointMake(100, 100);
        self.returnToNativeButton.backgroundColor = [UIColor greenColor];
        [self.containerView addSubview:self.returnToNativeButton];
        [self.returnToNativeButton addTarget:self action:@selector(showNativeWindow) forControlEvents:UIControlEventPrimaryActionTriggered];
    }

    {
        self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.sendMessageButton setTitle:@"Send Unity Message" forState:UIControlStateNormal];
        self.sendMessageButton.frame = CGRectMake(0, 0, 150, 44);
        self.sendMessageButton.center = CGPointMake(100, 350);
        self.sendMessageButton.backgroundColor = [UIColor yellowColor];
        [self.containerView addSubview:self.sendMessageButton];
        [self.sendMessageButton addTarget:self action:@selector(sendUnityMessage) forControlEvents:UIControlEventPrimaryActionTriggered];
    }
    
    {
        self.callUnityApiButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.callUnityApiButton setTitle:@"Call Unity API" forState:UIControlStateNormal];
        self.callUnityApiButton.frame = CGRectMake(0, 0, 150, 44);
        self.callUnityApiButton.center = CGPointMake(300, 350);
        self.callUnityApiButton.backgroundColor = [UIColor blueColor];
        [self.containerView addSubview:self.callUnityApiButton];
        [self.callUnityApiButton addTarget:self action:@selector(callUnityApi) forControlEvents:UIControlEventPrimaryActionTriggered];
    }
}

- (void)sendUnityMessage
{
    NSLog(@"sendUnityMessage");
    NSArray *colorArray = @[@"red", @"blue", @"yellow", @"black"];
    int randomIndex = (int)(arc4random() % 4);
    [[WTUnitySDK ufw] sendMessageToGOWithName:"AppTest" functionName:"ChangeCubeColor" message:[colorArray[randomIndex] UTF8String]];
}

- (void)callUnityApi
{
    NSLog(@"callUnityApi");
    [WTNativeCallUnityProxy testChangeCubeScaleWithXY:arc4random()%2 Z:arc4random()%2];
}

- (void)unityDidChangeCubeColor:(NSString *)color
{
    NSLog(@"Callback From Unity - Changed Color: %@", color);
}

- (void)unityDidChangeCubeScaleXY:(float)xy Z:(float)z
{
    NSLog(@"Callback From Unity - Changed Scale: %f, %f", xy, z);
}

@end
