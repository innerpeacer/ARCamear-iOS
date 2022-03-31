//
//  MenuViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "MenuViewController.h"
#import "TestUnityViewController.h"
#import "AppDelegate.h"
#import "WTUnitySDK.h"

@interface MenuViewController () <WTUnityViewControllerDelegate>

@property(nonatomic, strong) UIButton *showUnityButton;
@property(nonatomic, strong) UIButton *hideUnityButton;
@property(nonatomic, strong) UIButton *unloadUnityButton;
@property(nonatomic, strong) UIButton *quitUnityButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AR Camera Demo";
    
    [self initButtons];
}

- (void)btnShowUnityWindowClicked:(id)sender
{
    NSLog(@"showUnityButton clicked!");
    TestUnityViewController *controller = [[TestUnityViewController alloc] init];
    [[WTUnitySDK sharedSDK] showUnityWindowFrom:self withController:controller];
}

- (void)unityDidReturnToNativeWindow:(UIViewController *)fromController
{
    NSLog(@"Unity Return to Main");
}

- (void)initButtons {
    self.showUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showUnityButton setTitle:@"Show Unity" forState:UIControlStateNormal];
    self.showUnityButton.frame = CGRectMake(0, 0, 150, 44);
    self.showUnityButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.showUnityButton.backgroundColor = [UIColor greenColor];
    [self.showUnityButton  addTarget:self action:@selector(btnShowUnityWindowClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.showUnityButton];
}

@end
