//
//  MoneyBagCell.m
//  jianke
//
//  Created by xiaomk on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MoneyBagCell.h"
#import "MoneyDetailModel.h"
#import "DateHelper.h"
#import "WDConst.h"

@interface MoneyBagCell(){
    
}

@property (weak, nonatomic) IBOutlet UIImageView *takeoutingView;
@property (weak, nonatomic) IBOutlet UIImageView *imgQiang;
@property (weak, nonatomic) IBOutlet UIImageView *imgZhai;

@property (weak, nonatomic) IBOutlet UIImageView *imgRedPoing;
@property (weak, nonatomic) IBOutlet UILabel *labelAllNum;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labData;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutRedPointLeftToTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layutoTitleRightToMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLeft;   //16  34 64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabMoneyWidth;
@end

@implementation MoneyBagCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MoneyBagCell";
    MoneyBagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"MoneyBagCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
//        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)refreshWithData:(MoneyDetailModel*)model{
    self.labData.font = [UIFont fontWithName:kFont_RSR size:16];
    self.labMoney.font = [UIFont fontWithName:kFont_RSR size:20];
    self.labTitle.hidden = NO;

    if (model) {
        self.labData.text = [DateHelper getDateTimeFromTimeNumber:model.update_time];
        self.labMoney.text = [UserData getMoneyFormatWithNum:model.actual_amount];
        
        //        labMoney.font = [UIFont fontWithName:@"RobotoSlab" size:CGFLOAT_MIN];
        self.labTitle.text = model.money_detail_title;

        self.takeoutingView.hidden = YES;
        self.imgQiang.hidden = YES;
        self.imgZhai.hidden = YES;
        self.imgRedPoing.hidden = YES;
        self.labelAllNum.hidden = YES;
        
        if (model.money_detail_type.intValue == 14 || model.money_detail_type.intValue == 15 || model.money_detail_type.intValue == 16) {//提现到支付宝
            
            if (model.money_detail_type.intValue == 14) {
                self.takeoutingView.hidden = NO;
                self.layoutTitleLeft.constant = 64;
                self.labTitle.textColor = MKCOLOR_RGB(169, 169, 169);
            }else{
                self.takeoutingView.hidden = YES;
                self.layoutTitleLeft.constant = 16;
            }
        }else{
            if (model.task_id && model.task_id.integerValue > 0) {    //宅任务
                self.imgZhai.hidden = YES;
                self.layoutTitleLeft.constant = 16;
            }else{
                if (model.job_type.intValue == 1) { //抢单
                    self.imgQiang.hidden = NO;
                    self.layoutTitleLeft.constant = 34;
                }else{
                    self.layoutTitleLeft.constant = 16;
                }
            }
            
            //聚合
            if (model.aggregation_number.intValue >= 2) {
                self.layoutRedPointLeftToTitle.constant = 48;
                
                if (model.money_detail_type.intValue != 4) { //不是支付工资
                    self.labelAllNum.hidden = YES;
                    self.layutoTitleRightToMoney.constant = 8;
                    self.layoutRedPointLeftToTitle.constant = 0;
                }else{
                    self.layutoTitleRightToMoney.constant = 48;
                    self.labelAllNum.hidden = NO;
                    self.labelAllNum.textColor = MKCOLOR_RGB(89, 89, 89);
                    self.labelAllNum.font = [UIFont fontWithName:kFont_RSR size:13];
                    self.labelAllNum.text =[NSString stringWithFormat:@"(共%@次)",model.aggregation_number];
                }
            }else{
                self.layoutRedPointLeftToTitle.constant = 0;
            }

            if (model.small_red_point.intValue == 1) {
                self.imgRedPoing.hidden = NO;
            }else{
                self.imgRedPoing.hidden = YES;
            }
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
