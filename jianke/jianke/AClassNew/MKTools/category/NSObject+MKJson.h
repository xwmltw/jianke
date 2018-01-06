//
//  NSObject+MKJson.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(MKJson)

- (NSString *)mk_jsonStringWithPrettyPrint:(BOOL)prettyPrint;
- (NSString *)mk_jsonString;
- (NSString *)mk_jsonStringNoBrace;
@end
