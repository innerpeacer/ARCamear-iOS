//
//  HelperMD5Utils.h
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/10/12.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperMD5Utils : NSObject

+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5ForFile:(NSString *)path;

+ (NSString *)md5ForDirectory:(NSString *)dir;

@end
