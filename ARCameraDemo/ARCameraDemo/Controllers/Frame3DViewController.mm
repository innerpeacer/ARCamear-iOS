//
//  Frame3DViewController.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/5/27.
//

#import "Frame3DViewController.h"
#import "MockingFileHelper.h"

@interface Frame3DViewController ()

@property(nonatomic, strong) WTUnityContainerView *containerView;

@property(nonatomic, strong) UIButton *returnToNativeButton;
@property(nonatomic, strong) UIButton *loadFrame3DButton;

@end

@implementation Frame3DViewController


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

- (void)unityDidLoadEntryScene
{
    [[WTUnitySDK sharedSDK] switchToScene:@"Frame3DTest"];
}

- (void)unityDidLoadScene:(NSString *)sceneName
{
    NSLog(@"======== Did Load Scene: %@", sceneName);
    if ([sceneName isEqualToString:@"Frame3DTest"]) {
        [self loadFrame3DModel];
    }
}

- (void)unityDidUnloadScene:(NSString *)sceneName
{
    NSLog(@"======== Did UnLoad Scene: %@", sceneName);
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
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.containerView = [[WTUnityContainerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    {
        UIButton *button = [self createButtonWithTitle:@"Return To Native" Color:[UIColor greenColor] Action:@selector(showNativeWindow)];
        button.center = CGPointMake(100, 100);
        [self.containerView addSubview:button];
        self.returnToNativeButton = button;
    }

    {
        UIButton *button = [self createButtonWithTitle:@"Load Frame3D" Color:[UIColor blueColor] Action:@selector(loadFrame3DModel)];
        button.center = CGPointMake(300, 100);
        [self.containerView addSubview:button];
        self.loadFrame3DButton = button;
    }
}

- (void)loadFrame3DModel
{
    NSString *dir = [[MockingFileHelper modelRootDirectory] stringByAppendingPathComponent:@"Frame3D"];
    NSString *modelName = @"1";
    NSString *modelPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.glb", modelName]];
    NSString *modelInfoPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", modelName]];

    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"modelPath": modelPath, @"modelInfoPath": modelInfoPath} options:kNilOptions error:nil];
    NSString *params = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[WTUnitySDK ufw] sendMessageToGOWithName:"Frame3DController" functionName:"LoadFrame3dModel" message:params.UTF8String];
}

@end
