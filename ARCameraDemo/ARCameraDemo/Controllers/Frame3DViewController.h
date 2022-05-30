//
//  Frame3DViewController.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/5/27.
//

#import <UIKit/UIKit.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface Frame3DViewController : UIViewController <WTUnityOverlayViewDelegate, WTUnitySceneControllerCallbackProtocol>

@end

NS_ASSUME_NONNULL_END
