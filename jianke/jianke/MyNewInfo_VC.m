//
//  MyNewInfo_VC.m
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyNewInfo_VC.h"
#import "IdentityCardAuth_VC.h"
#import "JobCollection_VC.h"
#import "WebView_VC.h"
#import "MySubscribleList_VC.h"
#import "Login_VC.h"
#import "LookupResume_VC.h"
#import "InterestJob_VC.h"
#import "MoneyBag_VC.h"
#import "SettingController.h"
#import "FeedBackController.h"
#import "WeChatBinding_VC.h"

#import "MyNewInfoLookMe_VCViewController.h"
#import "MyNewInfoCell_Resume.h"
#import "MyInfoCell_new.h"

#import "CityTool.h"
#import "MainTabBarCtlMgr.h"
#import "XSpotLight.h"

@interface MyNewInfo_VC () <MyNewInfoCell_NameDelegate, MyNewInfoCell_ResumeDelegate,XSpotLightDelegate>{
    BOOL _isBindingWX;
    CGRect _rc1,_rc2,_rc3;
}

@property (nonatomic, strong) JKModel *jkInfo;

@end

@implementation MyNewInfo_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.title = @"我的";
    
    _isBindingWX = NO;
    
    [self addNotification];
    [self setupViews];
    [self loadDatas];
    
    WEAKSELF
    CityModel *ctModel = [[UserData sharedInstance] city];
    [CityTool getCityModelWithCityId:ctModel.id block:^(CityModel* obj) {
        if (obj) {
            [[UserData sharedInstance] setCity:obj];
            [weakSelf loadDatas];
            [weakSelf initUserInfo];
        }
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isLogin]) {
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getAccountThirdPlatBindInfo" andContent:nil];
        WEAKSELF
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            NSNumber* isBinding = response.content[@"is_bind_wechat_public"];
            _isBindingWX = isBinding.integerValue == 1;
            [weakSelf.tableView reloadData];
            
            //判断是否第一次登录
            if (![[UserData sharedInstance]getIsHasOpen]) {
                [[UserData sharedInstance] setIsHasOpen:YES];
                [self initLightView];
                
            }
        }];
    }
    if ([UserData sharedInstance].isRefreshTableViewWithMyInfo) {
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = NO;
        _jkInfo = [[UserData sharedInstance] getJkModelFromHave];
        [self.tableView reloadData];
    }
    
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [[UserData sharedInstance]setFirstLoginStatusToNO];
}
- (void)addNotification{
    //登录成功通知
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccessNotifi) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateMoneyBagRedPoint) name:IMPushWalletNotification object:nil];
    /** 查看简历/录用/完工/ */
    [WDNotificationCenter addObserver:self selector:@selector(updateData) name:IMPushJKWaitTodoNotification object:nil];
    //个人服务邀约通知
    [WDNotificationCenter addObserver:self selector:@selector(updatePersonServiceRedpoint) name:IMPushGetPersonaServiceJobNotification object:nil];
    //个人服务小红点删除通知 - 点击个人服务发出通知
    [WDNotificationCenter addObserver:self selector:@selector(clearPersonServiceRedpoint) name:ClearPersonaServiceJobNotification object:nil];
    //代办小红点删除通知  -  代办发出通知
    [WDNotificationCenter addObserver:self selector:@selector(clearMyApplyRedpoint) name:clearMyApplyRedPointNotification object:nil];
    //更新简历通知
    [WDNotificationCenter addObserver:self selector:@selector(updateMyInfo) name:WDNotifi_updateMyInfo object:nil];
    //个人服务审核通过/被下架
    [WDNotificationCenter addObserver:self selector:@selector(showPersonService) name:UpdateIsPersonaService object:nil];
    //删除钱袋子小红点
    [WDNotificationCenter addObserver:self selector:@selector(clearMyMoneyBagRedpoint) name:clearMyMoneyBagNotification object:nil];
}

- (void)updatePersonServiceRedpoint{
    [self reloadCollection];
}

- (void)updateData{
    [self reloadCollection];
}

- (void)clearPersonServiceRedpoint{
    [self reloadCollection];
}

- (void)clearMyApplyRedpoint{
    [self reloadCollection];
}

- (void)clearMyMoneyBagRedpoint{
    [self reloadCollection];
}

- (void)showPersonService{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
    });
}

- (void)reloadCollection{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)setupViews{
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"MyNewInfoCell_Name") forCellReuseIdentifier:@"MyNewInfoCell_Name"];
    [self.tableView registerNib:nib(@"MyNewInfoCell_Resume") forCellReuseIdentifier:@"MyNewInfoCell_Resume"];
    [self.tableView registerNib:nib(@"MyInfoCell_new") forCellReuseIdentifier:@"MyInfoCell_new"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v320_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
    
   
    
    
}

- (void)loadDatas{
    [self.dataSource removeAllObjects];
    
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:@(MyInfoJKCellType_Name)];
    [array1 addObject:@(MyInfoJKCellType_MyNewInfo)];
    [array1 addObject:@(MyInfoJKCellType_MoneyBag)];
    [array1 addObject:@(MyInfoJKCellType_JobCollection)];
    [array1 addObject:@(MyInfoJKCellType_MySubscription)];
    [array1 addObject:@(MyInfoJKCellType_JiankeWeal)];
    [array1 addObject:@(MyInfoJKCellType_MyPersonalService)];
    
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:@(MyInfoJKCellType_Guide)];
    [array2 addObject:@(MyInfoJKCellType_Suggest)];
    [array2 addObject:@(MyInfoJKCellType_BindWechat)];
    [array2 addObject:@(MyInfoJKCellType_SwitchJKEP)];
    
    [self.dataSource addObject:array1];
    [self.dataSource addObject:array2];
    
    [self.tableView reloadData];
}
#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoJKCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case MyInfoJKCellType_Name:{
            MyNewInfoCell_Name *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewInfoCell_Name" forIndexPath:indexPath];
            cell.delegate = self;
            cell.jkModel = _jkInfo;
            return cell;
        }
        case MyInfoJKCellType_MyNewInfo:{
            MyNewInfoCell_Resume *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewInfoCell_Resume" forIndexPath:indexPath];
            
             UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
            _rc1 = [cell.btn2 convertRect:cell.btn2.frame toView:window];
            _rc2 = [cell.btnResume convertRect:cell.btnResume.frame toView:window];
            _rc3 = [cell.btnRefresh convertRect:cell.btnRefresh.frame toView:window];
            
            
            cell.delegate = self;
            [cell setModel:_jkInfo];
    
            return cell;
        }
        case MyInfoJKCellType_MoneyBag:
        case MyInfoJKCellType_JobCollection:
        case MyInfoJKCellType_MySubscription:
        case MyInfoJKCellType_JiankeWeal:
        case MyInfoJKCellType_MyPersonalService:
        case MyInfoJKCellType_Guide:
        case MyInfoJKCellType_Suggest:
        case MyInfoJKCellType_BindWechat:
        case MyInfoJKCellType_SwitchJKEP:{
            MyInfoCell_new *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell_new" forIndexPath:indexPath];
            [cell setCellType:cellType];
            cell.moneyNum.text =[NSString stringWithFormat:@"%0.2f",self.jkInfo.acct_amount.floatValue*0.01] ;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoJKCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case MyInfoJKCellType_Name:{
            return 92.0f;
        }
        case MyInfoJKCellType_MyNewInfo:{
            if ([[UserData sharedInstance] isLogin]) {
                return 179.0f;
            }else{
                return 179.0f + 28.0f;
            }
        }
            
        case MyInfoJKCellType_JobCollection:
        case MyInfoJKCellType_MySubscription:
        case MyInfoJKCellType_JiankeWeal:
        case MyInfoJKCellType_MyPersonalService:
        case MyInfoJKCellType_Guide:
        case MyInfoJKCellType_Suggest:
        case MyInfoJKCellType_BindWechat:
        case MyInfoJKCellType_SwitchJKEP:
            return 56.0f;
        default:
            break;
    }
    return 56.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyInfoJKCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case MyInfoJKCellType_Name:{
            if ([[UserData sharedInstance] isLogin]) {
                LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case MyInfoJKCellType_JobCollection:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    JobCollection_VC *viewCtrl = [[JobCollection_VC alloc] init];
                    viewCtrl.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];
        }
            break;
        case MyInfoJKCellType_MoneyBag:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    MoneyBag_VC* vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];

        }
            break;
        case MyInfoJKCellType_MySubscription:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    MySubscribleList_VC *viewCtrl = [[MySubscribleList_VC alloc] init];
                    viewCtrl.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];
        }
            break;
        case MyInfoJKCellType_JiankeWeal:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                        if (globalModel && globalModel.wap_url_list.jianke_welfare_salary_url) {
                            WebView_VC *vc = [[WebView_VC alloc] init];
                            vc.url = globalModel.wap_url_list.jianke_welfare_salary_url;
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }else{
                            [UIHelper toast:@"该服务暂时无法使用"];
                        }
                    }];
                }
            }];
        }
            break;
        case MyInfoJKCellType_MyPersonalService:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_servicePersonalCenterEntryUrl block:^(UIViewController *vc) {
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                }
            }];
        }
            break;
        case MyInfoJKCellType_Guide:{
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_helpCenter];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MyInfoJKCellType_Suggest:{
            [TalkingData trackEvent:@"雇主个人中心_吐槽冲我来"];
            FeedBackController *vc = [[FeedBackController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MyInfoJKCellType_BindWechat:{
            [[UserData sharedInstance] userIsLogin:^(id result) {
               [self bindWeiXin];
            }];
        }
            break;
        case MyInfoJKCellType_SwitchJKEP:{
            if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"JKHireapp://"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"JKHireapp://"]];
                }else{
                    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                        if (globalModel && globalModel.wap_url_list.guide_youpin_intro_download_url) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[globalModel.wap_url_list.guide_youpin_intro_download_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
                        }
                    }];
                }
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"JKHireapp://"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
                    if (!success) {
                        [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                            if (globalModel && globalModel.wap_url_list.guide_youpin_intro_download_url) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[globalModel.wap_url_list.guide_youpin_intro_download_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
                            }
                        }];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor XSJColor_clipLineGray];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 0.7f;
}

#pragma mark - 通知处理

- (void)loginSuccessNotifi{
    [self updateUserModel];
}

- (void)updateMyInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
    });
}

- (void)updateUserModel{
    if ([[UserData sharedInstance] isLogin]) {
        WEAKSELF
        [[UserData sharedInstance] getJKModelWithBlock:^(JKModel* obj) {
            _jkInfo = obj;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadDatas];
            });
        }];
    }
}

- (void)updateMoneyBagRedPoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUserModel];
    });
}

#pragma mark - 其他

- (void)initUserInfo{
    if ([[UserData sharedInstance] isLogin]) {
        _jkInfo = [[UserData sharedInstance] getJkModelFromHave];
        if (_jkInfo) {
            [self loadDatas];
        }else{
            [self updateUserModel];
        }
    }
}

#pragma mark - 聚光灯
- (void)initLightView{
    XSpotLight *lightView = [[XSpotLight alloc]init];
    lightView.messageArray = @[@"<(￣︶￣)> 我这么好看~ \n\n 看过您的雇主都在这里！从这里进入查看雇主的信息，将帮助您更好的了解他们。\n\n → → →",
                               @"✧⁺⸜(●˙▾˙●)⸝⁺✧ 完整的简历更迷人 \n\n 完善的简历将极大的提高您被雇主看到和录用的概率，毕竟谁都喜欢好看且有趣的人。\n\n → → →",
                               @" (ง •̀_•́)ง 让更多雇主看到我 \n\n 频繁“刷新”简历使您长时间排在所有的雇主人才库的前列，这有极大可能使您被争相录用。\n\n 知道啦 →"];
    
    CGFloat lightView_x1,lightView_x2,lightView_x3,lightView_y1,lightView_y2,lightView_y3,lightView_weight,lightView_hight;
    lightView_x1 = _rc1.origin.x + (_rc1.size.width/2);
    lightView_x2 = _rc2.origin.x + 48;
    lightView_x3 = SCREEN_WIDTH-48;
    
    lightView_y1 = _rc1.origin.y + (_rc1.size.height/2);
    lightView_y2 = _rc2.origin.y + 30;
    lightView_y3 = _rc3.origin.y ;
    lightView_weight = 60;
    lightView_hight = 60;
    
    
    lightView.rectArray = @[[NSValue valueWithCGRect:CGRectMake(lightView_x1, lightView_y1, lightView_weight, lightView_hight)],
                            [NSValue valueWithCGRect:CGRectMake(lightView_x2, lightView_y2, lightView_weight, lightView_hight)],
                            [NSValue valueWithCGRect:CGRectMake(lightView_x3, lightView_y3, lightView_weight, lightView_hight)]];
    
//    lightView.delegate = self;
    
    [self presentViewController:lightView animated:NO completion:nil];
    
}
- (void)XSportLightClicked:(NSInteger)index{
    NSLog(@"点击%ld",(long)index);

}

#pragma mark - myNewInfoCellName delegate

- (void)myNewInfoCellName:(MyNewInfoCell_Name *)cell btnActionType:(btnActionType)actionType{
    switch (actionType) {
        case btnActionType_auth:{
            IdentityCardAuth_VC *vc = [[IdentityCardAuth_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)MyNewInfoCellResume:(MyNewInfoCell_Resume *)cell actionType:(ResumeBtnType)actionType{
    switch (actionType) {
        case ResumeBtnType_Login:{
            Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
            loginVC.isShowGuide = YES;
            MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case ResumeBtnType_MyProfile:{
            if ([[UserData sharedInstance] isLogin]) {
                LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case ResumeBtnType_MyJoin:{
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    [[MainTabBarCtlMgr sharedInstance] showMyApplyCtrlOnCtrl:self];
                }
            }];
        }
            break;
        case ResumeBtnType_MoneyBag:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    
                    MyNewInfoLookMe_VCViewController *vc = [[MyNewInfoLookMe_VCViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }
            }];
        }
            break;
        case ResumeBtnType_JobTrends:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    InterestJob_VC *vc = [[InterestJob_VC alloc] init];
                    vc.block = ^(id result){
                        [weakSelf updateUserModel];
                        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;
        case ResumeBtnType_Refresh:{
            [[UserData sharedInstance] refreshResumeWithblock:^(ResponseInfo *response) {
                [UIHelper toast:response.errMsg];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)rightItemOnClick{
    SettingController *vc = [[SettingController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bindWeiXin{
    ELog(@"======绑定微信 ");
    WEAKSELF
    if (_isBindingWX) {
        WEAKSELF
        [UIHelper showConfirmMsg:@"解除绑定后将无法继续接收微信公众号的消息提醒哦！确定要解除账户与微信的关联吗？" title:@"微信解绑" okButton:@"解除绑定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf unBindWeiXin];
            }
        }];
    }else{
        [[UserData sharedInstance] userIsLogin:^(id obj) {
            if (obj) {
                WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }
}

- (void)unBindWeiXin{
    NSString *content = @"\"type\":\"2\"";
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_unBandingWechatUser" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo * response) {
        if (response && response.success) {
            [UIHelper toast:@"解绑成功"];
            weakSelf.jkInfo = [[UserData sharedInstance] getJkModelFromHave];
            weakSelf.jkInfo.bind_wechat_public_num_status = @(0);
            [[UserData sharedInstance] saveJKModel:weakSelf.jkInfo];
            _isBindingWX = NO;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
