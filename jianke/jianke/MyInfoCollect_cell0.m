//
//  MyInfoCollect_cell0.m
//  jianke
//
//  Created by fire on 16/11/1.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCollect_cell0.h"
#import "WDConst.h"

@interface MyInfoCollect_cell0 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *btnAuth;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImgIcon;


@end

@implementation MyInfoCollect_cell0

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor XSJColor_newWhite];
    [self.imgHead setCornerValue:30.0f];

    [self.btnAuth addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnAuth.tag = btnActionType_auth;
    self.backgroundColor = [UIColor XSJColor_blackBase];
}

- (void)setJkModel:(JKModel *)jkModel{
    _jkModel = jkModel;
    self.leftLine.hidden = YES;
    self.labName.text = @"你好,兼客";
    self.btnAuth.hidden = YES;
    self.idCardImgIcon.hidden = YES;
    if ([[UserData sharedInstance] isLogin]) {
        NSString *nameStr;
        NSString *profileUrlStr;
        int verifyStatus;
        nameStr = jkModel.true_name;
        profileUrlStr = jkModel.profile_url;
        verifyStatus = jkModel.id_card_verify_status.intValue;
        self.labName.text = nameStr;
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:profileUrlStr] placeholderImage:[UIHelper getDefaultHead]];
        switch (verifyStatus) {
            case 1:{
                self.btnAuth.hidden = NO;
                self.leftLine.hidden = NO;
            }
                break;
            case 2:{
                self.idCardImgIcon.hidden = NO;
                [self.idCardImgIcon setImage:[UIImage imageNamed:@"info_auth_ing"]];
            }
                
                break;
            case 3:{
                self.idCardImgIcon.hidden = NO;
                self.idCardImgIcon.image = [UIImage imageNamed:@"person_service_vertify"];
            }
                break;
            case 4:
                self.btnAuth.hidden = NO;
                self.leftLine.hidden = NO;
                break;
            default:
                break;
        }
        
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyInfoCollectCell:actionType:)]) {
        [self.delegate MyInfoCollectCell:self actionType:sender.tag];
    }
}

@end
