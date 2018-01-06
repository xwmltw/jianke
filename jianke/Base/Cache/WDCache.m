//
//  WDCacheInfo.m
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDCache.h"
#import "WDConst.h"
#import "NSObject+MJKeyValue.h"

static const NSString * jianke_plistFileName = @"_jk.plist";

@implementation WDCache

#pragma mark - getCacheFilePath
+ (NSString*)getFullNameByFileName:(NSString*)fileName isPlist:(BOOL)isPlist {
    
    NSString *recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    
    if (isPlist) {
        fileName = [NSString stringWithFormat:@"%@/%@%@", recorderPath, fileName, jianke_plistFileName];
    }else{
        fileName = [NSString stringWithFormat:@"%@/%@", recorderPath, fileName];
    }
//    ELog("======fileName:%@",fileName);
    return fileName;
}

+ (NSString*)getFullNameByFileName:(NSString*)fileName {
    return [self getFullNameByFileName:fileName isPlist:NO];
}

#pragma mark - writeToFile
// 保存 模型 到 文本
+ (NSString*)getContentFromFile:(NSString*)fileName {
    
    fileName = [self getFullNameByFileName:fileName];
    NSData* content = [NSData dataWithContentsOfFile:fileName];
    return [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
}

+ (void)saveCacheToFile:(id)cache fileName:(NSString*)fileName{
    
    NSString* filePath = [self getFullNameByFileName:fileName];
    NSString* str = [cache simpleJsonString];
    __unused BOOL result = [str writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSAssert(result, @"====saveCacheToFile error");
}

+ (id)getCacheFromFile:(NSString *)fileName withClass:(Class)clazz{
    NSString* cache = [self getContentFromFile:fileName];
    if (cache) {
        NSError* error;
        NSData* data = [cache dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        return [clazz objectWithKeyValues:dic];
    }
    return nil;
}

//保存 字典 到 plist
+ (void)saveDicToFile:(NSDictionary*)dic fileName:(NSString*)fileName{
    NSString* filePath = [self getFullNameByFileName:fileName isPlist:YES];
    __unused BOOL result = [dic writeToFile:filePath atomically:YES];
    NSAssert(result, @"====saveDicToFile error");
}

+ (NSDictionary*)getDicFromFile:(NSString*)fileName{
    NSString* filePath = [self getFullNameByFileName:fileName isPlist:YES];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}


#pragma mark - NSKeyedUnarchiver
//归档
+ (void)saveWithNSKeyedUnarchiver:(id)cache fileName:(NSString*)fileName{
    NSString* filePath = [self getFullNameByFileName:fileName isPlist:YES];
    __unused BOOL bRet = [NSKeyedArchiver archiveRootObject:cache toFile:filePath];
    NSAssert(bRet, @"====saveWithNSKeyedUnarchiver error");
}

+ (id)getWithNSKeyedUnarchiver:(NSString*)fileName withClass:(Class)clazz{
    NSString* filePath = [self getFullNameByFileName:fileName isPlist:YES];
    
    if ([[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] isKindOfClass:clazz]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    NSAssert(NO, @"====getWithNSKeyedUnarchiver error");
    return nil;
}

@end
