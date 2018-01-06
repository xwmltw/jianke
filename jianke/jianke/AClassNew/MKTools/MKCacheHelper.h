//
//  MKCacheHelper.h
//  jianke
//
//  Created by xiaomk on 16/3/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKCacheHelper : NSObject


#pragma mark - 保存 字符 到 写入文件
/** 保存 字符 写入到文件*/
+ (void)saveToFileWithString:(NSString*)str fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear;
/** 从文件 获取 字符串 */
+ (NSString*)getStringWithFileName:(NSString*)fileName isCanClear:(BOOL)isCanClear;

#pragma mark - 将model 转 字典 写入文件
/** 将模型写入到文件*/
+ (void)saveToFileWithModel:(id)model fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear;
/** 从文件 获取 模型*/
+ (id)getModelWithFileName:(NSString *)fileName withClass:(Class)clazz isCanClear:(BOOL)isCanClear;

#pragma mark - NSKeyedUnarchiver 归档
/** 归档 到 文件*/
+ (void)saveByNSKeyedUnarchiverWith:(id)data fileName:(NSString*)fileName isCanClear:(BOOL)isCanClear;
/** 从 文件 获取归档信息*/
+ (id)getByNSKeyedUnarchiver:(NSString*)fileName withClass:(Class)clazz isCanClear:(BOOL)isCanClear;

/** 清除 缓存文件*/
+ (void)clearCacheFolder;
/** 获取缓存 大小*/
+ (float)getCacheFolderSize;

/** 清理 指定路径缓存*/
+ (void)clearCache:(NSString*)path;
/** 计算指定文件夹大小*/
+ (float)folderSizeAtPath:(NSString *)path;
/** 计算 文件大小*/
+ (float)fileSizeAtPath:(NSString*)path;

@end
