//
//  SYMutiTabsNavController.h
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYMutiTabsNavController;

/**
 *  子控制器需要遵守这个协议
 */
@protocol SYMutiTabsNavSubControllerDelegate <NSObject>

/**
 *  加载数据
 */
- (void)loadData;

@end



@interface SYMutiTabsNavController : UIViewController

#pragma mark - tab栏设置属性

/**
 *  每个屏幕显示tabTitle数
 *  默认值: 3
 */
@property (nonatomic, assign) NSInteger tabTitleCountPerScreen;

/**
 *  tabTitle默认显示颜色
 *  默认值: RGBA(255 255 255 0.7)
 */
@property (nonatomic, strong, nullable) UIColor *tabTitleNormalColor;

/**
 *  tabTitle高亮颜色
 *  默认值: RGBA(255 255 255 1.0)
 */
@property (nonatomic, strong, nullable) UIColor *tabTitleHightlightColor;


/**
 *  tabTitle字体
 *  默认值: 16号系统默认字体
 */
@property (nonatomic, strong, nullable) UIFont *tabTitleFont;

/**
 *  tabTitle高度
 *  默认值: 36
 */
@property (nonatomic, assign) CGFloat tabViewHeight;


/**
 *  tab标签选中后底部选中标示线的颜色
 *  默认值: [UIColor XSJColor_base]
 */
@property (nonatomic, strong, nullable) UIColor *tabSelectLinecolor;

/**
 *  tab默认选中序号
 *  默认值: 0
 */
@property (nonatomic, assign) NSInteger tabDefaultSelectIndex;


/**
 *  tabTitleView背景色
 *  默认值: RGB(0 188 212)
 */
@property (nonatomic, strong, nullable) UIColor *tabViewBackgroundColor;

/**
 *  数据延迟加载, 在subController的View显示出来的时候才加载数据
 *  默认值: YES
 */
@property (nonatomic, assign) BOOL dataDelayLoad;

/**
 *  每次滑动展示subController的View的时候是否重新加载数据
 *  默认值: NO
 */
@property (nonatomic, assign) BOOL reloadDateWhenShow;


#pragma mark - 初始化方法
- (instancetype)initWithsubControllers:(NSArray <__kindof UIViewController<SYMutiTabsNavSubControllerDelegate> *> *)subControllers titleArray:(NSArray<NSString *> *)titleArray;


@end

NS_ASSUME_NONNULL_END

