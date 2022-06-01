//
//  UniversalTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/6/1.
//

#import "UniversalTestViewController.h"

@interface UniversalTestViewController ()
{
    NSString *scene;
}

@property(nonatomic, strong) WTUnityContainerView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *universalTestButton;

@end

@implementation UniversalTestViewController

- (id)init
{
    if (self = [super init]) {
        [self initButtons];
        scene = @"VideoTextureTest";
    }
    return self;
}

- (void)unityDidLoadEntryScene
{
    [[WTUnitySDK sharedSDK] switchToScene:scene];
}

- (void)unityDidLoadScene:(NSString *)sceneName
{
    NSLog(@"======== Did Load Scene: %@", sceneName);
    if ([sceneName isEqualToString:scene]) {
        
    }
}

- (void)showNativeWindow
{
    NSLog(@"showNativeWindow");
    [[WTUnitySDK sharedSDK] showNativeWindow];
}

- (void)unityTest
{
    NSLog(@"unityTest");
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
        UIButton *button = [self createButtonWithTitle:@"Unity Test" Color:[UIColor blueColor] Action:@selector(unityTest)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.universalTestButton = button;
    }
}

@end
