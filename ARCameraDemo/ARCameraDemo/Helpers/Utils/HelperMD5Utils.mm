//
//  HelperMD5Utils.m
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/10/12.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "HelperMD5Utils.h"
#include "HelperMD5.hpp"

using namespace Innerpeacer::AppDemo;

@implementation HelperMD5Utils

+ (NSString *)md5:(NSString *)str
{
    HelperMD5 md5([str UTF8String]);
    return [NSString stringWithUTF8String:md5.toString().c_str()];
}

+ (NSString *)md5ForFile:(NSString *)path
{
    std::ifstream in([path UTF8String], std::ios::in|std::ios::binary);
    HelperMD5 md5(in);
    
    return [NSString stringWithUTF8String:md5.toString().c_str()];
}

+ (NSString *)md5ForDirectory:(NSString *)dir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    enumerator = [fileManager enumeratorAtPath:dir];
    
    NSString *name;
    HelperMD5 fileMD5;
    
    while (name = [enumerator nextObject]) {
        NSString *sourcePath = [dir stringByAppendingPathComponent:name];
        std::ifstream in([sourcePath UTF8String], std::ios::in|std::ios::binary);
        fileMD5.update(in);
    }
    
    return [NSString stringWithUTF8String:fileMD5.toString().c_str()];
}

@end
