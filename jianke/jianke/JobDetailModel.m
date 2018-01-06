//
//  JobDetailModel.m
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  岗位详情模型

#import "JobDetailModel.h"
#import "JobQAInfoModel.h"

@implementation JobDetailModel
MJCodingImplementation

- (NSDictionary *)objectClassInArray
{
    return @{@"apply_job_resumes" : [ApplyJobResumeModel class],
             @"job_question_answer" : [JobQAInfoModel class],
             @"contact_apply_job_resumes" : [ApplyJobResumeModel class]};
}


@end
