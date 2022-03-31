//
//  main.cpp
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/3/30.
//

#import "AppDelegate.h"
#import "WTUnitySDK.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    [[WTUnitySDK sharedSDK] runInMainWithArgc:argc argv:argv];
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
