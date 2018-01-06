//
//  IMGroupDetailModel.h
//  jianke
//
//  Created by fire on 16/1/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//  群组资料模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface IMGroupDetailModel : NSObject
@property (nonatomic, copy) NSString *groupUuid; /*!< 群组标识 */
@property (nonatomic, copy) NSString *groupName; /*!< 群名称，String */
@property (nonatomic, copy) NSString *groupProrileUrl; /*!< 群组头像，String */
@property (nonatomic, copy) NSNumber *groupOwnerEnt; /*!< 群管理员，Long */
@property (nonatomic, copy) NSNumber *groupOwnerBd; /*!< 群组BD，Long */
@property (nonatomic, strong) NSArray *groupMembers; /*!< 群成员列表, 存放IMGroupMemberModel对象 */
@property (nonatomic, copy) NSNumber *memberNums;   /*!< 群组人数 */
@property (nonatomic, copy) NSString *groupId; /*!< 群组Id */
@end



@interface IMGroupMemberModel : NSObject
@property (nonatomic, copy) NSNumber *accountId; /*!< xxx群成员ID */
@property (nonatomic, copy) NSString *trueName; /*!< xxx群成员姓名 */
@property (nonatomic, copy) NSString *profileUrl; /*!< xxx群成员头像 */
@end