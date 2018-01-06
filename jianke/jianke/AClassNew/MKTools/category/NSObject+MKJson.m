//
//  NSObject+MKJson.m
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "NSObject+MKJson.h"
#import "MJExtension.h"

@implementation NSObject(MKJson)

- (NSString *)mk_jsonStringWithPrettyPrint:(BOOL)prettyPrint{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        ELog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString *)mk_jsonString{
    NSDictionary* dic = [self keyValues];
    return [dic mk_jsonStringWithPrettyPrint:YES];
}

- (NSString *)mk_jsonStringNoBrace{
    if (self) {
        NSDictionary* dic = [self keyValues];
        NSString* str = [dic mk_jsonStringWithPrettyPrint:YES];
        NSUInteger strLength = [str length];
        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return param;
    }
    return nil;
}

@end

