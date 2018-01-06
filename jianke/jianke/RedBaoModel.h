//
//  RedBaoModel.h
//  jianke
//
//  Created by yanqb on 2017/7/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedBaoModel : NSObject
@property (nonatomic, copy) NSNumber *red_packets_dist_id;          /*!< 红包发放id */
@property (nonatomic, copy) NSNumber *red_packets_amount;           /*!< 红包金额*/
@property (nonatomic, copy) NSString *red_packets_share_url;        /*!< 分享url*/
@property (nonatomic, copy) NSString *red_packets_activity_title;   /*!< 活动标题*/
@property (nonatomic, copy) NSString *red_packets_activity_desc;    /*!< 活动详情*/
@property (nonatomic, copy) NSString *red_packets_share_img_url;
@property (nonatomic, copy) NSString *job_title; /*!< 工作名称*/
@end

//“content”:{
//    “red_packets_dist _id”: xxx// 红包发放id
//    “red_packets_amount”:// 红包金额
//    “red_packets_share_url”:// 分享url
//    “red_packets_activity_title”:// 活动标题
//    “red_packets_activity_desc”:// 活动详情
//}
