//
//  MenuBarController.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客首页底部菜单工具条

#import <UIKit/UIKit.h>

///** MenuBar按钮类型 */
//typedef NS_ENUM(NSInteger, MenuBarBtnType) {
//    MenuBarBtnTypePosition = 1, /*!< 位置 */
//    MenuBarBtnTypeJob, /*!< 岗位 */
//    MenuBarBtnTypeTime, /*!< 事件 */
//    MenuBarBtnTypeMoney /*!< 薪资 */
//};


@class MenuBarController;
@protocol MenuBarDelegate <NSObject>

@optional
///**
// *  菜单选项被选择后调用
// *
// *  @param menuBarVC 菜单栏控制器
// *  @param type      选中的菜单按钮类型
// *  @param choose    选中的子菜单内容
// */
//- (void)menuBar:(MenuBarController *)menuBarVC didClickBtnType:(MenuBarBtnType)type withChoose:(id)choose;

- (void)menuBar:(MenuBarController *)menuBarVC didClickedWithChoose:(NSString *)choose;

@end



@interface MenuBarController : UIViewController

@property (nonatomic, weak) id<MenuBarDelegate> delegate;

- (void)coverBtnClick;
- (void)setViewXWithType:(BOOL)bType;
@end
