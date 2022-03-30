//
//  UnityAppTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "UnityAppTestViewController.h"
#import "AppDelegate.h"

@interface UnityAppTestViewController ()

@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) UIButton *showHostWindowButton;
@property(nonatomic, strong) UIButton *sendMessageButton;
@property(nonatomic, strong) UIButton *unloadUnityButton;
@property(nonatomic, strong) UIButton *quitUnityButton;

@end

@implementation UnityAppTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"AppTest View Controller";

    [[WTUnitySDK sharedSDK] initUnity];
    
    auto view = [[[WTUnitySDK ufw] appController] rootView];
    NSLog(@"%@", [[[WTUnitySDK ufw] appController] rootView]);
    NSLog(@"%@", self.view);
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%d", self.view.hidden);
    NSLog(@"%@", NSStringFromCGRect(self.showHostWindowButton.frame));

    if (self.showHostWindowButton == nil) {
        [self initButtons];
    }
    [view addSubview:self.containerView];
}

- (void)showNativeWindow
{
    NSLog(@"showNativeWindow");
//    [self.navigationController popViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:YES];
    [[WTUnitySDK sharedSDK] unloadUnity];
    [[WTUnitySDK sharedSDK] showNativeWindow];
    
}

- (void)unloadUnity
{
    [[WTUnitySDK sharedSDK] unloadUnity];
}

- (void)initButtons {
    NSLog(@"initButtons");
    self.containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.containerView.backgroundColor = [UIColor blueColor];
//    self.containerView.alpha = 0.5;
    {
        self.showHostWindowButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.showHostWindowButton setTitle:@"Show Host" forState:UIControlStateNormal];
        self.showHostWindowButton.frame = CGRectMake(0, 0, 150, 44);
        self.showHostWindowButton.center = CGPointMake(100, 300);
        self.showHostWindowButton.backgroundColor = [UIColor greenColor];
        [self.containerView addSubview:self.showHostWindowButton];
        [self.showHostWindowButton addTarget:self action:@selector(showNativeWindow) forControlEvents:UIControlEventPrimaryActionTriggered];
    }

    {
        self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
        self.sendMessageButton.frame = CGRectMake(0, 0, 150, 44);
        self.sendMessageButton.center = CGPointMake(100, 350);
        self.sendMessageButton.backgroundColor = [UIColor yellowColor];
        [self.containerView addSubview:self.sendMessageButton];
//                [self.sendMessageButton addTarget:self action:@selector(sendMsgToUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
    }

    {
        self.unloadUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.unloadUnityButton setTitle:@"Unload" forState:UIControlStateNormal];
        self.unloadUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.unloadUnityButton.center = CGPointMake(300, 300);
        self.unloadUnityButton.backgroundColor = [UIColor redColor];
        [self.containerView addSubview:self.unloadUnityButton];
        [self.unloadUnityButton addTarget:self action:@selector(unloadUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
    }

    {
        self.quitUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.quitUnityButton setTitle:@"Quit" forState:UIControlStateNormal];
        self.quitUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.quitUnityButton.center = CGPointMake(300, 350);
        self.quitUnityButton.backgroundColor = [UIColor redColor];
        [self.containerView addSubview:self.quitUnityButton];
//        [self.quitUnityButton addTarget:self action:@selector(quitButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
    }
}

@end
