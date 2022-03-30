//
//  MenuViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "MenuViewController.h"
#import "UnityAppTestViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@property(nonatomic, strong) UIButton *initializeUnityButton;
@property(nonatomic, strong) UIButton *showUnityButton;
@property(nonatomic, strong) UIButton *unloadUnityButton;
@property(nonatomic, strong) UIButton *quitUnityButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"AR Camera Demo";
//    self.view.backgroundColor = [UIColor greenColor];

    [self initButtons];
}

- (void)btnInitializeUnityClicked:(id)sender
{
    NSLog(@"initializeUnityButton clicked!");
    UnityAppTestViewController *controller = [[UnityAppTestViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:NO];
    [self presentModalViewController:controller animated:YES];
}

- (void)btnShowUnityWindowClicked:(id)sender
{
    NSLog(@"showUnityButton clicked!");
//    [[WTUnitySDK sharedSDK] showUnityWindow];
}

- (void)btnUnloadUnityClicked:(id)sender
{
    NSLog(@"unloadUnityButton clicked!");
    [[WTUnitySDK sharedSDK] unloadUnity];
}

- (void)btnQuitUnityClicked:(id)sender
{
    NSLog(@"quitUnityButton clicked!");
    [[WTUnitySDK sharedSDK] quitUnity];
}

- (void)initButtons {
    {
        self.initializeUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.initializeUnityButton setTitle:@"Init Unity" forState:UIControlStateNormal];
        self.initializeUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.initializeUnityButton.center = CGPointMake(100, 120);
        self.initializeUnityButton.backgroundColor = [UIColor greenColor];
        [self.initializeUnityButton  addTarget:self action:@selector(btnInitializeUnityClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [self.view addSubview:self.initializeUnityButton];
    }

    {
        self.showUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.showUnityButton setTitle:@"Show Unity" forState:UIControlStateNormal];
        self.showUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.showUnityButton.center = CGPointMake(100, 170);
        self.showUnityButton.backgroundColor = [UIColor lightGrayColor];
        [self.showUnityButton addTarget:self action:@selector(btnShowUnityWindowClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [self.view addSubview:self.showUnityButton];
    }

    {
        self.unloadUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.unloadUnityButton setTitle:@"Unload Unity" forState:UIControlStateNormal];
        self.unloadUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.unloadUnityButton.center = CGPointMake(300, 120);
        self.unloadUnityButton.backgroundColor = [UIColor redColor];
        [self.unloadUnityButton  addTarget:self action:@selector(btnUnloadUnityClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [self.view addSubview:self.unloadUnityButton];
    }

    {
        self.quitUnityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.quitUnityButton setTitle:@"Quit Unity" forState:UIControlStateNormal];
        self.quitUnityButton.frame = CGRectMake(0, 0, 150, 44);
        self.quitUnityButton.center = CGPointMake(300, 170);
        self.quitUnityButton.backgroundColor = [UIColor redColor];
        [self.quitUnityButton addTarget:self action:@selector(btnQuitUnityClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [self.view addSubview:self.quitUnityButton];
    }
}

@end
