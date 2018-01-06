//
//  MyInfoCell_new.h
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewInfoCell_Name.h"

@interface MyInfoCell_new : UITableViewCell
@property (nonatomic, copy) JKModel *model;
@property (nonatomic, assign) MyInfoJKCellType cellType;
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;
- (void)setCellType:(MyInfoJKCellType)cellType;
@end
