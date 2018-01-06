//
//  JKApplyJobCellMiddleView.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "JKApplyJobCellMiddleView.h"

#define BLACKCOLOR [UIColor XSJColor_tGrayDeep]

@interface JKApplyJobCellMiddleView()
@property (nonatomic, weak) UIButton *stateBtn1; /*!< 第1个状态 */
@property (nonatomic, weak) UIButton *stateBtn2; /*!< 第2个状态 */
@property (nonatomic, weak) UIButton *stateBtn3; /*!< 第3个状态 */
@property (nonatomic, weak) UIButton *stateBtn4; /*!< 第4个状态 */

@end

@implementation JKApplyJobCellMiddleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = COLOR_RGB(249, 249, 249);
        
        // 第1个状态
        UIButton *stateBtn1 = [[UIButton alloc] init];
        [self addSubview:stateBtn1];
        self.stateBtn1 = stateBtn1;
        stateBtn1.userInteractionEnabled = NO;
        [self.stateBtn1 setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [self.stateBtn1 setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateDisabled];
        self.stateBtn1.titleLabel.font = JKApplyJobFont;
        
        // 第2个状态
        UIButton *stateBtn2 = [[UIButton alloc] init];
        [self addSubview:stateBtn2];
        self.stateBtn2 = stateBtn2;
        stateBtn2.userInteractionEnabled = NO;
        [self.stateBtn2 setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [self.stateBtn2 setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateDisabled];
        self.stateBtn2.titleLabel.font = JKApplyJobFont;
        
        // 第3个状态
        UIButton *stateBtn3 = [[UIButton alloc] init];
        [self addSubview:stateBtn3];
        self.stateBtn3 = stateBtn3;
        stateBtn3.userInteractionEnabled = NO;
        [self.stateBtn3 setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [self.stateBtn3 setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateDisabled];
        self.stateBtn3.titleLabel.font = JKApplyJobFont;
        
        // 第4个状态
        UIButton *stateBtn4 = [[UIButton alloc] init];
        [self addSubview:stateBtn4];
        self.stateBtn4 = stateBtn4;
        stateBtn4.userInteractionEnabled = NO;
        [self.stateBtn4 setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [self.stateBtn4 setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateDisabled];
        self.stateBtn4.titleLabel.font = JKApplyJobFont;
        
        // 设置按钮内容左对齐
        self.stateBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.stateBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.stateBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.stateBtn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        // 设置按钮图片与文字间距
        self.stateBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        self.stateBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        self.stateBtn3.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        self.stateBtn4.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    }
    
    return self;
}


- (void)setApplyJobF:(JKApplyJobFrame *)applyJobF{
    _applyJobF = applyJobF;
    JKApplyJob *applyJob = _applyJobF.applyJob;
    
    self.stateBtn2.enabled = YES;
    self.stateBtn3.enabled = YES;
    self.stateBtn4.enabled = YES;
    
    if (applyJob.job_type.integerValue == 2) { // 抢单
        
        switch (applyJob.trade_loop_status.integerValue) {
            case 2: // 抢单成功
            {
                [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                [self.stateBtn2 setTitle:@"完工" forState:UIControlStateNormal];
                self.stateBtn2.enabled = NO;
            }
                break;
                
            case 3: // 完工
            {
                [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                [self.stateBtn2 setTitle:@"完工" forState:UIControlStateNormal];
            }
                break;
                
            case 4: // 未到岗
            {
                if (applyJob.stu_absent_type.integerValue == 1) { // 沟通一致
                    [self.stateBtn2 setTitle:@"经沟通同意" forState:UIControlStateNormal];
                } else { // 放鸽子
                    [self.stateBtn2 setTitle:@"放鸽子" forState:UIControlStateNormal];
                }
                [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];

            }
                break;
                
            case 6: // 岗位下架
            {
                [self.stateBtn2 setTitle:@"岗位下架" forState:UIControlStateNormal];
                [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
            }
                break;
        }
        
        [self.stateBtn1 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
        [self.stateBtn1 setTitle:@"抢单成功" forState:UIControlStateNormal];
        
        self.stateBtn1.hidden = NO;
        self.stateBtn2.hidden = NO;
        self.stateBtn3.hidden = YES;
        self.stateBtn4.hidden = YES;
        
        
    } else { // 普通
        
        [self.stateBtn1 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
        [self.stateBtn1 setTitle:@"已报名" forState:UIControlStateNormal];
        self.stateBtn1.hidden = NO;
        
        switch (applyJob.trade_loop_status.integerValue) {
                
            case 1: // 等待雇主确认
            {
                if (applyJob.ent_read_resume_time) { // 简历被查看
                    
                    [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                    [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                    self.stateBtn2.hidden = NO;
                    
                    [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                    [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                    self.stateBtn3.hidden = NO;
                    self.stateBtn3.enabled = NO;
                    
                    [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                    [self.stateBtn4 setTitle:@"已完成" forState:UIControlStateNormal];
                    self.stateBtn4.hidden = NO;
                    self.stateBtn4.enabled = NO;
                    
                } else { // 已报名,简历还未被查看
                    
                    [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                    [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                    self.stateBtn2.hidden = NO;
                    self.stateBtn2.enabled = NO;
                    
                    [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                    [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                    self.stateBtn3.hidden = NO;
                    self.stateBtn3.enabled = NO;
                    
                    [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                    [self.stateBtn4 setTitle:@"已完成" forState:UIControlStateNormal];
                    self.stateBtn4.hidden = NO;
                    self.stateBtn4.enabled = NO;
                }
                
            }
                break;
                
            case 2: // 已录用
            {
                [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                self.stateBtn2.hidden = NO;
                
                [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                self.stateBtn3.hidden = NO;
                
                [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_waiting"] forState:UIControlStateNormal];
                [self.stateBtn4 setTitle:@"已完成" forState:UIControlStateNormal];
                self.stateBtn4.hidden = NO;
                self.stateBtn4.enabled = NO;
            }
                break;
                
            case 3: // 投递结束
            {
                switch (applyJob.trade_loop_finish_type.integerValue) {
                    case 1: // 兼客取消投递
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"已取消报名" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        self.stateBtn3.hidden = YES;
                        self.stateBtn4.hidden = YES;
                    }
                        break;
                        
                    case 2: // 雇主拒绝
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
                        [self.stateBtn3 setTitle:@"录用失败" forState:UIControlStateNormal];
                        self.stateBtn3.hidden = NO;
                        
                        self.stateBtn4.hidden = YES;
                    }
                        break;
                        
                    case 3: // 雇主确认完成
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                        self.stateBtn3.hidden = NO;
                        
                        [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn4 setTitle:@"已完成" forState:UIControlStateNormal];
                        self.stateBtn4.hidden = NO;
                    }
                        break;
                        
                    case 4: // 兼客未到岗
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                        self.stateBtn3.hidden = NO;
                        
                        if (applyJob.stu_absent_type.integerValue == 1) { // 沟通一致
                            
                            [self.stateBtn4 setTitle:@"经沟通同意" forState:UIControlStateNormal];
                        } else { // 放鸽子
                            [self.stateBtn4 setTitle:@"放鸽子" forState:UIControlStateNormal];
                        }
                        [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
                        self.stateBtn4.hidden = NO;
                    }
                        break;
                        
                    case 5: // 雇主24小时未处理
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"录用失败" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        self.stateBtn3.hidden = YES;
                        self.stateBtn4.hidden = YES;
                    }
                        break;
                        
                    case 6: // 岗位关闭
                    {
                        [self.stateBtn2 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn2 setTitle:@"简历被查看" forState:UIControlStateNormal];
                        self.stateBtn2.hidden = NO;
                        
                        [self.stateBtn3 setImage:[UIImage imageNamed:@"v3_wait_done"] forState:UIControlStateNormal];
                        [self.stateBtn3 setTitle:@"录用成功" forState:UIControlStateNormal];
                        self.stateBtn3.hidden = NO;
                        
                        [self.stateBtn4 setImage:[UIImage imageNamed:@"v3_wait_unpassed"] forState:UIControlStateNormal];
                        [self.stateBtn4 setTitle:@"岗位下架" forState:UIControlStateNormal];
                        self.stateBtn4.hidden = NO;
                    }
                        break;
                }
            }
                break;
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.stateBtn1.x = JKApplyJobCellPendding;
    self.stateBtn2.x = self.stateBtn1.x;
    self.stateBtn3.x = self.stateBtn1.x;
    self.stateBtn4.x = self.stateBtn1.x;
    
    self.stateBtn1.width = JKApplyJobCellStateW;
    self.stateBtn2.width = self.stateBtn1.width;
    self.stateBtn3.width = self.stateBtn1.width;
    self.stateBtn4.width = self.stateBtn1.width;
    
    self.stateBtn1.height = JKApplyJobCellStateH;
    self.stateBtn2.height = self.stateBtn1.height;
    self.stateBtn3.height = self.stateBtn1.height;
    self.stateBtn4.height = self.stateBtn1.height;
    
    self.stateBtn1.y = 2;
    self.stateBtn2.y = JKApplyJobCellStateH + 2;
    self.stateBtn3.y = JKApplyJobCellStateH * 2+2;
    self.stateBtn4.y = JKApplyJobCellStateH * 3+2;
}


@end
