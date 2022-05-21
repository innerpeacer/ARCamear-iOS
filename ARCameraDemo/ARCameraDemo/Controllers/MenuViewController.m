//
//  MenuViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "MenuViewController.h"
#import "TestUnityViewController.h"
#import "ARCameraViewController.h"
#import "ARPreviewViewController.h"
#import "AppDelegate.h"
#import "WTUnitySDK.h"

@interface MenuViewController () <WTUnityViewControllerDelegate>

@property(nonatomic, strong) UIButton *appTestButton;
@property(nonatomic, strong) UIButton *arCameraButton;
@property(nonatomic, strong) UIButton *arPreviewButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AR Camera Demo";
    
    [self initButtons];
}

- (void)btnAppTestClicked:(id)sender
{
    NSLog(@"showUnityButton clicked!");
    TestUnityViewController *controller = [[TestUnityViewController alloc] init];
    [[WTUnitySDK sharedSDK] showUnityWindowFrom:self withController:controller];
}

- (void)btnARCameraClicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ARCameraViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"arCameraController"];
    [WTUnityCallbackUtils registerApiForSceneControllerCallbacks:controller];
    [WTUnityCallbackUtils registerApiForShootingCallbacks:controller];
    [WTUnityCallbackUtils registerApiForModelHandlingCallbacks:controller];
//    [self.navigationController pushViewController:controller animated:YES];
    [[WTUnitySDK sharedSDK] showUnityWindowFrom:self withController:controller];
}

- (void)btnARPreviewClicked:(id)sender
{
    ARPreviewViewController *controller = [[ARPreviewViewController alloc] init];
    [WTUnityCallbackUtils registerApiForSceneControllerCallbacks:controller];
    [WTUnityCallbackUtils registerApiForModelHandlingCallbacks:controller];
    [[WTUnitySDK sharedSDK] showUnityWindowFrom:self withController:controller];
}

- (void)unityDidReturnToNativeWindow:(UIViewController *)fromController
{
    NSLog(@"Unity Return to Main");
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
    {
        UIButton *button = [self createButtonWithTitle:@"AppTest" Color:[UIColor greenColor] Action:@selector(btnAppTestClicked:)];
        button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 100);
        [self.view addSubview:button];
        self.appTestButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"AR Camera" Color:[UIColor greenColor] Action:@selector(btnARCameraClicked:)];
        button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:button];
        self.arCameraButton = button;
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"AR Preview" Color:[UIColor greenColor] Action:@selector(btnARPreviewClicked:)];
        button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
        [self.view addSubview:button];
        self.arPreviewButton = button;
    }
}

@end
