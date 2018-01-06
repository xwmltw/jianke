//
//  MyNewInfoCell_Resume.m
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyNewInfoCell_Resume.h"
#import "WDConst.h"

@interface MyNewInfoCell_Resume ()

@property (weak, nonatomic) IBOutlet UIView *redPoint1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIView *redPoint2;


@property (weak, nonatomic) IBOutlet UIView *redPoint3;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;



@end

@implementation MyNewInfoCell_Resume

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.redPoint1 setCornerValue:5.0f];
    [self.redPoint2 setCornerValue:5.0f];
    [self.redPoint3 setCornerValue:5.0f];
    
    [self.btn1 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.tag = ResumeBtnType_MyJoin;
    [self.btn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btn2.tag = ResumeBtnType_MoneyBag;
    [self.btn3 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btn3.tag = ResumeBtnType_JobTrends;
    [self.btnResume addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnResume.tag = ResumeBtnType_MyProfile;
    [self.btnLogin addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin.tag = ResumeBtnType_Login;
    [self.btnRefresh addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRefresh.tag = ResumeBtnType_Refresh;

    [self.btnResume setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
}

- (void)setModel:(JKModel *)model{
    self.redPoint1.hidden = YES;
    self.redPoint2.hidden = YES;
    self.redPoint3.hidden = YES;
    if ([[UserData sharedInstance] isLogin]) {
        self.redPoint3.hidden = [[UserData sharedInstance] isSubscribedJob];
        self.redPoint1.hidden = ![XSJUserInfoData sharedInstance].isShowMyApplyRedPoint;
        self.redPoint2.hidden = ![XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint;
        self.btnResume.hidden = NO;
        self.btnLogin.hidden = YES;
        self.btnRefresh.hidden = NO;
        if (model.complete) {
            NSString *str = [NSString stringWithFormat:@"我的简历(完整度%@%%)", model.complete];
            NSMutableAttributedString *mutablStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_base], NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBaselineOffsetAttributeName: @2}];
            [mutablStr addAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_base], NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSBaselineOffsetAttributeName: @0} range:NSRangeFromString(@"{0, 4}")];
            
            [self.btnResume setAttributedTitle:mutablStr forState:UIControlStateNormal];
        }else{
            [self.btnResume setTitle:[NSString stringWithFormat:@"我的简历"] forState:UIControlStateNormal];
        }
        
        
    }else{
        self.btnLogin.hidden = NO;
        self.btnResume.hidden = YES;
        self.btnRefresh.hidden = YES;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyNewInfoCellResume:actionType:)]) {
        [self.delegate MyNewInfoCellResume:self actionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
