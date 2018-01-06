//
//  MKBaseModel.h
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MKBaseModel : NSObject
- (NSString *)getContent;

@end


@interface UserInfoModel : MKBaseModel
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *dynamicPassword;
@end