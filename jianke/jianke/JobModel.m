//
//  JobModel.m
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobModel.h"
#import "MJExtension.h"

@implementation JobModel
MJCodingImplementation

/** 判断是否已读,并设置相应字段readed */
- (void)checkReadStateWithReadedJobIdArray:(NSArray *)jobIdArray{
    for (NSString *jobId in jobIdArray) {
        if ([jobId isEqualToString:self.job_id.stringValue]) {
            self.readed = YES;
        }
    }
}

- (NSDictionary *)objectClassInArray{
    return @{@"job_tags" : [WelfareModel class]};
}

@end

@implementation ExpectOnBoardStuCountModel
MJCodingImplementation
@end
