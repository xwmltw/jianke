//
//  WDTableViewBase.h
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParamWrapper.h"
#import "WDConst.h"

typedef NS_ENUM(NSInteger, callBackType) {
    callBackType_defaultNoMoreData, //默认无数据UI
    callBackType_removeNoMoreData,  //移除无数据UI
    callBackType_throughNoMoreData, //直通车无数据UI
    callBackType_queryConditionNoMoreData,  //查询条件的无数据UI
};

@protocol WDTableDelegate <NSObject>
@optional
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath selectData:(id)data;
- (void)requestDidFinish:(id)data;
- (void)showNoDataViewWithActionType:(callBackType)actionType;
//- (void)noMoreData;
@end


@interface WDTableViewBase : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UIView *noSignalView;
@property (nonatomic, weak) UIViewController* owner;
@property (nonatomic, strong) NSMutableArray* arrayData;

@property (nonatomic, assign) WDTableViewRefreshType refreshType;
@property (nonatomic, weak) id <WDTableDelegate> delegate;
@property (nonatomic, strong) RequestParamWrapper* requestParam;
@property (nonatomic, assign) BOOL isInvitingForJob;
@property (nonatomic, assign) BOOL showNoDataView;
@property (nonatomic, assign) BOOL showNoSignalView;
@property (nonatomic, assign) BOOL isJKHomeVC;

//- (void)sendRequest;
- (void)showMore;
- (void)showLatest;
- (void)headerBeginRefreshing;

- (void)viewDidAppear;

- (void)reloadTableView;

@end
