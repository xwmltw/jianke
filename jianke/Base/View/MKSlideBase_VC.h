//
//  MKSlideBase_VC.h
//  jianke
//
//  Created by xiaomk on 16/6/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

typedef NS_ENUM(NSInteger, MKSlideVCType) {
    MKSlideVCType_singleVC = 0,
    MKSlideVCType_scrollView,
};

@interface MKSlideBase_VC : WDViewControllerBase

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) UIView *topBtnBgView;             /*!< 顶部按钮背景 */
@property (nonatomic, strong) UIView *viewBtnLine;              /*!< 按钮底部线 */
@property (nonatomic, strong) UIView *mainSingleView;           /*!< single View */


/** UI  */
@property (nonatomic, assign) MKSlideVCType slideVCType;
@property (nonatomic, assign) NSInteger maxShowBtnCount;        /*!< 显示按钮最大数 */
@property (nonatomic, assign) CGFloat topBtnHeight;             /*!< 顶部按钮高度 */
@property (nonatomic, assign, readonly) CGFloat topBtnWidth;    /*!< 按钮宽度 */

@property (nonatomic, strong) UIColor *topBtnNormalColor;
@property (nonatomic, strong) UIColor *topBtnSelectColor;

/**
 *  根据 title 列表初始化 顶部按钮列表
 *
 *  @param titleArray title列表
 */
- (void)initUIWithTitleArray:(NSArray *)titleArray;

/**
 *  初始化 self.vcArray 后调用此方法
 *
 *  @param index 第一次显示第几个 viewController
 */
- (void)initVcArrayOverAndShowFirstVCWithIndex:(NSInteger)index;

/**
 *  获取当前选中按钮的 index
 *
 *  @return _currentSelectBtnIndex
 */
- (NSInteger)getCurrentSelectBtnIndex;

/**
 *  根据 index 设置显示的 viewController
 *
 *  @param index: titleButton 的 index
 */
- (void)setSelectVcWithIndex:(NSInteger)index;  /*!< 设置显示的 vc */

/**
 *  设置 title Button title
 *
 *  @param title : title string
 *  @param index : title button index
 */
- (void)setBtnTitle:(NSString *)title withIndex:(NSInteger)index;

/**
 *  点击 title button
 *
 *  @param sender: title Button
 */
- (void)btnOnclick:(UIButton *)sender;          /*!< 自定义此事件 记得调 super */

/**
 *  当scrollView 滚动时调用的方法，重写次方法，添加scrollView滚动事件
 *
 *  @param scrollView : mainScrollView
 */
- (void)scrollViewDidEventWithScroll:(UIScrollView *)scrollView;

@end
