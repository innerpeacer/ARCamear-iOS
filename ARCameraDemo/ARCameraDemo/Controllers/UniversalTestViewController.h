//
//  UniversalTestViewController.h
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/6/1.
//

#import <UIKit/UIKit.h>
#import <UnityFramework/WTUnityCallNativeProxy.h>
#import "WTUnitySDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversalTestViewController : UIViewController <WTUnityOverlayViewDelegate, WTUnitySceneControllerCallbackProtocol>

@end

NS_ASSUME_NONNULL_END
