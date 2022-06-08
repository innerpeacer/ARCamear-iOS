//
//  UniversalTestViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/6/1.
//

#import "UniversalTestViewController.h"
#import "MockingFileHelper.h"

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
        scene = [WTUnitySDK virtualWorldScene];
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
        [self unityTest];
    }
}

- (void)showNativeWindow
{
    NSLog(@"showNativeWindow");
    [[WTUnitySDK sharedSDK] showNativeWindow];
//    [[WTUnitySDK sharedSDK] virtualWorldStopRecordingVideo];
}

- (void)testButtonClicked:(id)sender
{
    [[WTUnitySDK sharedSDK] virtualWorldTakePhoto:@"1"];
//    [[WTUnitySDK sharedSDK] virtualWorldStartRecordingVideo:@"1"];
}

- (void)unityTest
{
    NSLog(@"unityTest");
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"MVX"];
    NSString *modelName = @"1";
    NSString *modelPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mvx", modelName]];
    [[WTUnitySDK sharedSDK] virtualWorldLoadModelWithPath:modelPath];
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
        UIButton *button = [self createButtonWithTitle:@"Unity Test" Color:[UIColor blueColor] Action:@selector(testButtonClicked:)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.universalTestButton = button;
    }
}

@end
