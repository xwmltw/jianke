//
//  MKBaseModel.m
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"
#import "MJExtension.h"
#import "NSObject++Json.h"

@implementation MKBaseModel
MJCodingImplementation
- (instancetype)init{
    self = [super init];
    if (self) {
        //        ELog(@"======ParamModel init()");
    }
    return self;
}
- (NSString *)getContent{
    if (self) {
        NSDictionary* dic = [self keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
        NSUInteger strLength = [str length];
        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return param;
    }
    return nil;
}
@end

@implementation UserInfoModel
MJCodingImplementation
@end