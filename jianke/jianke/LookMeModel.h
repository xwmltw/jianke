//
//  LookMeModel.h
//  jianke
//
//  Created by yanqb on 2017/7/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookMeModel : NSObject

@property (nonatomic, copy) NSNumber *ent_id;       /*!< 雇主id*/
@property (nonatomic, copy) NSString *true_name;    /*!< 姓名*/
@property (nonatomic, copy) NSString *ent_name;     /*!< 企业名称*/
@property (nonatomic, copy) NSString *industry_name; /*!< 行业名称*/
@property (nonatomic, copy) NSNumber *view_time;    /*!< 查看时间*/
@property (nonatomic, copy) NSString *profile_url;  /*!< 头像*/
@end
