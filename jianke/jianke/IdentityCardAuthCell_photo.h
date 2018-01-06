//
//  IdentityCardAuthCell_photo.h
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

@class PostIdcardAuthInfoPM;

@protocol IdentityCardAuthCellPhotoDelegate <NSObject>

- (void)updatePhoto:(UIButton *)sender;

@end
#import "MKBaseTableViewCell.h"
#import "IdentityCardAuth_VC.h"

@interface IdentityCardAuthCell_photo : UITableViewCell

@property(nonatomic, weak) id <IdentityCardAuthCellPhotoDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setData:(PostIdcardAuthInfoPM *)postIdcardAuthInfo withIDCardAuthCellType:(IDCardAuthCellType)type;

@end
