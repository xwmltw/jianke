//
//  NewSocialActivistCell.m
//  jianke
//
//  Created by fire on 16/8/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NewSocialActivistCell.h"
#import "SociaAcitvistModel.h"
#import "SalaryModel.h"

@interface NewSocialActivistCell ()
@property (weak, nonatomic) IBOutlet UILabel *pageViewLabel;    //浏览量
@property (weak, nonatomic) IBOutlet UILabel *appleyNumLabel;   //报名人数
@property (weak, nonatomic) IBOutlet UILabel *hireNumLabel;     //录用人数
@property (weak, nonatomic) IBOutlet UILabel *finishWorkNumLabel;   //完工数
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;          //赏金
@property (weak, nonatomic) IBOutlet UILabel *rewardUintLabel;      //赏金单位
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;        //工作标题
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;          //工作工资

@end

@implementation NewSocialActivistCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(SociaAcitvistModel *)model{
    self.pageViewLabel.text = [NSString stringWithFormat:@"%@人查看",model.view_num.stringValue];
    self.appleyNumLabel.text = [NSString stringWithFormat:@"%@人报名",model.apply_num.stringValue];
    self.hireNumLabel.text = [NSString stringWithFormat:@"%@人录用",model.hire_num.stringValue];
    self.finishWorkNumLabel.text = [NSString stringWithFormat:@"%@人完工",model.finish_work_num.stringValue];
    self.rewardLabel.text = [NSString stringWithFormat:@"%.2f",model.receive_reward.floatValue * 0.01];
    if (model.social_activist_reward_unit.integerValue == 1) {
        self.rewardUintLabel.text = [NSString stringWithFormat:@"%.2f/元/人",model.social_activist_reward.floatValue * 0.01];
    }else{
        self.rewardUintLabel.text = [NSString stringWithFormat:@"%.2f/元/人/天",model.social_activist_reward.floatValue * 0.01];
    }
    self.jobTitleLabel.text = model.job_title;
    self.salaryLabel.text = [NSString stringWithFormat:@"%.2f元%@",model.salary.value.floatValue,model.salary.getTypeDesc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
