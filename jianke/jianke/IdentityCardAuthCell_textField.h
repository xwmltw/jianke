//
//  IdentityCardAuthCell_textField.h
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

@class PostIdcardAuthInfoPM;

#import "MKBaseTableViewCell.h"
#import "IdentityCardAuth_VC.h"

@interface IdentityCardAuthCell_textField : MKBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setData:(PostIdcardAuthInfoPM *)postIdcardAuthInfo withIDCardAuthCellType:(IDCardAuthCellType)type;

@end
