//
//  MenuBarDefine.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客首页菜单MenuBar常量定义

#ifndef jianke_MenuBarDefine_h
#define jianke_MenuBarDefine_h

// MenuBar常量
static const CGFloat kMenuBarBtnCount = 4; /*!< 菜单Bar按钮个数 */
static const CGFloat kMenuBarBtnWidth = 51.5; /*!< 菜单Bar按钮宽度 */
static const CGFloat kMenuBarBtnHeight = kMenuBarBtnWidth; /*!< 菜单Bar按钮高度 */

static const CGFloat kMenuBarHeight = kMenuBarBtnHeight; /*!< 菜单Bar高度 */
static const CGFloat kMenuBarWidth = kMenuBarBtnWidth * kMenuBarBtnCount; /*!< 菜单Bar宽度 */
static const CGFloat kMenuBarBotton = 14; /*!< 菜单Bar底部距离view底部的距离 */

static const CGFloat kMenuContentBtnCol = 3; /*!< 子菜单按钮列数 */
static const CGFloat kMenuContentBtnRow = 5; /*!< 子菜单按钮行数 */
static const CGFloat kMenuContentBtnWidth = (kMenuBarWidth - kMenuContentBtnCol + 1)/ kMenuContentBtnCol; /*!< 子菜单按钮宽度 */
static const CGFloat kMenuContentBtnHeight = kMenuBarBtnHeight; /*!< 子菜单按钮高度 */

static const CGFloat kMenuContentHeight = kMenuContentBtnRow * kMenuContentBtnHeight; /*!< 子菜单高度 */
static const CGFloat kMenuContentWidth = kMenuBarWidth; /*!< 子菜单宽度 */


// 通知
//static NSString * const WDNotification_MenuClick = @"WDNotification_MenuClick";
//static NSString * const WDNotification_MenuClick_BtnType = @"WDNotification_MenuClick_BtnType";
//static NSString * const WDNotification_MenuClick_Select = @"WDNotification_MenuClick_Select";

#endif
