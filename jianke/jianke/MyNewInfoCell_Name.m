//
//  MyNewInfoCell_Name.m
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyNewInfoCell_Name.h"
#import "JKModel.h"
#import "UserData.h"

@interface MyNewInfoCell_Name ()


@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *btnAuth;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImgIcon;

@end

@implementation MyNewInfoCell_Name

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.imgHead setCornerValue:30.0f];
    
    [self.btnAuth addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnAuth.tag = btnActionType_auth;
    self.backgroundColor = [UIColor XSJColor_blackBase];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
                [self.idCardImgIcon setImage:[UIImage imageNamed:@"info_auth_ing1"]];
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
    if ([self.delegate respondsToSelector:@selector(myNewInfoCellName:btnActionType:)]) {
        [self.delegate myNewInfoCellName:self btnActionType:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
