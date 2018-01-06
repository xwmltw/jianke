//
//  GrabJobClassModel.h
//  jianke
//
//  Created by fire on 15/9/23.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  抢单岗位类型模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface GrabJobClassModel : NSObject

@property (nonatomic, strong) NSNumber *grab_single_job_classfier_id; /*!< 岗位分类id */
@property (nonatomic, strong) NSString *grab_single_job_classfier_name; /*!< 岗位分类名称 */
@property (nonatomic, strong) NSArray *labels; /*!< 抢单岗位标签 */
@property (nonatomic, strong) NSNumber *normal_job_classify_id; /*!< <long>抢单岗位分类指向到普通岗位分类的id */
@property (nonatomic, strong) NSNumber *salary_lower_limit; /*!< 当前城市当前岗位分类的最低工资限制 */


@end


/**
 请求Service	shijianke_getGrabSingleJobClassifierList
 请求content	“content”:{
 “data_version”: “xxxxx”, // 接口版本号，如果没有可以不传这个字段
 “city_id”:<long> // 城市id，必填
 }
 应答content	“content”:{
	“list”:[   // 如果岗位分类的hash未改变，则传递空的数组
 {
 “grab_single_job_classfier_id”: xxx, // 岗位分类id
 “grab_single_job_classfier_name”: “xxx”, // 岗位分类名称
 “labels”:[
 “xxx”, // 抢单岗位标签
 ],
 “normal_job_classify_id”: <long>抢单岗位分类指向到普通岗位分类的id,
 “salary_lower_limit”: <int> // 当前城市当前岗位分类的最低工资限制
 }
 ],
 “data_version”: <int>, // 数据版本号，如果本次上传版本号和服务端一致，则不下发数据
 }
 */

