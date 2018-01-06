//
//  MyInfoCollect_cell1.m
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCollect_cell1.h"
#import "WDConst.h"

@interface MyInfoCollect_cell1 ()

@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labRedPoint;


@end

@implementation MyInfoCollect_cell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor XSJColor_newWhite];
    [self.labRedPoint setToCircle];
}

- (void)setJkModel:(JKModel *)jkModel{
    _jkModel = jkModel;
    
    self.labRedPoint.hidden = YES;
    self.labMoney.text = @"0";
    
    if ([[UserData sharedInstance] isLogin]) {
        self.labRedPoint.hidden = ![XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint;
        NSString* moneyStr = [NSString stringWithFormat:@"%0.2f", jkModel.acct_amount.floatValue*0.01];
        self.labMoney.text = moneyStr;
    }
}

@end
