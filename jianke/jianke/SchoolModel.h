//
//  SchoolModel.h
//  jianke
//
//  Created by fire on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  学校模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface SchoolModel : NSObject

@property (nonatomic, copy) NSNumber *id; /*!< 学校id */
@property (nonatomic, copy) NSNumber *addressAreaId; /*!< 学校所属的区域id */
@property (nonatomic, copy) NSString *schoolName; /*!< 学校名称 */
@property (nonatomic, copy) NSNumber *cityId; /*!< 学校所在的城市id */
@property (nonatomic, copy) NSNumber *status; /*!< 学校的状态 */

@end


/**
 *  请求Service	shijianke_querySchoolList
 请求content	“content”:{
 “address_area_id”: “xxxxx”, // 学校所在区域id
 “city_id”: “xxxxxxx”//学校所在城市id
 “school_name”: xxxxx //学校名称(模糊匹配)
 }
 应答content	“content”:{
	“school_list”:[
 {
 “id”: xxx, // 学校id
 “addressAreaId”: xxx,   // 学校所属的区域id
 “schoolName”: “xxx”, // 学校名称
 “cityId”:  “xxx” //学校所在的城市id
 “status”: “xxxx” 学校的状态
 }
 ],
 }
 */