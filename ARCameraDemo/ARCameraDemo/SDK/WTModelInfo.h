//
//  WTModelInfo.h
//  ARCameraDemo
//
//  Created by 陈波 on 2022/7/22.
//

#import <Foundation/Foundation.h>
#import "WTUnitySDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTAnimatinoClip : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *clipName;

@end

@interface WTAnimation : NSObject

@property (nonatomic, strong) WTAnimatinoClip *defaultClip;
@property (nonatomic, strong) NSArray<WTAnimatinoClip *> *clips;

- (WTAnimatinoClip *)findClip:(NSString *)name;

@end

@interface WTModelInfo : NSObject

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, readonly) WTModelType modelType;
@property (nonatomic, strong) WTAnimation *animation;

+ (WTModelInfo *)modelInfoFromFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
