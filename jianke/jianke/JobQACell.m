//
//  JobQACell.m
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobQACell.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "UIHelper.h"

@interface JobQACell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView; /*!< 兼客头像 */
@property (weak, nonatomic) IBOutlet UILabel *jkNameLabel; /*!< 兼客姓名 */
@property (weak, nonatomic) IBOutlet UILabel *jkQuestionLabel; /*!< 兼客问题 */
@property (weak, nonatomic) IBOutlet UILabel *jkQutstionTimeLabel; /*!< 兼客提问时间 */


@property (weak, nonatomic) IBOutlet UIView *epAnswerView; /*!< 雇主回答View */
@property (weak, nonatomic) IBOutlet UILabel *epAnswerLabel; /*!< 雇主回答内容 */
@property (weak, nonatomic) IBOutlet UILabel *epAnswerTimeLabel; /*!< 雇主回答时间 */

@end

@implementation JobQACell

- (void)setJobQACellModel:(JobQACellModel *)jobQACellModel
{
    _jobQACellModel = jobQACellModel;
    JobQAInfoModel *model = jobQACellModel.jobQAModel;
    
    // 头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.question_user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
    
    // 姓名
    if (model.question_user_true_name && model.question_user_true_name.length) {
        self.jkNameLabel.text = model.question_user_true_name;
    } else {
        self.jkNameLabel.text = @"兼客用户";
    }
    
    // 问题
    self.jkQuestionLabel.text = model.question;
    
    // 提问时间
    self.jkQutstionTimeLabel.text = [DateHelper getTimeRangeWithSecond:model.question_time];
    
    // 回复
    if (model.answer.length > 0) {
        self.epAnswerView.hidden = NO;
        self.epAnswerLabel.text = model.answer;
        self.epAnswerTimeLabel.text = [DateHelper getTimeRangeWithSecond:model.answer_time];
        
    } else {
        self.epAnswerView.hidden = YES;
    }
}

/** 雇主回复兼客提问按钮点击 */
- (IBAction)answerBtnClick:(UIButton *)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[EPAnswerJKQuestionInfo] = self.jobQACellModel;
    
    [WDNotificationCenter postNotificationName:EPAnswerJKQuestionNotification object:self userInfo:dic];    
}



- (IBAction)fuckBtnClick:(UIButton *)sender
{
    [UIHelper toast:@"举报成功"];
}

@end
