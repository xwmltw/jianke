//
//  JobDetailCell_QA.h
//  jianke
//
//  Created by xiaomk on 16/3/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_QA : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labJKName;
@property (weak, nonatomic) IBOutlet UILabel *labQuestion;
@property (weak, nonatomic) IBOutlet UILabel *labQuestionTime;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;

@property (weak, nonatomic) IBOutlet UIView *viewAnswer;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer;
@property (weak, nonatomic) IBOutlet UILabel *labEpRevert;
@property (weak, nonatomic) IBOutlet UILabel *labAnswer;
@property (weak, nonatomic) IBOutlet UILabel *labAnswerTime;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
