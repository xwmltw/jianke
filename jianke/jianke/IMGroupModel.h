//
//  IMGroupModel.h
//  jianke
//
//  Created by fire on 16/1/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//  群组列表中的群组模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface IMGroupModel : NSObject
@property (nonatomic, copy) NSString *groupId;  /*!<群组ID */
@property (nonatomic, copy) NSString *groupUuid; /*!< 群组标识 */
@property (nonatomic, copy) NSString *groupName; /*!< 群名称，String*/
@property (nonatomic, copy) NSString *groupProrileUrl; /*!< 群组头像，String */
@end
