//
//  MockingFileHelper.m
//  ARCameraDemo
//
//  Created by innerpeacer on 2022/4/1.
//

#import "MockingFileHelper.h"
#import "HelperMD5Utils.h"

@implementation MockingFileHelper

+ (NSString *)modelRootDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"Models"];
}

+ (void)checkMockingFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *targetRootDir = [MockingFileHelper modelRootDirectory];
    NSString *sourceRootDir = [[NSBundle mainBundle] pathForResource:@"Models" ofType:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *md5 = [defaults objectForKey:@"ModelMD5"];
    NSString *currentMD5 = [HelperMD5Utils md5ForDirectory:sourceRootDir];
    
    if (md5 != nil && [md5 isEqualToString:currentMD5]) {
        NSLog(@"Model File Not Changed.");
    } else {
        [defaults setObject:currentMD5 forKey:@"ModelMD5"];
        
        NSError *error;
        [fileManager removeItemAtPath:targetRootDir error:&error];
        [fileManager createDirectoryAtPath:targetRootDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        NSDirectoryEnumerator *enumerator;
        enumerator = [fileManager enumeratorAtPath:sourceRootDir];
        NSString *name;
        while (name = [enumerator nextObject]) {
            NSString *sourcePath = [sourceRootDir stringByAppendingPathComponent:name];
            NSString *targetPath = [targetRootDir stringByAppendingPathComponent:name];
            NSString *pathExtension = sourcePath.pathExtension;

            if (pathExtension.length > 0) {
                [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
                if (error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            } else {
                [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        NSLog(@"Model file has changed, remove old ones and copy new ones.");
    }
}

@end
