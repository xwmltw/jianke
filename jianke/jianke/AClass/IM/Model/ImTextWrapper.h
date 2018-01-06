//
//  ImTextWrapper.h
//  ShiJianKe
//
//  Created by hlw on 15/4/8.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImTextWrapper : NSObject


@property (nonatomic, copy) NSNumber* fromType;
@property (nonatomic, copy) NSString* fromUser;
@property (nonatomic, copy) NSString* fromUuid;

@property (nonatomic, copy) NSString* toUser;
@property (nonatomic, copy) NSNumber* toType;
@property (nonatomic, copy) NSString* toUuid;
@property (nonatomic, copy) NSString* pushData;
@property (nonatomic, copy) NSString* packet;
@property (nonatomic, copy) NSString *job_id;

@end
