//
//  MenuTimeViewController.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuBarController;
@interface MenuTimeViewController : UITableViewController

@property (nonatomic, assign) NSInteger selectType; /** 选中的选项 */
@property (nonatomic, weak) MenuBarController *menuBarVC;

@end
