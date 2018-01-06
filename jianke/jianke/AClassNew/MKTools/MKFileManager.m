//
//  MKFileManager.m
//  jianke
//
//  Created by xiaomk on 16/3/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKFileManager.h"

@implementation MKFileManager

/** App 路径 */
+ (NSString*)homePath{
    NSString *homePath = NSHomeDirectory();
    return homePath;
}

/** 获取Documents目录 */
+ (NSString *)documentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    return documentPath;
}
/** 获取Cache目录 */
+ (NSString *)cachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    return cachePath;
}

/** 获取Tmp目录 */
+ (NSString *)tmpPath{
    NSString *tmpPath = NSTemporaryDirectory();
    return tmpPath;
}

/** 创建文件夹 */
+ (void)createDir:(NSString*)dir{
    NSString *documentPath = [self documentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirDirectory = [documentPath stringByAppendingPathComponent:dir];
    // 创建目录
    BOOL res = [fileManager createDirectoryAtPath:dirDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        ELog(@"文件夹创建成功");
    }else{
        ELog(@"文件夹创建失败");
    }
}

//创建文件
+ (void)createFile:(NSString*)file{
//    NSError *error;
//    [[NSFileManager defaultManager]   createDirectoryAtPath: [NSString stringWithFormat:@"%@/myFolder", NSHomeDirectory()] attributes:nil];

    NSString *documentsPath = [self documentPath];
//    NSString *fileDirectory = [documentsPath stringByAppendingPathComponent:file];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    if (res) {
        ELog(@"文件创建成功: %@" ,filePath);
    }else{
        ELog(@"文件创建失败");
    }
}

/** 写文件 */
+ (void)writeFileOnPath:(NSString*)path textString:(NSString*)textStr{
    BOOL res = [textStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        ELog(@"文件写入成功");
    }else{
        ELog(@"文件写入失败");
    }
}

/** 读文件 */
+ (NSString*)readFileWithPath:(NSString*)path{
    //    NSData *data = [NSData dataWithContentsOfFile:testPath];
    //    NSLog(@"文件读取成功: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

/** 删除文件 */
+ (void)deleteFileWithPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isExecutableFileAtPath:path]) {
        BOOL res = [fileManager removeItemAtPath:path error:nil];
        if (res) {
            ELog(@"文件删除成功");
        }else{
            ELog(@"文件删除失败");
        }
    }else{
        ELog(@"文件不存在");
    }
}

/** 判断是否是为目录 */
+ (BOOL)isDir:(NSString*)path{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir){//目录
        return YES;
    }else{  // 不存在 || 不是目录
        return NO;
    }
}

/** 文件属性 */
+ (NSDictionary*)fileAttriutesWithFilePath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    return fileAttributes;
//    NSArray *keys;
//    id key, value;
//    keys = [fileAttributes allKeys];
//    NSInteger count = [keys count];
//    for (NSInteger i = 0; i < count; i++){
//        key = [keys objectAtIndex: i];
//        value = [fileAttributes objectForKey: key];
//        ELog (@"Key: %@ for value: %@", key, value);
//    }
}








@end
