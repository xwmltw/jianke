//
//  PostWorkCell_date.m
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostWorkCell_date.h"
#import "WDConst.h"

@interface PostWorkCell_date ()

@property (weak, nonatomic) IBOutlet UIButton *btnBegin;
@property (weak, nonatomic) IBOutlet UIButton *btnEnd;


@end

@implementation PostWorkCell_date

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnBegin.tag = BtnOnClickActionType_dateBegin;
    [self.btnBegin addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnEnd.tag = BtnOnClickActionType_dateEnd;
    [self.btnEnd addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ResumeExperienceModel *)model{
    if (model.job_begin_time) {
        NSString *strBegin = [DateHelper getDateFromTimeNumber:model.job_begin_time withFormat:@"yyyy/MM/dd"];
        [self.btnBegin setTitle:strBegin forState:UIControlStateNormal];
    }else{
        [self.btnBegin setTitle:@"开始时间" forState:UIControlStateNormal];
    }
    if (model.job_end_time) {
        NSString *strEnd = [DateHelper getDateFromTimeNumber:model.job_end_time withFormat:@"yyyy/MM/dd"];
        [self.btnEnd setTitle:strEnd forState:UIControlStateNormal];
    }else{
        [self.btnEnd setTitle:@"结束时间" forState:UIControlStateNormal];
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(PostWorkCell_date:actionType:)]) {
        [self.delegate PostWorkCell_date:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
