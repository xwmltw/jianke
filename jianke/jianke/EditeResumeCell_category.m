//
//  EditeResumeCell_category.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditeResumeCell_category.h"
#import "WDConst.h"

@interface EditeResumeCell_category ()

@property (weak, nonatomic) IBOutlet UIButton *btnStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnSocail;
- (IBAction)btnStuedentOnClick:(UIButton *)sender;
- (IBAction)btnSocailOnClick:(UIButton *)sender;


@end

@implementation EditeResumeCell_category

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnStudent setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnStudent setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    [self.btnSocail setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnSocail setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    self.btnStudent.selected = YES;
}

- (void)setJkModel:(JKModel *)jkModel{
    _jkModel = jkModel;
    self.btnStudent.selected = (jkModel.user_type.integerValue == 1);
    self.btnSocail.selected = !self.btnStudent.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnStuedentOnClick:(UIButton *)sender {
    self.jkModel.user_type = @1;
    sender.selected = YES;
    self.btnSocail.selected = NO;
}

- (IBAction)btnSocailOnClick:(UIButton *)sender {
    self.jkModel.user_type = @0;
    sender.selected = YES;
    self.btnStudent.selected = NO;
}
@end
