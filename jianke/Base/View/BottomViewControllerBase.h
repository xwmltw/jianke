//
//  BottomViewControllerBase.h
//  jianke
//
//  Created by xuzhi on 16/7/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeNone,    //不刷新
    RefreshTypeHeader,
    RefreshTypeFooter,
    RefreshTypeAll
};

typedef NS_ENUM(NSInteger, DisplayType) {
    DisplayTypeOnlyTableView = 1,
    DisplayTypeTableViewAndBottom,
    DisplayTypeTableViewAndTopBottom
};

#import "WDViewControllerBase.h"

@interface BottomViewControllerBase : WDViewControllerBase <UITableViewDataSource,UITableViewDelegate>

#pragma mark - tableview相关(属性)
/** tableview */
@property (nonatomic,weak) UITableView *tableView;

/** tableview样式 */
@property (nonatomic,assign) UITableViewStyle tableViewStyle;

/** 数据源数组 */
@property (strong,nonatomic) NSMutableArray *dataSource;

/** 刷新方式 */
@property (nonatomic,assign) RefreshType refreshType;

/** 显示风格 */
@property (nonatomic,assign,readonly) DisplayType type;

#pragma mark - 底部视图相关相关(属性)
/** 底部视图 */
@property (nonatomic,weak) UIView *bottomView;

/** button事件 */
@property (copy,nonatomic) MKBlock btnEventBlock;

/** 底部按钮数组 */
@property (nonatomic, copy ,readonly) NSArray *bottomBtns;

/** 底部按钮文字 */
@property (nonatomic, copy) NSArray *btntitles;

/** 底部按钮外边框 */
@property (nonatomic,assign) CGFloat marginX;

/** 底部按钮距离屏幕底部 */
@property (nonatomic,assign) CGFloat marginY;

/** 底部按钮高度 */
@property (nonatomic,assign) CGFloat btnHeight;

#pragma mark - 顶部视图相关(属性)
/** 顶部视图 */
@property (nonatomic, weak, readonly) UIView *topView;

#pragma mark - 方法
/** 初始化UI */
- (void)initUIWithType:(DisplayType)type;

/** 下拉响应方法 */
- (void)headerRefresh;

/** 上拉响应方法 */
- (void)footerRefresh;

/** 显示底部视图 */
- (void)showBottomView;

/** 隐藏底部视图 */
- (void)hidesBottomView;

/** 按钮响应方法,如果btnEventBlock设置，则该方法不调用 */
- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
