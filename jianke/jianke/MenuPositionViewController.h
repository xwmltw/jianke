//
//  MenuPositionViewController.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuBarController;
@interface MenuPositionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *selectArray; /** 选中区域的数组 */
@property (nonatomic, weak) MenuBarController *menuBarVC;

@end
