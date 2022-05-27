//
//  ARPreviewViewController.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/20.
//

#import <UIKit/UIKit.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARPreviewViewController : UIViewController <WTUnityOverlayViewDelegate, WTUnitySceneControllerCallbackProtocol, WTModelHandlingCallbackProtocol>

@end

NS_ASSUME_NONNULL_END
