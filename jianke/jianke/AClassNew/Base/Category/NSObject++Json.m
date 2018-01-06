//
//  NSObject++Json.m
//  ShiJianKe
//
//  Created by hlw on 15/3/3.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "NSObject++Json.h"
#import "MJExtension.h"

@implementation NSObject (JsonExt)

- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        ELog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString*)simpleJsonString {
    NSDictionary* dic = [self keyValues];
    return [dic jsonStringWithPrettyPrint:YES];
}



@end
