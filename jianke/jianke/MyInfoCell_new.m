//
//  MyInfoCell_new.m
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_new.h"
#import "WDConst.h"

@interface MyInfoCell_new ()

@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIView *redPoint2;

@end

@implementation MyInfoCell_new

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellType:(MyInfoJKCellType)cellType{
    
    [self.redPoint2 setCornerValue:5.0f];
    
    self.redPoint2.hidden = YES;
    
    _cellType = cellType;
    self.moneyNum.hidden = YES;
    switch (cellType) {
        case MyInfoJKCellType_MoneyBag:{
            self.moneyNum.hidden = NO;
            self.labTitle.text = @"钱袋子";
            self.imgTag.image = [UIImage imageNamed:@"myNewInfo_moneyBox"];
            self.redPoint2.hidden = ![XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint;
        }
            break;
        case MyInfoJKCellType_JobCollection:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_collect"];
            self.labTitle.text = @"我的收藏";
        }
            break;
        case MyInfoJKCellType_MySubscription:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_manage"];
            self.labTitle.text = @"我的关注";
        }
            break;
        case MyInfoJKCellType_JiankeWeal:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_gift"];
            self.labTitle.text = @"兼客福利";
        }
            break;
        case MyInfoJKCellType_MyPersonalService:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_date"];
            self.labTitle.text = @"我的通告";
        }
            break;
        case MyInfoJKCellType_Guide:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_guide"];
            self.labTitle.text = @"帮助中心";
        }
            break;
        case MyInfoJKCellType_Suggest:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_suggest"];
            self.labTitle.text = @"意见反馈";
        }
            break;
        case MyInfoJKCellType_BindWechat:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_message"];
            self.labTitle.text = @"即时通知";
        }
            break;
        case MyInfoJKCellType_SwitchJKEP:{
            self.imgTag.image = [UIImage imageNamed:@"v320_my_switch"];
            self.labTitle.text = @"发布兼职入口";
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

@end
