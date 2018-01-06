//
//  FeedbackInfo.h
//  jianke
//
//  Created by 郑东喜 on 15/9/23.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject

@property (nonatomic, strong) NSNumber* city_id;            // 城市id
@property (nonatomic, strong) NSNumber* address_area_id;    // 地区
@property (nonatomic, strong) NSNumber* feedback_type;      // 类型  1:建议 2：投诉  3:岗位投诉
@property (nonatomic, strong) NSNumber* phone_num;          // 电话号码
@property (nonatomic, strong) NSString* desc;               // 描述
@property (nonatomic, strong) NSNumber* job_id;             // 岗位id，当feedback_type为岗位投诉类型时必填

@end

/**
 *
 “content”:{
 “city_id”:xxx, // 城市id
	“address_area_id”: xxx, // 地区
 “feedback_type”:  xxx, // 类型  1:建议 2：投诉  3:岗位投诉
 “phone_num”: xxx, // 电话号码
 “desc”: xxx, // 描述
 “job_id”: xx, // 岗位id，当feedback_type为岗位投诉类型时必填
 }
 **/