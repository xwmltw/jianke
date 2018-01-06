//
//  IMImgTextFuncCell.h
//  jianke
//
//  Created by xiaomk on 15/12/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMImgTextFuncCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data and:(UIViewController*)vc;

@end
