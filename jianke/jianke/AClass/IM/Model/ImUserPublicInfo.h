//
//  ImUserPublicInfo.h
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImConst.h"

@interface ImUserPublicInfo : RCUserInfo

@property (nonatomic, copy) NSString* accountId;  //“和兼客的accountId一致,String”
@property (nonatomic, copy) NSString* nickname;   //“昵称”
@property (nonatomic, copy) NSString* headUrl;    //“头像地址，String”,
@property (nonatomic, copy) NSNumber* sex;        //“int,1:男 0:女”,
@property (nonatomic, copy) NSNumber* resumeId;   //简历id
@property (nonatomic, copy) NSNumber* version;    //版本
@property (nonatomic, copy) NSString* uuid;       //用来通过融云发送单聊消息给对方

@property (nonatomic, copy) NSString* signature;  //“个人签名，String”,
@end
