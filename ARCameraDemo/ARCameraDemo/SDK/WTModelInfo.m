//
//  WTModelInfo.m
//  ARCameraDemo
//
//  Created by 陈波 on 2022/7/22.
//

#import "WTModelInfo.h"

@implementation WTAnimatinoClip

@end

@implementation WTAnimation

- (WTAnimatinoClip *)findClip:(NSString *)name
{
    for (WTAnimatinoClip *clip in _clips) {
        if ([clip.name isEqualToString:name]) {
            return clip;
        }
    }
    return nil;
}

@end

@implementation WTModelInfo

+ (WTModelInfo *)modelInfoFromFile:(NSString *)path
{
    WTModelInfo *modelInfo = [[WTModelInfo alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];

    modelInfo.modelName = dict[@"name"];
    NSString *typeStr = dict[@"type"];
    WTModelType type = WTModel_Unknown;
    if ([typeStr isEqualToString:@"MantisHD"]) {
        type = WTModel_MantisVisionHD;
    } else if ([typeStr isEqualToString:@"3D"]) {
        type = WTModel_Common3D;
    } else if ([typeStr isEqualToString:@"WAB"]) {
        type = WTModel_AssetBundles;
    }
    
    NSDictionary *animationDict = dict[@"animations"];
    if (animationDict && animationDict[@"clips"]) {
        WTAnimation *animation = [[WTAnimation alloc] init];
        NSMutableArray *clipArray = [NSMutableArray array];
        for (NSDictionary *clipDict in animationDict[@"clips"]) {
            WTAnimatinoClip *clip = [[WTAnimatinoClip alloc] init];
            clip.name = clipDict[@"name"];
            clip.clipName = clipDict[@"clipName"];
            [clipArray addObject:clip];
        }
        animation.clips = clipArray;
        
        if (animationDict[@"default"]) {
            animation.defaultClip = [animation findClip:animationDict[@"default"]];
        }
        modelInfo.animation = animation;
    }
    return modelInfo;
}
@end
