//
//  WorkExpList_Cell.m
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "WorkExpList_Cell.h"
#import "ResponseInfo.h"
#import "WDConst.h"

@interface WorkExpList_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;


@end

@implementation WorkExpList_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnEdit.tag = BtnOnClickActionType_editWorkExperience;
    [self.btnEdit addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnDel.tag = BtnOnClickActionType_deleteWorkExperience;
    [self.btnDel addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ResumeExperienceModel *)model{
    _model = model;
    NSString *strBegin = [DateHelper getDateFromTimeNumber:model.job_begin_time withFormat:@"yyyy/MM/dd"];
    NSString *strEnd = [DateHelper getDateFromTimeNumber:model.job_end_time withFormat:@"yyyy/MM/dd"];
    self.labDate.text = [NSString stringWithFormat:@"%@至%@, %@", strBegin, strEnd, model.job_classify_name];
    self.labTitle.text = model.job_title;
    self.labContent.text = model.job_content.length ? model.job_content: nil;
    if (self.labContent.text.length) {
        model.cellHeight = 72 + 69 + [self.labContent contentSizeWithWidth:SCREEN_WIDTH - 60].height;
    }else{
        model.cellHeight = 72 + 61;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(WorkExpList_Cell:actionType:model:)]) {
        [self.delegate WorkExpList_Cell:self actionType:sender.tag model:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
