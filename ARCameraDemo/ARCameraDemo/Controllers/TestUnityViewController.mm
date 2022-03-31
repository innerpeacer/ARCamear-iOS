//
//  UnityAppTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "TestUnityViewController.h"
#import "AppDelegate.h"

@interface TestUnityViewController () <WTUnityOverlayViewDelegate>

@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *sendMessageButton;
@property(nonatomic, strong) UIButton *unloadUnityButton;
@property(nonatomic, strong) UIButton *quitUnityButton;

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
        [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
        self.sendMessageButton.frame = CGRectMake(0, 0, 150, 44);
        self.sendMessageButton.center = CGPointMake(100, 350);
        self.sendMessageButton.backgroundColor = [UIColor yellowColor];
        [self.containerView addSubview:self.sendMessageButton];
//                [self.sendMessageButton addTarget:self action:@selector(sendMsgToUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
    }
}

@end
