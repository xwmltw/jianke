//
//  NSObject++Json.h
//  ShiJianKe
//
//  Created by hlw on 15/3/3.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonExt)

- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;

- (NSString*)simpleJsonString;
@end


