//
//  JobQACell.h
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobQACellModel.h"

/** 雇主回复兼客提问通知 */
static NSString * const EPAnswerJKQuestionNotification = @"EPAnswerJKQuestionNotification";
static NSString * const EPAnswerJKQuestionInfo = @"EPAnswerJKQuestionInfo";

@interface JobQACell : UITableViewCell

@property (nonatomic, strong) JobQACellModel *jobQACellModel;
@property (weak, nonatomic) IBOutlet UIButton *epAnswerBtn; /*!< 雇主回复按钮 */

@end
