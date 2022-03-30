//#import <UIKit/UIKit.h>
//
//#include <UnityFramework/UnityFramework.h>
//#include <UnityFramework/NativeCallProxy.h>
//
//@interface MyViewController : UIViewController
//@end
//
//@interface AppDelegate : UIResponder <UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol>
//
//@property(strong, nonatomic) UIWindow *window;
//@property(nonatomic, strong) UIButton *showUnityOffButton;
//@property(nonatomic, strong) UIButton *btnSendMsg;
//@property(nonatomic, strong) UINavigationController *navVC;
//@property(nonatomic, strong) UIButton *unloadBtn;
//@property(nonatomic, strong) UIButton *quitBtn;
//@property(nonatomic, strong) MyViewController *viewController;
//
//
//@property UnityFramework *ufw;
//@property bool didQuit;
//
//- (void)initUnity;
//
//- (void)ShowMainView;
//
//
//@end
//
//AppDelegate *hostDelegate = NULL;
//
//// -------------------------------
//// -------------------------------
//// -------------------------------
//
//
//@interface MyViewController ()
//@property(nonatomic, strong) UIButton *unityInitBtn;
//@property(nonatomic, strong) UIButton *unpauseBtn;
//@property(nonatomic, strong) UIButton *unloadBtn;
//@property(nonatomic, strong) UIButton *quitBtn;
//@end
//
//@implementation MyViewController
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blueColor];
//
//    // INIT UNITY
//    [self.unityInitBtn addTarget:hostDelegate action:@selector(initUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
//
//    // SHOW UNITY
//    [self.unpauseBtn addTarget:hostDelegate action:@selector(ShowMainView) forControlEvents:UIControlEventPrimaryActionTriggered];
//
//    // UNLOAD UNITY
//    [self.unloadBtn addTarget:hostDelegate action:@selector(unloadButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
//
//    // QUIT UNITY
//    [self.quitBtn addTarget:hostDelegate action:@selector(quitButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
//}
//
//@end
//
//
//// keep arg for unity init from non main
//int gArgc = 0;
//char **gArgv = nullptr;
//NSDictionary *appLaunchOpts;
//
//
//@implementation AppDelegate
//
//- (bool)unityIsInitialized {
//    return [self ufw] && [[self ufw] appController];
//}
//
//- (void)ShowMainView {
//    if (![self unityIsInitialized]) {
//        showAlert(@"Unity is not initialized", @"Initialize Unity first");
//    } else {
//        [[self ufw] showUnityWindow];
//    }
//}
//
//- (void)showHostMainWindow {
//    [self showHostMainWindow:@""];
//}
//
//- (void)showHostMainWindow:(NSString *)color {
//    if ([color isEqualToString:@"blue"]) self.viewController.unpauseBtn.backgroundColor = UIColor.blueColor;
//    else if ([color isEqualToString:@"red"]) self.viewController.unpauseBtn.backgroundColor = UIColor.redColor;
//    else if ([color isEqualToString:@"yellow"]) self.viewController.unpauseBtn.backgroundColor = UIColor.yellowColor;
//    [self.window makeKeyAndVisible];
//}
//
//- (void)sendMsgToUnity {
//    [[self ufw] sendMessageToGOWithName:"Cube" functionName:"ChangeColor" message:"yellow"];
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    hostDelegate = self;
//    appLaunchOpts = launchOptions;
//
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor redColor];
//    //ViewController *viewcontroller = [[ViewController alloc] initWithNibName:nil Bundle:nil];
//    self.viewController = [[MyViewController alloc] init];
//    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = self.navVC;
//    [self.window makeKeyAndVisible];
//
//    return YES;
//}
//
//    auto view = [[[self ufw] appController] rootView];
//
//    if (self.showUnityOffButton == nil) {
//        [self.showUnityOffButton addTarget:self action:@selector(showHostMainWindow) forControlEvents:UIControlEventPrimaryActionTriggered];
//        [self.btnSendMsg addTarget:self action:@selector(sendMsgToUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
//        [self.unloadBtn addTarget:self action:@selector(unloadButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
//        [self.quitBtn addTarget:self action:@selector(quitButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
//    }
//}
//
//- (void)unloadButtonTouched:(UIButton *)sender {
//    if (![self unityIsInitialized]) {
//        showAlert(@"Unity is not initialized", @"Initialize Unity first");
//    } else {
//        [UnityFrameworkLoad() unloadApplication];
//    }
//}
//
//- (void)quitButtonTouched:(UIButton *)sender {
//    if (![self unityIsInitialized]) {
//        showAlert(@"Unity is not initialized", @"Initialize Unity first");
//    } else {
//        [UnityFrameworkLoad() quitApplication:0];
//    }
//}
//
//
//@end
//
//
