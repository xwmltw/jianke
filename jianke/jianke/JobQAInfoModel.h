//
//  JobQAInfoModel.h
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  雇主答疑模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface JobQAInfoModel : NSObject

@property (nonatomic, copy) NSNumber *qa_id;            /*!< 提问和答复的id */
@property (nonatomic, copy) NSString *question;         /*!< 提问 */
@property (nonatomic, copy) NSNumber *question_time;    /*!< <long> 1970年1月1日至今的秒数 */
@property (nonatomic, copy) NSString *question_user_profile_url; /*!< <string>提问者的头像地址 */
@property (nonatomic, copy) NSString *question_user_true_name; /*!< <string>提问者姓名 */
@property (nonatomic, copy) NSString *answer;           /*!< <string> 答复 */
@property (nonatomic, copy) NSNumber *answer_time;      /*!< <long>1970年1月1日至今的秒数 */
@property (nonatomic, assign) CGFloat cellHeight;

@end


/**
 shijianke_queryJobQA
 “content”:{
	“job_id”: <long> 岗位id
 }
 }
 “content”:{
 “list”:[
 “qa_id”: <long> 提问和答复的id
 “question”: <string> 提问
 “question_time”: <long> 1970年1月1日至今的秒数
 “question_user_profile_url”: <string>提问者的头像地址
 “question_user_true_name”: <string>提问者姓名
 “answer”: <string> 答复
 “answer_time”: <long>1970年1月1日至今的秒数
 ]
 }
*/