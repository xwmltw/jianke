//
//  ImUserInfo.h
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImUserPublicInfo.h"

@interface ImUserInfo : NSObject

@property (nonatomic, copy) NSString* accountId;            //“和兼客的accountId一致,String”
@property (nonatomic, copy) NSNumber* account_type;         //账户类型,<整形数字> , 1雇主,2学生 3功能号 4兼客雇主
@property (nonatomic, copy) NSString* headUrl;              //“头像地址，String”,
@property (nonatomic, copy) NSString* telephone;            //“电话号码，String”,
@property (nonatomic, copy) NSString* uuid;                 //“好友的UUID，用来通过融云发送单聊消息给对方，String”,
@property (nonatomic, copy) NSString* accountName;          //用户名
//@property (nonatomic, copy) NSString* remarkName;           // “备注名称，String”,
@property (nonatomic, copy) NSNumber* remind;               //“消息提醒方式，int, 1:提醒 2:不提醒”,
@property (nonatomic, copy) NSNumber* addTime;              //“好友新增时间,long格式时间”
@property (nonatomic, copy) NSNumber* accountEntInfoId;     //企业id
@property (nonatomic, copy) NSNumber* resumeId;             //简历ID，add by chenw @ 2015.4.2
@property (nonatomic, copy) NSNumber* version;              //“冗余信息版本,int”
@property (nonatomic, copy) NSNumber* priVersion;           //“私人定制信息版本,int”

@property (nonatomic, copy) NSString* kefuImg;              //客服头像图片
//自己添加的

//融云用户信息获取回调专用
@property (nonatomic, strong) ImUserPublicInfo* userPublicInfo; //服务端获取下来的用户信息
@property (nonatomic, copy) NSString* nickname; // “备注名称，String”,

- (void)updateVersion;
- (NSString*)getShowName;        //要显示出来的名字
- (NSString*)getHead;


@end



@class ImAccountInfo;

@interface OpenImFunModel : NSObject
@property (nonatomic, copy) NSNumber* open_status;          //开通状态,<整形数字> 1 开通成功,
@property (nonatomic, copy) NSNumber* is_already_opened;    //是否已经开通过了,<整形数字> , 1是,0否.
@property (nonatomic, copy) NSString* is_support_rongyun_custom_service;    // 是否支持融云客服，1：支持，0：不支持
@property (nonatomic, strong) ImAccountInfo* im_account_info;
@end

@interface ImAccountInfo : NSObject
@property (nonatomic, copy) NSNumber* account_id;
@property (nonatomic, copy) NSNumber* account_type;
@property (nonatomic, copy) NSString* account_name;
@property (nonatomic, copy) NSString* account_img_url;
@property (nonatomic, copy) NSString* im_token;
@property (nonatomic, copy) NSNumber* account_sex;
@property (nonatomic, copy) NSString* uuid;
@property (nonatomic, copy) NSString* account_phone_num;
@property (nonatomic, copy) NSNumber* account_resume_id;
@property (nonatomic, copy) NSNumber* account_ent_info_id;
@property (nonatomic, copy) NSArray* disable_notify_account_ids;
@end

//“content”: {
//    “open_status” : 开通状态,<整形数字> 1 开通成功,
//    “is_already_opened” :是否已经开通过了,<整形数字> , 1是,0否.
//    “is_support_rongyun_custom_service” : int, // 是否支持融云客服，1：支持，0：不支持add by chenw @ 2015.4.2
//    
//    “im_account_info” : {  IM账号信息:
//        “account_id” : 账户ID , <整形数字>,
//        “account_name” : “账户名称”, // add by chenw @ 2015.4.2
//        “account_type”: 账户类型,<整形数字> , 1雇主,2学生
//        “account_sex” : int, // 1：男 0：女 add by chenw @ 2015.4.2
//        “account_type” : int, // 1:雇主 2：学生add by chenw @ 2015.4.2
//        “account_resume_id” : int, // 学生简历ID add by chenw @ 2015.4.2
//        “account_ent_info_id” : int, // 企业信息ID add by chenw @ 2015.4.2
//        “account_img_url” : 头像地址,<字符串>,
//        “account_phone_num”: 账户电话号码,<字符串>,
//        “im_token” : IM的Token值,<字符串>, 当开通状态为1,且是未开通过的情况下,该属性有值.
//        “uuid” : “即在融云的userId”, // add by chenw @ 2015.4.3
//        “disable_notify_account_ids”: [
//                                       Xxx, <long>当前账号禁用通知的账号id
//                                       ]
//    }
//}

@interface EmployerInfo : ImUserInfo
@property (nonatomic, strong) NSNumber* entInfoId;  //企业信息ID add by chenw @ 2015.4.2
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSString* entName;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* objectId;
@end

//@interface SearchEmployer : NSObject
//@property (nonatomic, strong) NSString* accountId;  //“和兼客的accountId一致,String”
//@property (nonatomic, strong) NSString* entName;    //“雇主名称，String”
//@property (nonatomic, strong) NSString* desc;       //“雇主简介，String”
//@property (nonatomic, strong) NSString* headUrl;    //“头像地址，String”,
//@property (nonatomic, strong) NSNumber* entInfoId;  //企业信息ID add by chenw @ 2015.4.7
//@end

// ========必须关注的功能号
@interface GlobalFeatureInfo : ImUserInfo
//@property (nonatomic, strong) NSString* accountId;  //“和兼客的accountId一致,String”
//@property (nonatomic, strong) NSString* uuid;       //“好友的UUID，用来通过融云发送单聊消息给对方，String”,
//@property (nonatomic, strong) NSString* telephone;  //“电话号码，String
//@property (nonatomic, strong) NSString* remarkName; // 此处存放雇主名称，String”,
//@property (nonatomic, strong) NSString* headUrl;    //“头像地址，String”,
@property (nonatomic, copy) NSString* objectId;
@property (nonatomic, copy) NSString* desc;       //描述字符串
@property (nonatomic, copy) NSString* funName;
@property (nonatomic, strong) NSNumber* isKeFuMM;   //自定义字段，是否是客服
@property (nonatomic, strong) NSNumber* entInfoId;  //企业信息ID add by chenw @ 2015.4.2    自身关注的功能号
//@property (nonatomic, copy) NSString* menuJson;   //CRM 功能号  json 数据
@property (nonatomic, strong) NSArray* menuJson;   //CRM 功能号  json 数据

- (NSString *)getShowName;
@end


@interface MenuJsonModel : NSObject
@property (nonatomic, copy) NSString* menu_name;   //CRM 功能号  按钮名字
@property (nonatomic, copy) NSString* url;      //CRM 功能号  跳转URL

@end

//=========自身关注的功能号
//@interface FeatureInfo : ImUserInfo
////@property (nonatomic, strong) NSString* accountId;  //“和兼客的accountId一致,String”
////@property (nonatomic, strong) NSString* uuid;       //“好友的UUID，用来通过融云发送单聊消息给对方，String”,
////@property (nonatomic, strong) NSString* telephone;  //“电话号码，String
////@property (nonatomic, strong) NSString* remarkName; // 此处存放雇主名称，String”,
////@property (nonatomic, strong) NSString* headUrl;    //“头像地址，String”,
////@property (nonatomic, strong) NSNumber* remind;     //“消息提醒方式，int, 1:提醒 2:不提醒”
////@property (nonatomic, strong) NSNumber* addTime;    //“好友新增时间,long格式时间”,
////@property (nonatomic, strong) NSNumber* version;    //冗余信息版本,int
////@property (nonatomic, strong) NSNumber* priVersion; //私人定制信息版本,int
//@property (nonatomic, strong) NSString* desc;       //文档未明确？mark to do
//@property (nonatomic, strong) NSNumber* entInfoId;  //企业信息ID add by chenw @ 2015.4.2
//@end
