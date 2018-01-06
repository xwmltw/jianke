//
//  JKApplyJobFrame.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "JKApplyJobFrame.h"
#import "WDConst.h"



@implementation JKApplyJobFrame


- (void)setApplyJob:(JKApplyJob *)applyJob{
    _applyJob = applyJob;
    
    // 整体View
    CGFloat contentImageViewX = JKApplyJobCellContentMargin;
    CGFloat contentImageViewY = JKApplyJobCellContentMarginTop;
    CGFloat contentImageViewW = JKApplyJobCellContentImageViewW;

    // 头部View
    CGFloat headViewX = 0;
    CGFloat headViewY = 0;
    CGFloat headViewW = contentImageViewW;
    CGFloat headViewH = 60;
    self.headViewF = CGRectMake(headViewX, headViewY, headViewW, headViewH);
    
    // 中间我的工作动态View
    CGFloat middleViewX = 0;
    CGFloat middleViewY = headViewH;
    CGFloat middleViewW = contentImageViewW;
    CGFloat middleViewH = [self getMiddleViewHeight] + JKApplyJobCellMargin;
    self.middleViewF = CGRectMake(middleViewX, middleViewY, middleViewW, middleViewH);
   
    
    // 底部View
    CGFloat footViewX = 0;
    CGFloat footViewY = CGRectGetMaxY(self.middleViewF);
    CGFloat footViewW = contentImageViewW;
    CGFloat footViewH = 52;
    self.footViewF = CGRectMake(footViewX, footViewY, footViewW, footViewH);
    
    // 整体View
    CGFloat contentImageViewH = CGRectGetMaxY(self.footViewF);
    self.contentImageViewF = CGRectMake(contentImageViewX, contentImageViewY, contentImageViewW, contentImageViewH);
    
    // cell高度
    self.cellHeight = contentImageViewH + 2 * JKApplyJobCellContentMarginTop;
}


- (CGFloat)getMiddleViewHeight{
    CGFloat middleViewHeight = 0;
    if (self.applyJob.job_type.integerValue == 2) { // 抢单
        middleViewHeight = 2 * JKApplyJobCellStateH;
    } else { // 普通招聘
        if (self.applyJob.trade_loop_status.integerValue == 3) { // 投递结束
            if (self.applyJob.trade_loop_finish_type.integerValue == 1 || self.applyJob.trade_loop_finish_type.integerValue == 5) { // 兼客取消投递 || 雇主24小时未处理
                middleViewHeight = 2 * JKApplyJobCellStateH;
            } else if (self.applyJob.trade_loop_finish_type.integerValue == 2) { // 雇主拒绝
                middleViewHeight = 3 * JKApplyJobCellStateH;
            } else { // 其他情况
                 middleViewHeight = 4 * JKApplyJobCellStateH;
            }
        } else {
            middleViewHeight = 4 * JKApplyJobCellStateH;
        }
    }
    return middleViewHeight;
}


/**
 *  通过ApplyJob数组创建ApplyJobFrame数组
 *
 *  @param array applyJob模型数组
 *
 *  @return ApplyJobFrame模型数组
 */
+ (NSMutableArray *)applyJobFListWithApplyJobArray:(NSArray *)array withSection:(NSUInteger)section{
    NSMutableArray *arrayM = [NSMutableArray array];
    __block NSUInteger i = section;
    [array enumerateObjectsUsingBlock:^(JKApplyJob *obj, NSUInteger idx, BOOL *stop) {
        
        JKApplyJobFrame *applyJobF = [[JKApplyJobFrame alloc] init];
        applyJobF.applyJob = obj;
        applyJobF.index = i;
        [arrayM addObject:applyJobF];
        i++;
    }];
    
    return arrayM;
}


@end
