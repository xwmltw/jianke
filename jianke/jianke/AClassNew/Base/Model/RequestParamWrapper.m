//
//  RequestParamWrapper.m
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "RequestParamWrapper.h"
#import "WDConst.h"

@implementation RequestParamWrapper

- (NSString*)getContent{
    NSMutableString* ret = [[NSMutableString alloc] init];
    
    if (self.queryParam) {
        NSDictionary* param = [self.queryParam keyValues];
        NSString* str = [param jsonStringWithPrettyPrint:YES];
        [ret appendFormat:@"query_param:%@",str];
    }
    
    if (_content && _content.length) {
        if (ret.length) {
            [ret appendString:@","];
        }
        [ret appendString:_content];
    }
    return ret;
}
@end
