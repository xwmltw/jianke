//
//  MyInfoCollect_Cell2.m
//  jianke
//
//  Created by fire on 16/11/1.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCollect_Cell2.h"
#import "WDConst.h"

@interface MyInfoCollect_Cell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIView *redPonit;


@end

@implementation MyInfoCollect_Cell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
    [self.redPonit setCornerValue:5.0f];
}

- (void)setCellType:(MyInfoJKCellType)cellType{
    _cellType = cellType;
    
//    NSMutableArray *array3 = [NSMutableArray array];
//    [array3 addObject:@(MyInfoJKCellType_PersonalService)];
//    [array3 addObject:@(MyInfoJKCellType_MySubscription)];
//    [array3 addObject:@(MyInfoJKCellType_Salary)];
//    [array3 addObject:@(MyInfoJKCellType_JobCollection)];
//    [array3 addObject:@(MyInfoJKCellType_JobApplyTrend)];
//    [array3 addObject:@(MyInfoJKCellType_Guide)];
//    
//    NSMutableArray *array4 = [NSMutableArray array];
//    [array4 addObject:@(MyInfoJKCellType_ShareApp)];
//    [array4 addObject:@(MyInfoJKCellType_Setting)];
    self.redPonit.hidden = YES;
    switch (cellType) {
        case MyInfoJKCellType_waitToDo:{
            if ([[UserData sharedInstance] isLogin] && [XSJUserInfoData sharedInstance].isShowMyApplyRedPoint) {
                self.redPonit.hidden = NO;
            }
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_waittodo_icon"];
            self.labTitle.text = @"我的报名";
        }
            break;
        case MyInfoJKCellType_PersonalService:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_idcard_icon"];
            self.labTitle.text = @"档案卡";
        }
            break;
        case MyInfoJKCellType_MySubscription:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_jianke_icon"];
            self.labTitle.text = @"我的关注";
        }
            break;
        case MyInfoJKCellType_Salary:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_salary_icon"];
            self.labTitle.text = @"预支工资";
        }
            break;
        case MyInfoJKCellType_JobCollection:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_star_icon"];
            self.labTitle.text = @"岗位收藏";
        }
            break;
        case MyInfoJKCellType_JobApplyTrend:{
            if ([[UserData sharedInstance] isLogin] && ![[UserData sharedInstance] isSubscribedJob]) {
                self.redPonit.hidden = NO;
            }
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_trend_icon"];
            self.labTitle.text = @"兼职意向";
        }
            break;
        case MyInfoJKCellType_Guide:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_guide_icon"];
            self.labTitle.text = @"帮助中心";
        }
            break;
        case MyInfoJKCellType_Setting:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_setting_icon"];
            self.labTitle.text = @"设置";
        }
            break;
        case MyInfoJKCellType_JiankeWeal:{
            self.imgIcon.image = [UIImage imageNamed:@"myInfo_weal_icon"];
            self.labTitle.text = @"兼客福利";
        }
            break;
        case MyInfoJKCellType_MyPersonalService:{
            if ([[UserData sharedInstance] isLogin] && [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint) {
                self.redPonit.hidden = NO;
            }
            self.imgIcon.image = [UIImage imageNamed:@"my_info_tonggao"];
            self.labTitle.text = @"我的通告";
        }
            break;
        default:
            break;
    }
}

@end
