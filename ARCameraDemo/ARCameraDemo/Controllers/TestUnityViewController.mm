//
//  UnityAppTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "TestUnityViewController.h"
#import "AppDelegate.h"
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"
#import "MockingFileHelper.h"

@interface TestUnityViewController () <WTUnityOverlayViewDelegate, WTUnityTestingCallbackProtocol>

@property(nonatomic, strong) WTUnityContainerView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *sendMessageButton;
@property(nonatomic, strong) UIButton *callUnityApiButton;
@property(nonatomic, strong) UIButton *loadModelButton;
@property(nonatomic, strong) UIButton *loadMvxButton;

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
    [[WTUnitySDK sharedSDK] switchToScene:@"AssetBundleTest"];
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
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.containerView = [[WTUnityContainerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    {
        UIButton *button = [self createButtonWithTitle:@"Return To Native" Color:[UIColor greenColor] Action:@selector(showNativeWindow)];
        button.center = CGPointMake(100, 100);
        [self.containerView addSubview:button];
        self.returnToNativeButton = button;
    }

    {
        UIButton *button = [self createButtonWithTitle:@"Send Unity Message" Color:[UIColor yellowColor] Action:@selector(sendUnityMessage)];
        button.center = CGPointMake(100, screenSize.height - 100);
        [self.containerView addSubview:button];
        self.sendMessageButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Call Unity API" Color:[UIColor yellowColor] Action:@selector(sendUnityMessageWithJson)];
        button.center = CGPointMake(300, screenSize.height - 100);
        [self.containerView addSubview:button];
        self.callUnityApiButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Load Model" Color:[UIColor blueColor] Action:@selector(sendUnityLoadModel)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.loadModelButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"Load Mvx" Color:[UIColor blueColor] Action:@selector(sendUnityLoadMvxModel)];
        button.center = CGPointMake(300, 200);
        [self.containerView addSubview:button];
        self.loadMvxButton = button;
    }
}

- (void)sendUnityMessage
{
    NSLog(@"sendUnityMessage");
    NSArray *colorArray = @[@"red", @"blue", @"yellow", @"black"];
    int randomIndex = (int)(arc4random() % 4);
    [[WTUnitySDK ufw] sendMessageToGOWithName:"AppTest" functionName:"ChangeCubeColor" message:[colorArray[randomIndex] UTF8String]];
}

- (void)sendUnityMessageWithJson
{
    float xy = (arc4random()%100)/50.0f;
    float z = (arc4random()%100)/50.0f;
    NSDictionary *params = @{@"xy":@(xy), @"z":@(z)};
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Params: %@", str);
    [[WTUnitySDK ufw] sendMessageToGOWithName:"AppTest" functionName:"TestChangeCubeScale" message:str.UTF8String];
}


- (void)sendUnityLoadModel
{
    NSLog(@"sendUnityLoadModel");
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"AssetBundles"];;
    NSString *modelName = [NSString stringWithFormat:@"%@.ab", @"girl.ios"];
    
    NSString *modelPath = [dir stringByAppendingPathComponent:modelName];
    [[WTUnitySDK ufw] sendMessageToGOWithName:"AssetBundleController" functionName:"LoadAssetBundle" message:modelPath.UTF8String];
}

- (void)sendUnityLoadMvxModel
{
    NSLog(@"sendUnityLoadMvxModel");
    
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
    
    NSString *modelName = @"1.mvx";
    NSString *modelPath = [dir stringByAppendingPathComponent:modelName];
    [[WTUnitySDK ufw] sendMessageToGOWithName:"AppTest" functionName:"AddMvxModel" message:modelPath.UTF8String];
}

- (void)callUnityApi
{
    NSLog(@"callUnityApi");
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
