//
//  WDCacheInfo.h
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *Cache_IM_UserMap = @"Cache_IM_UserMap";
static NSString *Cache_IM_UserMapEmployer = @"Cache_IM_UserMapEmployer";
static NSString *Cache_IM_FuncMap = @"Cache_IM_FuncMap";
static NSString *Cache_IM_UserMapGroup = @"Cache_IM_UserMapGroup";

@interface WDCache : NSObject

+ (NSString*)getFullNameByFileName:(NSString*)fileName isPlist:(BOOL)isPlist;

+ (void)saveCacheToFile:(id)cache fileName:(NSString*)fileName;
+ (id)getCacheFromFile:(NSString *)fileName withClass:(Class)clazz;

+ (void)saveDicToFile:(NSDictionary*)dic fileName:(NSString*)fileName;
+ (NSDictionary*)getDicFromFile:(NSString*)fileName;

+ (void)saveWithNSKeyedUnarchiver:(id)cache fileName:(NSString*)fileName;
+ (id)getWithNSKeyedUnarchiver:(NSString*)fileName withClass:(Class)clazz;

@end
