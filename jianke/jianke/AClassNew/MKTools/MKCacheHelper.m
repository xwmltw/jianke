//
//  MKCacheHelper.m
//  jianke
//
//  Created by xiaomk on 16/3/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKCacheHelper.h"
#import "WDConst.h"

@implementation MKCacheHelper

static const NSString * jianke_plistFileSuffix = @"_jk.plist";

#pragma mark - 保存 字符 到 写入文件
+ (void)saveToFileWithString:(NSString*)str fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear{
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    BOOL bRet = [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (bRet) {
        DLog(@"保存成功");
    }else{
        DLog(@"保存失败");
    }
    NSAssert(bRet, @"====saveDicToFile error");
}

+ (NSString*)getStringWithFileName:(NSString*)fileName isCanClear:(BOOL)isCanClear{
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSData* data = [[NSData alloc] init];
//        data = [NSData dataWithContentsOfFile:filePath];
//        NSString* content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        return content;
    }
    return nil;
}


#pragma mark - 将model 转 字典 写入文件
+ (void)saveToFileWithModel:(id)model fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear{
    
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    NSString* str = [model simpleJsonString];
    BOOL bRet = [str writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    if (bRet) {
        DLog(@"保存成功");
    }else{
        DLog(@"保存失败");
    }
    NSAssert(bRet, @"====saveCacheToFile error");
}

+ (id)getModelWithFileName:(NSString *)fileName withClass:(Class)clazz isCanClear:(BOOL)isCanClear{
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError* error;
//        NSData* content = [NSData dataWithContentsOfFile:filePath];
//        NSString* jsonString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];

        NSString* jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        return [clazz objectWithKeyValues:dic];
    }
    return nil;
}

#pragma mark - NSKeyedUnarchiver 归档
+ (void)saveByNSKeyedUnarchiverWith:(id)data fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear{
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    BOOL bRet = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    if (bRet) {
        DLog(@"保存成功");
    }else{
        DLog(@"保存失败");
    }
    NSAssert(bRet, @"====saveDicToFile error");
}

+ (id)getByNSKeyedUnarchiver:(NSString*)fileName withClass:(Class)clazz isCanClear:(BOOL)isCanClear{
    NSString* filePath = [self getFullPathByFileName:fileName isPlist:NO isCanClear:isCanClear];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        if ([[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] isKindOfClass:clazz]) {
            return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
    }
    return nil;
}


//根据  文件名， 是否是 plist   是否可清除   获取文件的路径
+ (NSString*)getFullPathByFileName:(NSString*)fileName isPlist:(BOOL)isPlist isCanClear:(BOOL)isCanClear{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *folderPath;
    if (isCanClear) {
        folderPath = [cachePath stringByAppendingPathComponent:@"appData"];   //清理
    }else{
        folderPath = [cachePath stringByAppendingPathComponent:@"userData"];  //不清理
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bCreateDir) {
            ELog(@"create failed");
            return nil;
        }else{
            ELog(@"create folderPath:%@",folderPath);
        }
    }
    NSString* filePath;
    if (isPlist) {
        filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,jianke_plistFileSuffix]];
    }else{
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
//    ELog("======filePath:%@",filePath);
    return filePath;
}


#pragma mark - 清理缓存
+ (void)clearCacheFolder{
    NSString* path = [self getCanClearPath];
    [self clearCache:path];
}

+ (float)getCacheFolderSize{
    NSString* path = [self getCanClearPath];
    return [self folderSizeAtPath:path];
}

+ (NSString*)getCanClearPath{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:@"appData"];
    return cachePath;
}

/** 清除缓存 */
+ (void)clearCache:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray* childerFiles = [fileManager subpathsAtPath:path];
        for (NSString* fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
}

/** 计算目录大小 */
+ (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize = 0.0f;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            float fileSize = [self fileSizeAtPath:absolutePath];
            folderSize += fileSize;
        }
    }
    //SDWebImage框架自身计算缓存的实现
    float sdCacheSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    folderSize += sdCacheSize;
    return folderSize;
}

/** 计算文件 缓存大小 */
+ (float)fileSizeAtPath:(NSString*)path{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024/1024.0;
    }
    return 0;
}
@end
