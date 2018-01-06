//
//  SocialAcitvistCell.h
//  jianke
//
//  Created by 时现 on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SociaAcitvistModel.h"
#import "WDConst.h"



@protocol SocialAcitvistDelegate <NSObject>

- (void)sa_Cell_updateCellIndex:(NSIndexPath*)indexPath withModel:(SociaAcitvistModel*)model;
- (void)shareWihtModel:(SociaAcitvistModel *)model;

@end

@interface SocialAcitvistCell : UITableViewCell

@property (nonatomic,weak ) id<SocialAcitvistDelegate> delegate;
@property (nonatomic, assign) BOOL isNotSocialActivist;//是不是已经被撤销人脉王

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(SociaAcitvistModel *)model andIndexPath:(NSIndexPath*)indexPath;
@end
