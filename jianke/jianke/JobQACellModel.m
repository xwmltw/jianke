//
//  JobQACellModel.m
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobQACellModel.h"

@implementation JobQACellModel



- (void)setJobQAModel:(JobQAInfoModel *)jobQAModel
{
    _jobQAModel = jobQAModel;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    CGSize questionMaxSize = CGSizeMake(SCREEN_WIDTH - 67, MAXFLOAT);
    CGFloat jkQuestionHeight = [jobQAModel.question boundingRectWithSize:questionMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 60;
    
    CGFloat epAnswerHeight = 0;
    if (jobQAModel.answer.length > 0) {
        
        CGSize answerMaxSize = CGSizeMake(SCREEN_WIDTH - 65, MAXFLOAT);
        epAnswerHeight = [jobQAModel.answer boundingRectWithSize:answerMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
        
        epAnswerHeight += 60;
    }
    
    self.cellHeight = jkQuestionHeight + epAnswerHeight;
}

+ (NSArray *)JobQACellArrayWithJobQAArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(JobQAInfoModel *model, NSUInteger idx, BOOL *stop) {
       
        JobQACellModel *cellModel = [[JobQACellModel alloc] init];
        cellModel.jobQAModel = model;
        [arrayM addObject:cellModel];
    }];
    
    return arrayM;
}

@end
