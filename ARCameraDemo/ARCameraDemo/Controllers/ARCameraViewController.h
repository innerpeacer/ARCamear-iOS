//
//  ARCameraViewController.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/4.
//

#import <UIKit/UIKit.h>
#import <UnityFramework/WTNativeCallUnityProxy.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARCameraViewController : UIViewController <WTUnityOverlayViewDelegate, WTUnityShootingCallbackProtocol, WTModelHandlingCallbackProtocol, WTUnitySceneControllerCallbackProtocol>

@end

NS_ASSUME_NONNULL_END
