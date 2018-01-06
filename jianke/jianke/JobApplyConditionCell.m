//
//  JobApplyConditionCell.m
//  jianke
//
//  Created by fire on 15/11/21.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobApplyConditionCell.h"
#import "WDConst.h"

@interface JobApplyConditionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UILabel *labText;
@end

@implementation JobApplyConditionCell


- (void)setModel:(JobApplyConditionCellModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.stateImgView.hidden = YES;
    self.labText.hidden = YES;
    switch (model.state) {
        case ConditionStateFit:{
            self.stateImgView.hidden = NO;
        }
            break;
        case ConditionStateUnFit:{
            self.labText.hidden = NO;
            self.labText.text = @"不符合";
            self.labText.textColor = [UIColor XSJColor_tRed];
        }
            break;
        case ConditionStateUnknow:{
            self.labText.hidden = NO;
            self.labText.text = @"待完善";
            self.labText.textColor = [UIColor XSJColor_tGray];
        }
            break;
    }
    
}


@end
