//
//  JobClassifierModel.h
//  jianke
//
//  Created by fire on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JobClassifierModel : NSObject

@property (nonatomic, copy) NSNumber* job_classfier_id;
@property (nonatomic, copy) NSString* job_classfier_img_url;
@property (nonatomic, copy) NSString* job_classfier_name;
@property (nonatomic, copy) NSNumber* job_classfier_status;        //状态，0隐藏，1显示
@property (nonatomic, copy) NSString *job_classfier_spelling;

@end



/** 
 请求Service	shijianke_getJobClassifierList
 请求content	“content”:{
 “md5_hash”: “xxxxx”, // 岗位分类的MD5，传递上次服务端下发的内容即可，如果是首次请求，则传空字符串
 }
 
 应答content	“content”:{
	“job_classifier_list”:[   // 如果岗位分类的hash未改变，则传递空的数组
 {
 “job_classfier_id”: xxx, // 岗位分类id
 “job_classfier_name”: “xxx”, // 岗位分类名称
 “job_classfier_img_url”:”xxxxx”, // 岗位分类图片url
 “job_classfier_status”: 状态，0隐藏，1显示}
 ],
 “md5_hash”: “xxxxx”, // 技能列表的MD5摘要，16个字节的byte转换为32字节的十六进制字符串进行传输
 }
 */