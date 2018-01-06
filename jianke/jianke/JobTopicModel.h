//
//  JobTopicModel.h
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  岗位专题模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JobTopicModel : NSObject

@property (nonatomic, strong) NSNumber *topic_id; /*!< 专题id */
@property (nonatomic, copy) NSString *topic_name; /*!< 专题名称 */
@property (nonatomic, copy) NSString *topic_desc; /*!< 专题简介 */
@property (nonatomic, copy) NSString *icon_url; /*!< 图标地址 */

@end




/** 请求Service	shijianke_getJobTopicList
 请求content	“content”: {
	“md5_hash”: xxxx, //岗位信息的MD5值，处理方式与其他全局数据一致
 }
 应答content	“content”:{
 “md5_hash”: xxxx, //岗位信息的MD5值，处理方式与其他全局数据一致
 “job_topic_list”:[
 {
 “topic_id”: xxx, // 专题的id
 “topic_name”: xxx, // 专题名称
 “topic_desc” : xxxx //专题简介
 
 “icon_url”: xxx, // 图标地址
 
 }
 ]
 }
 */