//
//  AppDelegate.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/28.
//

#import "AppDelegate.h"


UnityFramework *UnityFrameworkLoad() {
    NSLog(@"UnityFrameworkLoad");
    
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *bundlePath = [mainBundlePath stringByAppendingString:@"/Frameworks/UnityFramework.framework"];

    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([bundle isLoaded] == false) {
        NSLog(@"[bundle load]");
        [bundle load];
    }
    NSLog(@"isLoaded: %d", [bundle isLoaded]);

    UnityFramework *ufw = [bundle.principalClass getInstance];
    if (![ufw appController]) {
        [ufw setExecuteHeader:&_mh_execute_header];
    }
    return ufw;
}

void ShowAlert(NSString *title, NSString *msg) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];

    auto delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


@interface AppDelegate () <UnityFrameworkListener, NativeCallsProtocol>

@end

static AppDelegate *sharedDelegate = NULL;
int gArgc = 0;
char **gArgv = nullptr;
NSDictionary *appLaunchOpts;

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return sharedDelegate;
}

- (bool)initUnity {
    if ([self unityInitialized]) {
        ShowAlert(@"Unity already initilized", @"Unload Unity first");
        return false;
    }

    if ([self didQuit]) {
        ShowAlert(@"Unity cannot be initilized after quit", @"Use unload instead");
        return false;
    }

    [self setUfw:UnityFrameworkLoad()];
    [[self ufw] setDataBundleId:"com.unity3d.framework"];
    [[self ufw] registerFrameworkListener:self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    
    NSLog(@"ufw: %@", [self ufw]);
    [[self ufw] runEmbeddedWithArgc:gArgc argv:gArgv appLaunchOpts:appLaunchOpts];
    
//    [[self ufw] appController].quitHandler  = ^(){
//        NSLog(@"AppController.quitHander called");
//    };
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sharedDelegate = self;
    appLaunchOpts = launchOptions;
    return YES;
}


- (bool)unityInitialized {
    return [self ufw] && [[self ufw] appController];
}

- (void)showMainView {
    if (![self unityInitialized]) {
        ShowAlert(@"Unity Is Not Initialized!", @"Initialize Unity first.");
    } else {
        [[self ufw] showUnityWindow];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[[self ufw] appController] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[self ufw] appController] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[self ufw] appController] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[[self ufw] appController] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[[self ufw] appController] applicationWillTerminate:application];
}

@end


int main(int argc, char * argv[]) {
    gArgc = argc;
    gArgv = argv;
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
