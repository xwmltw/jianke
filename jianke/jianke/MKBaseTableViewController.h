//
//  MKBaseTableViewController.h
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface MKBaseTableViewController : WDViewControllerBase<UITableViewDelegate, UITableViewDataSource>

/**
 *  底部View
 */
@property (nonatomic, strong) UIView* bottomView;

/**
 *  底部按钮
 */
@property (nonatomic, strong) UIButton* btnBottom;
/**
 *  主UITableView
 */
@property (nonatomic, strong) UITableView* tableView;

/**
 *  初始化init的时候 设置 tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  分页模型
 */
@property (nonatomic, strong) QueryParamModel* queryParam;

/**
 *  主数据源
 */
@property (nonatomic, strong) NSMutableArray *datasArray;

@property (nonatomic, assign) BOOL isNeedHeadRefresh;
/**
 *  加载本地或者网络数据源 下拉刷新调用 此方法， 记得重置  datasArray
 */
- (void)loadDataSource;

/**
 *  设置单独 tableView 的UI
 */
- (void)setUISingleTableView;


/**
 *  设置有底部按钮的tableView UI
 */
- (void)setUIHaveBottomView;

/**
 *  点击底部按钮事件
 *
 *  @param sender 按钮
 */
- (void)btnBottomOnclick:(UIButton*)sender;

/**
 *  去除iOS7 新的功能 api tableView 的分割线 变成iOS6的正常的样式
 */
- (void)configuraTableViewSeparatorInset;

/**
 *  配置tableView右侧的index title 背景颜色，因为在iOS7有白色底色，iOS6没有
 *
 *  @param tableView 目标tableView
 */
- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView;


@end
