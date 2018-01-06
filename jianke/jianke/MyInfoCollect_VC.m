//
//  MyInfoCollect_VC.m
//  jianke
//
//  Created by fire on 16/11/1.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCollect_VC.h"
#import "Login_VC.h"
#import "IdentityCardAuth_VC.h"
#import "WebView_VC.h"
#import "JobCollection_VC.h"
#import "InterestJob_VC.h"
#import "SettingController.h"
#import "LookupResume_VC.h"
#import "MoneyBag_VC.h"
#import "MySubscribleList_VC.h"
#import "RegisterGuide_VC.h"
#import "MainTabBarCtlMgr.h"

#import "MyInfoCollect_cell0.h"
#import "MyInfoCollect_cell1.h"
#import "MyInfoCollect_Cell2.h"
#import "MyInfoCollect_cell3.h"
#import "ClipLineView.h"

#import "CityTool.h"

@interface MyInfoCollect_VC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MyInfoCollect_cell0Delegate>

@property (nonatomic, weak) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JKModel *jkInfo;

@end

@implementation MyInfoCollect_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.title = @"我";
    
    self.dataSource = [NSMutableArray array];
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
        [self.collectView reloadData];
    });
}

- (void)setupViews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor XSJColor_newWhite];
    collectView.delegate = self;
    collectView.dataSource = self;
    self.collectView = collectView;
    [self.view addSubview:collectView];
    
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self registerCell];
}

- (void)registerCell{
    [self.collectView registerNib:nib(@"MyInfoCollect_cell0") forCellWithReuseIdentifier:@"MyInfoCollect_cell0"];
    [self.collectView registerNib:nib(@"MyInfoCollect_cell1") forCellWithReuseIdentifier:@"MyInfoCollect_cell1"];
    [self.collectView registerNib:nib(@"MyInfoCollect_Cell2") forCellWithReuseIdentifier:@"MyInfoCollect_Cell2"];
    [self.collectView registerClass:[MyInfoCollect_cell3 class] forCellWithReuseIdentifier:@"MyInfoCollect_cell3"];
}

- (void)loadDatas{
    [self.dataSource removeAllObjects];
    
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:@(MyInfoJKCellType_Name)];
    
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:@(MyInfoJKCellType_MoneyBag)];
    
    NSMutableArray *array3 = [NSMutableArray array];
    [array3 addObject:@(MyInfoJKCellType_waitToDo)];
    [array3 addObject:@(MyInfoJKCellType_JobCollection)];
    [array3 addObject:@(MyInfoJKCellType_JobApplyTrend)];
    

    [array3 addObject:@(MyInfoJKCellType_MyPersonalService)];

    [array3 addObject:@(MyInfoJKCellType_PersonalService)];
    [array3 addObject:@(MyInfoJKCellType_MySubscription)];;
    
    NSMutableArray *array4 = [NSMutableArray array];
    [array4 addObject:@(MyInfoJKCellType_JiankeWeal)];
    [array4 addObject:@(MyInfoJKCellType_Salary)];
    [array4 addObject:@(MyInfoJKCellType_Guide)];
    [array4 addObject:@(MyInfoJKCellType_Setting)];
    
    NSMutableArray *array5 = [NSMutableArray array];
    [array5 addObject:@(MyInfoJKCellType_SwitchJKEP)];
    
    [self.dataSource addObject:array1];
    [self.dataSource addObject:array2];
    [self.dataSource addObject:array3];
    [self.dataSource addObject:array4];
    [self.dataSource addObject:array5];
    
    [self.collectView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource objectAtIndex:section];
    return array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoJKCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.item] integerValue];
    switch (cellType) {
        case MyInfoJKCellType_PersonalService:
        case MyInfoJKCellType_MySubscription:
        case MyInfoJKCellType_Salary:
        case MyInfoJKCellType_JobCollection:
        case MyInfoJKCellType_JobApplyTrend:
        case MyInfoJKCellType_Guide:
        case MyInfoJKCellType_Setting:
        case MyInfoJKCellType_JiankeWeal:
        case MyInfoJKCellType_waitToDo:
        case MyInfoJKCellType_MyPersonalService:{
            MyInfoCollect_Cell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyInfoCollect_Cell2" forIndexPath:indexPath];
            cell.cellType = cellType;
            return cell;
        }
        case MyInfoJKCellType_Name:{
            MyInfoCollect_cell0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyInfoCollect_cell0" forIndexPath:indexPath];
            cell.delegate = self;
            cell.jkModel = _jkInfo;
            return cell;
        }
        case MyInfoJKCellType_MoneyBag:{
            MyInfoCollect_cell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyInfoCollect_cell1" forIndexPath:indexPath];
            cell.jkModel = _jkInfo;
            return cell;
        }
        case MyInfoJKCellType_oldSalary:
        case MyInfoJKCellType_SwitchJKEP:{
            MyInfoCollect_cell3 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyInfoCollect_cell3" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor XSJColor_newWhite];
            if (cellType == MyInfoJKCellType_oldSalary) {
                cell.labTitle.text = @"    原菠萝袋预支工资还款入口";
                cell.labTitle.textAlignment = NSTextAlignmentLeft;
                cell.imageView.hidden = NO;
                cell.imageView.image = [UIImage imageNamed:@"job_icon_push"];
            }else if (cellType == MyInfoJKCellType_SwitchJKEP){
                cell.labTitle.text = @"切换为雇主 >";
                cell.labTitle.textAlignment = NSTextAlignmentCenter;
                cell.imageView.hidden = YES;
            }
            return cell;
        }
        default:
            break;
    }
    return nil;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoJKCellType type = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.item] integerValue];
    switch (type) {
        case MyInfoJKCellType_PersonalService:
        case MyInfoJKCellType_MySubscription:
        case MyInfoJKCellType_Salary:
        case MyInfoJKCellType_JobCollection:
        case MyInfoJKCellType_JobApplyTrend:
        case MyInfoJKCellType_Guide:
        case MyInfoJKCellType_Setting:
        case MyInfoJKCellType_JiankeWeal:
        case MyInfoJKCellType_waitToDo:
        case MyInfoJKCellType_MyPersonalService:{
            CGFloat itemWidth = (SCREEN_WIDTH - 8) / 3;
            return CGSizeMake(itemWidth, 126.0f);
        }
        case MyInfoJKCellType_Name:{
            return CGSizeMake(SCREEN_WIDTH, 93.0f);
        }
        case MyInfoJKCellType_oldSalary:
        case MyInfoJKCellType_SwitchJKEP:
        case MyInfoJKCellType_MoneyBag:{
            return CGSizeMake(SCREEN_WIDTH, 48.0f);
        }
        default:
            break;
    }
    return CGSizeMake(SCREEN_WIDTH, 48.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 0.7;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInfoJKCellType cellType = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.item] integerValue];
    switch (cellType) {
        case MyInfoJKCellType_PersonalService:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                        if (globalModel && globalModel.service_personal_url) {
                            WebView_VC *vc = [[WebView_VC alloc] init];
                            vc.url = globalModel.service_personal_url;
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                    }];
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
        case MyInfoJKCellType_Salary:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                        if (globalModel && globalModel.wap_url_list.fenqile_advance_salary_url) {
                            WebView_VC *vc = [[WebView_VC alloc] init];
                            NSString *urlStr;
                            NSRange range = [globalModel.wap_url_list.fenqile_advance_salary_url rangeOfString:@"?"];
                            if (range.location == NSNotFound){
                                urlStr = [NSString stringWithFormat:@"%@?loginCode=%@",globalModel.wap_url_list.fenqile_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@&loginCode=%@",globalModel.wap_url_list.fenqile_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                            };
                            vc.url = urlStr;
                            vc.isFenQiLe = YES;
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }else{
                            [UIHelper toast:@"暂时无法使用该服务"];
                        }
                    }];
                }
            }];
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
        case MyInfoJKCellType_JobApplyTrend:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    InterestJob_VC *vc = [[InterestJob_VC alloc] init];
                    vc.block = ^(id result){
                        [weakSelf updateUserModel];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
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
        case MyInfoJKCellType_Setting:{
            SettingController *vc = [[SettingController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MyInfoJKCellType_Name:{
            if ([[UserData sharedInstance] isLogin]) {
                LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
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
        case MyInfoJKCellType_oldSalary:{
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                        if (globalModel && globalModel.borrowday_advance_salary_url) {
                            WebView_VC *vc = [[WebView_VC alloc] init];
                            NSString *urlStr;
                            NSRange range = [globalModel.borrowday_advance_salary_url rangeOfString:@"?"];
                            if (range.location == NSNotFound){
                                urlStr = [NSString stringWithFormat:@"%@?loginCode=%@",globalModel.borrowday_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@&loginCode=%@",globalModel.borrowday_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                            };
                            vc.url = urlStr;
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                    }];
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
        case MyInfoJKCellType_waitToDo:{
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    [[MainTabBarCtlMgr sharedInstance] showMyApplyCtrlOnCtrl:self];
                }
            }];
        }
            break;
        case MyInfoJKCellType_MyPersonalService:{
            [[UserData sharedInstance] userIsLogin:^(id result) {
                if (result) {
                    [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
                    if (![[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
                        [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
                    }
                    [self.collectView reloadData];
                    WEAKSELF
                    [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_queryMyPersonalApplyJobList block:^(UIViewController *vc) {
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 20);
}

#pragma mark - MyInfoCollect_cell0Delegate

- (void)MyInfoCollectCell:(MyInfoCollect_cell0 *)cell actionType:(btnActionType)actionType{
    switch (actionType) {
        case btnActionType_login:{
            Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
            loginVC.isShowGuide = YES;
            MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case btnActionType_register:{
            Login_VC *loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
            loginVC.isToRegister = YES;
            loginVC.isShowGuide = YES;
            MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
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
