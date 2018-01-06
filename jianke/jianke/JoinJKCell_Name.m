//
//  JoinJKCell_Name.m
//  jianke
//
//  Created by yanqb on 2016/12/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JoinJKCell_Name.h"
#import "JKModel.h"
#import "WDConst.h"

@interface JoinJKCell_Name ()

@property (nonatomic, strong) PostResumeInfoPM *jkModel;

@property (weak, nonatomic) IBOutlet UITextField *utfName;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;

- (IBAction)utfChanging:(UITextField *)sender;

@end

@implementation JoinJKCell_Name

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnFemale.tag = BtnOnClickActionType_sexFemale;
    [self.btnFemale setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnFemale setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    [self.btnFemale addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnMale.tag = BtnOnClickActionType_sexmale;
    [self.btnMale setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnMale setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    [self.btnMale addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(PostResumeInfoPM *)model{
    _jkModel = model;
    self.utfName.text = (model.true_name && model.true_name.length) ? model.true_name : nil ;
    self.utfName.userInteractionEnabled = !(model.id_card_verify_status.integerValue == 2 || model.id_card_verify_status.integerValue == 3);
    if (model.sex.integerValue == 0) {
        self.btnFemale.selected = YES;
        self.btnMale.selected = NO;
    }else{
        self.btnFemale.selected = NO;
        self.btnMale.selected = YES;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    switch (sender.tag) {
        case BtnOnClickActionType_sexmale:{
            self.jkModel.sex = @1;
            self.btnMale.selected = YES;
            self.btnFemale.selected = NO;
        }
            break;
        case BtnOnClickActionType_sexFemale:{
            self.jkModel.sex = @0;
            self.btnMale.selected = NO;
            self.btnFemale.selected = YES;
        }
            break;
        case BtnOnClickActionType_uploadHeadImg:{
            if ([self.delegate respondsToSelector:@selector(joinJKCell:actionType:)]) {
                [self.delegate joinJKCell:self actionType:sender.tag];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)utfChanging:(UITextField *)sender {
    self.jkModel.true_name = sender.text;
}

@end
