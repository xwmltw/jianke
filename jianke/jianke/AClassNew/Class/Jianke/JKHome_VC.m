//
//  JKHome_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKHome_VC.h"

#import "SDCycleScrollView.h"
#import "MenuView.h"
#import "NewsView.h"
#import "JSDropDownMenu.h"
#import "MenuDataSource.h"
#import "MenuBtn.h"
#import "ServiceView.h"

#import "UserData.h"
#import "CityTool.h"
#import "ImDataManager.h"
#import "XSJRequestHelper.h"
#import "JKHomeModel.h"

#import "JobSearchList_VC.h"
#import "CitySelectController.h"
#import "WebView_VC.h"
#import "JobDetail_VC.h"
#import "JobController.h"
#import "TopicJobList_VC.h"
#import "JobExpress_VC.h"
#import "PersonalList_VC.h"
#import "XZTabBarCtrl.h"
#import "PlatOrderList_VC.h"
#import "ParttimeJobList_VC.h"
#import "UINavigationBar+Awesome.h"

#import "XSJFirstChooseView.h"
#import "AccountMoneyModel.h"
#import "UITabBar+MKExtension.h"

#import "XZOpenUrlHelper.h"
#import "XZVideoTool.h"
#import <WebKit/WebKit.h>
#import "GuideMaskView.h"
#import "MainTabBarCtlMgr.h"
#import "XSJNotifyHelper.h"
#import "LookupResume_VC.h"
#import "VariousAlertView.h"
#import "WelcomeJoinJK_VC.h"
#import "RegisterGuide_VC.h"

@interface JKHome_VC ()<SDCycleScrollViewDelegate, JSDropDownMenuSelectDelegate, MenuViewDelegate, NewsViewDelegate, WDTableDelegate>{
    NSArray* _adArrayData;       /*!< 广告条数据 */

}
@property (nonatomic, strong) UIButton *localBtn;
@property (nonatomic, weak) UITableView *leftTableView;   /*!< 岗位列表tableView */
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, assign) CGFloat tableHeaderViewH;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) SDCycleScrollView *cycleBannerSV; /*!< banner 广告 */
@property (nonatomic, strong) MenuView *menuView;               /*!< 特色入口菜单 */
@property (nonatomic, strong) NewsView *newsView;               /*!< 兼客头条View */
@property (nonatomic, strong) UIView *serviceView;         /*!< 个人服务入口 */

@property (nonatomic, strong) JSDropDownMenu *tableSectionView; /*!< 撒选控件section */
@property (nonatomic, strong) MenuDataSource *menuDataSource;   /*!< 撒选控件 */
@property (nonatomic, strong) UIView *grayView;

@property (nonatomic, strong) JobExpress_VC *jobExpressVC;       /*!< 岗位列表 */
@property (nonatomic, strong) CityModel *nowCity;                /*!< 城市信息 */

@end

@implementation JKHome_VC

#pragma mark - ***** 添加通知 ******
- (void)addNotification{
    [WDNotificationCenter removeObserver:self];
    //登录成功通知
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    //    //退出登录
    //    [WDNotificationCenter addObserver:self selector:@selector(logoutWithUI) name:WDNotifi_setLoginOut object:nil];
    //消息铃铛数量
    [WDNotificationCenter addObserver:self selector:@selector(updateMsgNum:) name:WDNotification_JK_homeUpdateMsgNum object:nil];
    // 钱袋子小红点通知
    [WDNotificationCenter addObserver:self selector:@selector(walletNotify) name:IMPushWalletNotification object:nil];
    // 待办事项大红点通知
    [WDNotificationCenter addObserver:self selector:@selector(updateWaitTodo) name:IMPushJKWaitTodoNotification object:nil];
    //个人服务邀约通知
    [WDNotificationCenter addObserver:self selector:@selector(updatePersonServiceRedpoint) name:IMPushGetPersonaServiceJobNotification object:nil];
    //app进入前台
    [WDNotificationCenter addObserver:self selector:@selector(updateDataList) name:AppWillBecomeBeforeground object:nil];
    
    //被T下线
    [WDNotificationCenter addObserver:self selector:@selector(clearTabbarRedPoint) name:WDNotifi_clearTabbarRedPoint object:nil];
    
    //注册成功后提示完善简历
    [WDNotificationCenter addObserver:self selector:@selector(displayAlertView) name:PerfectResumeAlertViewNotification object:nil];
}

#pragma mark - ***** Navigation button ******
- (void)initNavigationButton{
    self.localBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.localBtn.frame = CGRectMake(0, 0, 120, 44);
    self.localBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.localBtn setImage:[UIImage imageNamed:@"v3_home_location"] forState:UIControlStateNormal];
    self.localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.localBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.localBtn addTarget:self action:@selector(localBtnOnclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.localBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //    UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    nevgativeSpaceLeft.width = -20;
    //    self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft, leftItem];
    [self updateLocalBtnTitle];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake( 0, 0, 44, 44);
    [searchBtn setImage:[UIImage imageNamed:@"v3_home_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nevgativeSpaceRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceRight.width = -12;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[nevgativeSpaceRight,rightItem];
}

- (void)updateLocalBtnTitle{
    CityModel *ctModel = [[UserData sharedInstance] city];
    if (ctModel) {
        [self.localBtn setTitle:ctModel.name forState:UIControlStateNormal];
    }
}

#pragma mark - ***** ViewDidLoad ******
- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    NSArray *array = [UIApplication sharedApplication].windows;
    
    [array enumerateObjectsUsingBlock:^(UIWindow*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ELog(@"%@", obj);
    }];
    [XZOpenUrlHelper openJobDetailWithblock:^(NSString *jobUuid) {
        JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
        viewCtrl.jobUuid = jobUuid;
        viewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] activateAutoLoginWithBlock:^(id result) {
        [weakSelf initUI];
    }];
    
    [self postThirdInfo];
   
}

- (void)postThirdInfo{
//    if ([UserData sharedInstance].registrationID) {
//        WEAKSELF
//        [[XSJRequestHelper sharedInstance] postThirdPushPlatInfo:[UserData sharedInstance].registrationID block:^(id result) {
//            
//        }];
//    }
    
}

- (void)initUI{
    [self addNotification];
    [self initNavigationButton];
    
    // 选择城市
    CityModel* cityModel = [[UserData sharedInstance] city];
    if (cityModel) {
        WEAKSELF
        [CityTool getCityModelWithCityId:cityModel.id block:^(CityModel *cModel) {
            if (cModel) {
                [[UserData sharedInstance] setCity:cModel];
                _nowCity = cModel;
                [weakSelf initTableHeaderView];
            }
            [weakSelf postRequest];
        }];
        [self initUIWithCity];

    }else{
        CitySelectController* cityVC = [[CitySelectController alloc] init];
        cityVC.showSubArea = NO;
        cityVC.hidesBottomBarWhenPushed = YES;
        WEAKSELF
        cityVC.didSelectCompleteBlock = ^(CityModel *area){
            if (area && [area isKindOfClass:[CityModel class]]) {
                [[UserData sharedInstance] setCity:area];
                [UserData sharedInstance].isRefreshZBHome = YES;
                [weakSelf initUIWithCity];
            }
        };
        MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:cityVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

- (void)postRequest{
    CityModel *cityModel = [UserData sharedInstance].city;
    LocalModel *model = [UserData sharedInstance].local;
    
    if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1}",_nowCity.id];
        }
    }else{
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",_nowCity.id];
        }
    }
    
    [_jobExpressVC headerBeginRefreshing];

}

- (void)initUIWithCity{
    
    _nowCity = [[UserData sharedInstance] city];
    [self updateLocalBtnTitle];
    
    [self initMainUI];


    
    _jobExpressVC.tableSectionView = self.tableSectionView;

    
    [self.tableSectionView hideMenu]; // 收起筛选控件
//    [self.menuDataSource getData]; // 刷新筛选控件数据
    /** 登录 IM */
    [self initUIWithData];
    [self showChangeEPAlert];

}


#pragma mark - ***** initMainUI ******
- (void)initMainUI{
    _nowCity = [[UserData sharedInstance] city];
    [self initTableView];
    [self initTableHeaderView];
//    ELog(@"tableView:%@",[self.leftTableView description]);
}

#pragma mark - ***** 初始化用户数据 ******
- (void)initUIWithData{
    if ([[UserData sharedInstance] isLogin]) {
        [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
            if (jkModel) {
                [self enterWelcome:jkModel];
            }
        }];
        if (![[ImDataManager sharedInstance] isUserLogin]) {
            [[ImDataManager sharedInstance] tryLogin];
        }
        [self setWallet];
        [self waitTodoRedPoint];
    }
}

- (void)enterWelcome:(JKModel *)jkModel{
    if (jkModel.true_name.length && !jkModel.is_subscribe_job.integerValue) {
        [MKUIHelper getTopNavigationCtrl:^(UINavigationController *nav) {
            RegisterGuide_VC *viewCtrl = [[RegisterGuide_VC alloc] init];
            viewCtrl.city_id = [UserData sharedInstance].city.id;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            viewCtrl.isLogin = YES;
            viewCtrl.block = ^(UIViewController *controller){

                [nav popToRootViewControllerAnimated:YES];
          
            };
            [nav pushViewController:viewCtrl animated:YES];
        }];
    }
}

/** 设置钱袋子小红点 */
- (void)setWallet{
    if ([[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] queryAccountMoneyWithBlock:^(ResponseInfo *response) {
            if (response && response.success) {
                AccountMoneyModel *account = [AccountMoneyModel objectWithKeyValues:response.content[@"account_money_info"]];
                if (account.money_bag_small_red_point.integerValue > 0) {
                    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = YES;
                    [weakSelf walletNotify];
                }else{
                    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = NO;
                }
            }
        }];
    }
}

- (void)waitTodoRedPoint{
   JKModel *jkInfo = [[UserData sharedInstance] getJkModelFromHave];
    if (jkInfo.my_apply_job_big_red_point && jkInfo.my_apply_job_big_red_point.integerValue > 0) {
        [self updateWaitTodo];
    }
}

/** 首次进入 是否切换搞雇主 */
- (void)showChangeEPAlert{
    if (![[XSJUserInfoData sharedInstance] getIsOpenAppYet]) {
        [[XSJUserInfoData sharedInstance] setIsOpenAppYet:YES];
//        [XSJFirstChooseView showViewWithBlock:^(NSInteger selectIndex) {
//            if (selectIndex == 1) {
//                // 切换雇主
//                [XSJUIHelper switchIsToEP:YES];
//            }
//        }];
    }else{
        [UserData delayTask:3 onTimeEnd:^{
            [[XSJUIHelper sharedInstance] showCommentAlertWithVC:self];
        }];
    }
}

#pragma mark - ***** init end ******



#pragma mark - ***** 按钮事件 ******
- (void)localBtnOnclick{
//小红点测试
//    [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];    //显示小红点
//    [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = YES;
//    [self.tabBarController.tabBar showSmallBadgeOnItemIndex:3];

    
    CitySelectController* cityVC = [[CitySelectController alloc] init];
    cityVC.showSubArea = NO;
    cityVC.isPushAction = YES;
    cityVC.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    cityVC.didSelectCompleteBlock = ^(CityModel *area){
        if (area && [area isKindOfClass:[CityModel class]]) {
            [[UserData sharedInstance] setCity:area];
            [UserData sharedInstance].isRefreshZBHome = YES;
            [weakSelf refreshWithCityChange];
        }
    };
//    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:cityVC];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)refreshWithCityChange{
    _nowCity = [[UserData sharedInstance] city];
    
    [self updateLocalBtnTitle];

    LocalModel *model = [UserData sharedInstance].local;
    if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1}",_nowCity.id];
        }
    }else{
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",_nowCity.id];
        }
    }

    [_jobExpressVC headerBeginRefreshing];
    
    [self.tableSectionView hideMenu]; // 收起筛选控件
    [self.tableSectionView resetMenuData];  //重置筛选控件数据
    [self.menuDataSource resetData];    //重置筛选控件数据
    [self.menuDataSource getData]; // 刷新筛选控件数据
    [self getGlobalInfo];    
}

- (void)getGlobalInfo{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:YES withBlock:^(id result) {
        if (result) {
            [weakSelf initTableHeaderView]; // 刷新headView
        }
    }];
}

- (void)searchBtnOnClick:(id)sender{
    [TalkingData trackEvent:@"兼客首页_岗位搜索"];
    JobSearchList_VC *vc = [[JobSearchList_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - ***** SDCycleScrollViewDelegate  点击广告条 ******
//广告点击跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ELog(@"---点击了第%ld张图片", (long)index);
    if (_adArrayData.count <= 0) {
        return;
    }
    
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            
        }
    }];
    
    NSString *numBanner = [NSString stringWithFormat:@"%ld",index + 1];
    [TalkingData trackEvent:@"兼职快讯_Banner" label:numBanner];
    
    AdModel* model = _adArrayData[index];
    // 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型
    [[XSJRequestHelper sharedInstance] queryAdClickLogRecordWithADId:model.ad_id];

    switch (model.ad_type.intValue) {
        case 1:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = model.ad_detail_url;
            vc.uiType = WebViewUIType_Banner;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                return;
            }
            //进入岗位详情
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
        }
            break;
        case 4:{
            TopicJobList_VC *vc = [[TopicJobList_VC alloc] init];
            vc.adDetailId = model.ad_detail_id.stringValue;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ***** MenuViewDelegate  特色入口 ******
- (void)menuView:(MenuView *)menuView didClickBtn:(MenuBtn *)btn{
    MenuBtnModel *model = btn.model;
    
    NSString* tdStr = [NSString stringWithFormat:@"兼客首页_特色入口_%@",model.special_entry_title];
    [TalkingData trackEvent:tdStr];
    
    switch (model.special_entry_type_new.integerValue) {
        case 1:{ // 1：应用内打开链接
            if (!model.special_entry_url || model.special_entry_url.length < 5) {
                return;
            }
            NSString *url = [model.special_entry_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = url;
            vc.uiType = WebViewUIType_Feature;
            vc.title = model.special_entry_title;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2: {// 2：应用外打开链接
            if (!model.special_entry_url || model.special_entry_url.length < 5) {
                return;
            }
            NSString *url = [model.special_entry_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
            break;
            
        case 3:{ // 3：岗位列表
            CityModel *city = [[UserData sharedInstance] city];
            LocalModel *localModel = [[UserData sharedInstance] local];
            
            // 跳转普通岗位列表页面
            RequestParamWrapper *requestParam = [[RequestParamWrapper alloc] init];
            requestParam.serviceName = @"shijianke_querySpecialEntryJobList";
            requestParam.typeClass = NSClassFromString(@"JobModel");
            requestParam.arrayName = @"self_job_list";
            requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
            requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
            requestParam.content = [NSString stringWithFormat:@"\"special_entry_id\":\"%@\", \"city_id\":\"%@\", \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"", model.special_entry_id.stringValue, city.id.stringValue, localModel?localModel.latitude:@"0", localModel?localModel.longitude:@"0"];
            
            JobController *vc = [[JobController alloc] init];
            vc.titleName = model.special_entry_title;
            vc.requestParam = requestParam;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{ // 4: 抢单列表
            // 跳转抢单岗位列表页面
            CityModel *city = [[UserData sharedInstance] city];
            
            // 跳转普通岗位列表页面
            RequestParamWrapper *requestParam = [[RequestParamWrapper alloc] init];
            requestParam.serviceName = @"shijianke_queryGrabSingleJobList";
            requestParam.typeClass = NSClassFromString(@"JobModel");
            requestParam.arrayName = @"self_job_list";
            requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
            requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
            requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@}", city.id.stringValue];
            
            JobController *vc = [[JobController alloc] init];
            vc.isSeizeJob = YES;
            vc.titleName = model.special_entry_title;
            vc.requestParam = requestParam;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            TopicJobList_VC* vc = [[TopicJobList_VC alloc] init];
            vc.adDetailId = model.job_topic_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ***** NewsViewDelegate ******
- (void)newsView:(NewsView *)aNewsView btnClick:(NewsBtn *)aBtn{
    ELog(@"NewsViewDelegate - 兼客头条新闻点击");
    ELog(@"%@", aBtn.model.ad_name);
    
    AdModel *model = aBtn.model;
    [[XSJRequestHelper sharedInstance] queryAdClickLogRecordWithADId:model.ad_id];

    switch (model.ad_type.integerValue) {
        case 1: // 应用内打开
        {
            if (!model.ad_detail_url || model.ad_detail_url.length < 5) {
                return;
            }
            NSString *url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = url;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
          
        }
            break;
        case 2: // 岗位广告
        {
            if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                return;
            }
            // 进入岗位详情
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: // 浏览器打开链接
        {
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ***** JSDropDownMenuSelectDelegate ******
- (void)menu:(JSDropDownMenu *)menu didSelectResult:(NSString *)result{
    ELog(@"JSDropDownMenuSelectDelegate");
    _jobExpressVC.requestParam.content = result;
    _jobExpressVC.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    _jobExpressVC.requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
    
    [_jobExpressVC headerBeginRefreshing];
    self.leftTableView.scrollEnabled = !menu.show;
}

- (void)menuWillShow:(JSDropDownMenu *)menu{
    CGFloat tableHeaderViewHeight = self.tableHeaderView.height;
    CGFloat contentOffsetY = self.leftTableView.contentOffset.y;
    
    if (contentOffsetY < tableHeaderViewHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            self.leftTableView.contentOffset = CGPointMake(0, tableHeaderViewHeight - 64);
        }];
    }
}

- (void)menuDidShow:(JSDropDownMenu *)menu{
    self.leftTableView.scrollEnabled = !menu.show;
    //    self.leftTableView.footer.hidden = YES;
}

#pragma mark - ***** ScrollViewDidScroll ******
- (void)onScrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor XSJColor_blackBase];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = MIN(1, offsetY/(self.tableHeaderViewH - 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    if ([self.leftTableView.header isRefreshing]) {
        CGFloat tableHeaderViewHeight = self.leftTableView.tableHeaderView.height;
        CGFloat contentOffsetY = self.leftTableView.contentOffset.y;
        if (contentOffsetY > tableHeaderViewHeight - 64 - 54) {
            self.leftTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }  else {
            self.leftTableView.contentInset = UIEdgeInsetsMake(64+54, 0, 0, 0);
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (self.leftTableView) {
        [self onScrollViewDidScroll:self.leftTableView];
    }else{
        [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor XSJColor_blackBase] colorWithAlphaComponent:0]];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [WDNotificationCenter removeObserver:self name:LoginSuccessNoticeBindWechat object:nil];
    [self.navigationController.navigationBar lt_reset];
}



#pragma mark - ***** initTableView HearderView ******
- (void)initTableView{
    [self.leftTableView removeFromSuperview];
    self.leftTableView = nil;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView = tableView;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.backgroundColor = [UIColor XSJColor_newWhite];
    self.leftTableView.scrollsToTop = YES;
    self.leftTableView.showsHorizontalScrollIndicator = NO;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.leftTableView];
    self.leftTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
#ifndef iPhoneX
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-88);
    }];
#else
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-64);
    }];
#endif
    
    
    _jobExpressVC = nil;
    
    _jobExpressVC = [[JobExpress_VC alloc] init];
    _jobExpressVC.tableView = self.leftTableView;
    _jobExpressVC.owner = self;
    _jobExpressVC.isJKHomeVC = YES;
    _jobExpressVC.isHome = YES;
    [_jobExpressVC getHistoryData];
    _jobExpressVC.refreshType = WdTableViewRefreshTypeHeader | WdTableViewRefreshTypeFooter;
    _jobExpressVC.requestParam.serviceName = @"shijianke_queryJobListFromApp";
    _jobExpressVC.requestParam.typeClass = NSClassFromString(@"JobModel");
    _jobExpressVC.requestParam.arrayName = @"self_job_list";
    _jobExpressVC.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    _jobExpressVC.requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
//    _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@}",_nowCity.id];
    WEAKSELF
    _jobExpressVC.block = ^(UIViewController *vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    LocalModel *model = [UserData sharedInstance].local;
    
    if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1, coord_use_type:1}",_nowCity.id];
        }
    }else{
        if (model) {
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",_nowCity.id, model.latitude, model.longitude];
        }else{
            _jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",_nowCity.id];
        }
    }
    
    _jobExpressVC.delegate = self;
    [_jobExpressVC.tableView reloadData];
    [_jobExpressVC.tableView setContentOffset:CGPointMake(0, -64) animated:NO];
    [_jobExpressVC headerBeginRefreshing];
}


- (void)initTableHeaderView{
    [self.tableHeaderView removeFromSuperview];
    self.tableHeaderView = nil;
    
    self.tableHeaderView = [[UIView alloc] init];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    CGFloat bannerH = SCREEN_WIDTH*0.456;
    self.cycleBannerSV.frame = CGRectMake(0, -64, SCREEN_WIDTH, bannerH);
    [self.tableHeaderView addSubview:self.cycleBannerSV];
    self.tableHeaderViewH = bannerH-64;
    
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel) {
            if (globaModel.banner_ad_list && globaModel.banner_ad_list.count > 0) {
                _adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.banner_ad_list];
                if (_adArrayData || _adArrayData.count > 0) {
                    [[UserData sharedInstance] saveHomeADListWithArray:_adArrayData];
                    [self refreshBannerWithArray:_adArrayData];
                }
            }
        
    }else{
        _adArrayData = [[UserData sharedInstance] getHomeADList];
        if (_adArrayData && _adArrayData.count > 0) {
            [self refreshBannerWithArray:_adArrayData];
        }
        
    }
    
    ClientGlobalInfoRM *globalInfoRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globalInfoRM.is_not_support_zhong_bao.integerValue != 1) {
        // 特色入口
        [self initMenuView];
    }
    
    // 兼客头条
    [self importantNew];
    
//    //个人服务展示
//    [self initServiceView];
    
    // 添加底部灰色条
//    [self.grayView removeFromSuperview];
//    [self.grayView setY:self.tableHeaderViewH];
//    [self.tableHeaderView addSubview:self.grayView];
    self.tableHeaderViewH += 8;
    
    //初始化完成  设置tableViewheader
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableHeaderViewH);
    self.leftTableView.tableHeaderView = self.tableHeaderView;
}

/** 刷新广告条 */
- (void)refreshBannerWithArray:(NSArray*)dataArray{
    NSMutableArray* imgArray = [[NSMutableArray alloc] init];
    for (AdModel* model in dataArray) {
        if (model.img_url) {
            [imgArray addObject:model.img_url];
        }
    }
    if (dataArray.count == 1) {
        _cycleBannerSV.autoScrollTimeInterval = 3600;
    }else{
        _cycleBannerSV.autoScrollTimeInterval = 3;
    }
    _cycleBannerSV.imageURLStringsGroup = imgArray;

}

/** 特色入口 */
- (void)initMenuView{
    NSArray* menuBtnModelArray;
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel.special_entry_list && globaModel.special_entry_list.count > 0) {
        menuBtnModelArray = [MenuBtnModel objectArrayWithKeyValuesArray:globaModel.special_entry_list];
        if (!menuBtnModelArray || menuBtnModelArray.count == 0) {
            return;
        }
        //保存到本地做无网络显示
        [[UserData sharedInstance] saveHomeQuickEntryListWithArray:menuBtnModelArray];
    }else{
        menuBtnModelArray = [[UserData sharedInstance] getHomeQuickEntryList];
        if (!menuBtnModelArray || menuBtnModelArray.count == 0) {
            return;
        }
    }
    
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    self.menuView = [[MenuView alloc] initWithModelArray:menuBtnModelArray];
    self.menuView.delegate = self;
    self.menuView.x = 0;
    self.menuView.y = self.tableHeaderViewH;
    [self.tableHeaderView addSubview:self.menuView];
    self.tableHeaderViewH += self.menuView.height;
}

/** 个人服务展示 */
- (void)initServiceView{
    if (self.serviceView) {
        [self.serviceView removeFromSuperview];
    }
    
    ClientGlobalInfoRM *globalRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    
    if (![[UserData sharedInstance].city isEnablePersonalService] || !globalRM.wap_url_list.service_personal_entry_url.length) {
        return;
    }
    
    
    CGFloat bannerH = (SCREEN_WIDTH - 24)*(94.00/351.00);
    
    self.serviceView = [[UIView alloc] init];
    self.serviceView.frame = CGRectMake(0, self.tableHeaderViewH, SCREEN_WIDTH, bannerH + 10);
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_personal_stu_icon"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(serviceBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.serviceView addSubview:imgView];
    [self.serviceView addSubview:button];
    [self.tableHeaderView addSubview:self.serviceView];
    
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.serviceView);
        make.top.equalTo(self.serviceView).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH - 24));
        make.height.equalTo(@(bannerH));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgView);
    }];
    
    self.tableHeaderViewH += (bannerH + 10);

}

/** 兼客头条 */
- (void)importantNew{
    ClientGlobalInfoRM *globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel.stu_head_line_ad_list && globaModel.stu_head_line_ad_list.count > 0) {
        NSArray *newsModelArray = [AdModel objectArrayWithKeyValuesArray:globaModel.stu_head_line_ad_list];
        if (newsModelArray && newsModelArray.count > 0) {
            if (self.newsView) {
                [self.newsView removeFromSuperview];
            }
            self.newsView = [[NewsView alloc] initWithNewsModelArray:newsModelArray size:CGSizeMake(SCREEN_WIDTH, 36)];
            self.newsView.delegate = self;
            self.newsView.x = 0;
            self.newsView.y = self.tableHeaderViewH;
            [self.tableHeaderView addSubview:self.newsView];
            self.tableHeaderViewH += 36;
        }
    }
}

- (void)serviceBtnOnClick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_findServiceEntry block:^(UIViewController *vc) {
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
}

#pragma mark - ***** 通知业务 *****
- (void)loginSuccessNotifi{
    ELog(@"===ep loginSuccessNotifi");
    [self initUIWithData];
}

/** 更新消息铃铛 */
- (void)updateMsgNum:(NSNotification *)notification{
    NSNumber* msgCount = notification.userInfo[@"msgCount"];
    ELog(@"Jk====msgCount:%@",msgCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ClientGlobalInfoRM *globalInfoRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
        UITabBarItem *item;
        if (globalInfoRM.is_not_support_zhong_bao.integerValue != 1) {
            //tabbar红点
            item = [self.tabBarController.tabBar.items objectAtIndex:1];
        }
        
        if (msgCount.intValue <= 0) {
            item.badgeValue = nil;
        }else{
            NSString* numStr;
            if (msgCount.integerValue > 99) {
                numStr = @"99+";
            }else{
                numStr = msgCount.stringValue;
            }
            item.badgeValue = numStr;
        }
    });
}

- (void)walletNotify{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
            [self.tabBarController.tabBar showSmallBadgeOnItemIndex:3];
        }
    });
}

- (void)updateWaitTodo{
    if ([[UserData sharedInstance] isLogin] && [[UserData sharedInstance] getLoginType].intValue == WDLoginType_JianKe) {
        DLog(@"=======getJKModelWithBlock");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
                [self.tabBarController.tabBar showSmallBadgeOnItemIndex:3];    //显示小红点
            }
        });
    }
}

- (void)updatePersonServiceRedpoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]){
            [self.tabBarController.tabBar showSmallBadgeOnItemIndex:3];
        }
    });
}

- (void)clearTabbarRedPoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
    });
}

- (void)updateDataList{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_jobExpressVC) {
            [_jobExpressVC headerBeginRefreshing];
        }
    });
}

- (void)displayAlertView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [VariousAlertView showTitle:@"简历越完善，工作机会越多哦" content:nil cancel:@"完善简历" commit:nil imageView:@"alert_bg_icon" block:^(NSInteger result) {
            // 跳转
            UIViewController *viewCtrl = [MKUIHelper getTopViewController];
            if (viewCtrl.navigationController) {
                LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCtrl.navigationController pushViewController:vc animated:YES];
            }
        }];
    });
}

#pragma mark - ***** lazy ****
- (SDCycleScrollView *)cycleBannerSV{
    if (!_cycleBannerSV) {
        _cycleBannerSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        _cycleBannerSV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerSV.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleBannerSV.delegate = self;
        _cycleBannerSV.currentPageDotColor = [UIColor whiteColor];
        _cycleBannerSV.pageDotColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _cycleBannerSV.placeholderImage = [UIImage imageNamed:@"v3_public_banner"];
    }
    return _cycleBannerSV;
}

- (JSDropDownMenu *)tableSectionView{
    if (!_tableSectionView) {
        _tableSectionView = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
        _tableSectionView.indicatorColor = [UIColor XSJColor_tGrayDeepTinge];
        _tableSectionView.indicatorHightColor = MKCOLOR_RGB(0, 188, 212);
        _tableSectionView.separatorColor = MKCOLOR_RGB(233, 233, 233);
        _tableSectionView.textColor = [UIColor XSJColor_tGrayDeepTinge];
        _tableSectionView.textHightColor = MKCOLOR_RGB(0, 188, 212);
        _tableSectionView.dataSource = self.menuDataSource;
        _tableSectionView.delegate = self.menuDataSource;
        _tableSectionView.selectDelegate = self;
    }
    return _tableSectionView;
}

- (MenuDataSource *)menuDataSource{
    if (!_menuDataSource) {
        _menuDataSource = [[MenuDataSource alloc] init];
    }
    return _menuDataSource;
}

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        _grayView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = MKCOLOR_RGB(220, 220, 220);
        [self.grayView addSubview:lineView];
    }
    return _grayView;
}

- (void)applyserviceAction{
    
}

- (void)showNoDataViewWithActionType:(callBackType)actionType{
    if (self.leftTableView) {
        switch (actionType) {
            case callBackType_defaultNoMoreData:{
                self.leftTableView.tableFooterView = [self getDataView:NO];
            }
                break;
            case callBackType_removeNoMoreData:{
                self.leftTableView.tableFooterView = nil;
            }
                break;
            case callBackType_throughNoMoreData:{
                self.leftTableView.tableFooterView = [self getDataView:NO];
            }
                break;
            case callBackType_queryConditionNoMoreData:{
//                self.leftTableView.tableFooterView = [self getViewAllParttimeBtn];
                self.leftTableView.tableFooterView = nil;
            }
                
            default:
                break;
        }
    }
    
}

- (UIView *)getViewAllParttimeBtn{
    UIView *botView = [[UIView alloc] init];
    botView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84);
    botView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v317_job_list_icon"]];
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"查看全部兼职" forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(viewAllParttimeJob:) forControlEvents:UIControlEventTouchUpInside];
    
    [botView addSubview:backView];
    [backView addSubview:imgView1];
    [backView addSubview:imgView2];
    [backView addSubview:button];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botView).offset(12);
        make.bottom.equalTo(botView).offset(-12);
        make.left.equalTo(botView).offset(12);
        make.right.equalTo(botView).offset(-12);
    }];
    
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).offset(16);
    }];
    
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).offset(-16);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    
    return botView;
}

- (UIView *)getDataView:(BOOL)isShowThrough{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];

    
    if (isShowThrough) {
        
        UIView *noDataView = [UIHelper noDataViewWithTitle:@"暂无推荐的热门岗位"];
        
        noDataView.y = 30;
        [tableFooterView addSubview:noDataView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看全部兼职" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor XSJColor_base]];
        [button setCornerValue:2.0f];
        [button addTarget:self action:@selector(viewAllParttimeJob:) forControlEvents:UIControlEventTouchUpInside];
        [tableFooterView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableFooterView).offset(50);
            make.bottom.equalTo(tableFooterView).offset(-20);
            make.right.equalTo(tableFooterView).offset(-50);
            make.height.equalTo(@40);
        }];
    }else{
        UIView *noDataView = [UIHelper noDataViewWithTitle:@"当前没有招聘的岗位"];
        
        noDataView.y = 30;
        [tableFooterView addSubview:noDataView];
    }
    
    return tableFooterView;
}

- (void)viewAllParttimeJob:(UIButton *)sender{
    ParttimeJobList_VC *viewCtrl = [[ParttimeJobList_VC alloc] init];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DLog(@"jiankeHome dealloc");
    [WDNotificationCenter removeObserver:self];
    if (_adArrayData) {
        _adArrayData = nil;
    }
    _localBtn = nil;
    _leftTableView = nil;
    _tableHeaderView = nil;
    _cycleBannerSV = nil;
    _menuView = nil;
    _newsView = nil;
    _tableSectionView = nil;
    _menuDataSource = nil;
    _grayView = nil;
    _jobExpressVC = nil;
    _nowCity = nil;
    _serviceView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
