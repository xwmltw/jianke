    //
//  PersonServiceOrder_VC.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceOrder_VC.h"
#import "PersonServiceOrderCell.h"
#import "PersonServiceDetail_VC.h"

#import "UIViewController+XZExtension.h"

#import "PersonServiceModel.h"

@interface PersonServiceOrder_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) NSMutableArray *currentArr;   /*!< 正在发布中需求列表 */
@property (nonatomic, strong) NSMutableArray *historyArr;   /*!< 历史发布的需求列表 */
@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic, weak) UIButton *historyButton;

@end

@implementation PersonServiceOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //个人服务邀约通知
    [WDNotificationCenter addObserver:self selector:@selector(updatePersonServiceRedpoint) name:IMPushGetPersonaServiceJobNotification object:nil];
    self.queryParam = [[QueryParamModel alloc] init];
    self.currentArr = [NSMutableArray array];
    self.historyArr = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithObjects:_currentArr, _historyArr, nil];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self.tableView registerNib:nib(@"PersonServiceOrderCell") forCellReuseIdentifier:@"PersonServiceOrderCell"];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
    [self initWithNoDataViewWithStr:@"您当前没有个人通告" onView:self.tableView];
    self.sectionFooterView.hidden = NO;
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserData sharedInstance].isrefreshServiceOrder) {
        [UserData sharedInstance].isrefreshServiceOrder = NO;
        [self headerRefresh];
    }
    [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] stuQueryServicePersonalApplyJobListWithParam:self.queryParam inHistory:@0 block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [PersonServiceModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_apply_list"]];
            if (array.count) {
                [self setHistoryBtnEnable:YES];
                [weakSelf.currentArr removeAllObjects];
                [weakSelf.currentArr addObjectsFromArray:array];
                [weakSelf.historyArr removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf judgeIsNoData];
            }else{
                [weakSelf footerRefresh];
            }
            [weakSelf setHistoryBtnWithNumber:[response.content objectForKey:@"history_service_personal_apply_list_count"]];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] stuQueryServicePersonalApplyJobListWithParam:self.queryParam inHistory:@1 block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [PersonServiceModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_apply_list"]];
            if (array.count) {
                if (weakSelf.queryParam.page_num.integerValue == 1) {
                    [weakSelf.historyArr removeAllObjects];
                }
                [weakSelf.historyArr addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
            [weakSelf setHistoryBtnEnable:NO];
        }
        [weakSelf judgeIsNoData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.currentArr.count + self.historyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServiceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceOrderCell" forIndexPath:indexPath];
    PersonServiceModel *model;
    if (indexPath.section >= self.currentArr.count) {
        model = [self.historyArr objectAtIndex:indexPath.section - self.currentArr.count];
    }else{
        model = [self.currentArr objectAtIndex:indexPath.section];
    }
    cell.personServiceModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServiceModel *model;
    if (indexPath.section >= self.currentArr.count) {
        model = [self.historyArr objectAtIndex:indexPath.section - self.currentArr.count];
    }else{
        model = [self.currentArr objectAtIndex:indexPath.section];
    }
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && (!self.currentArr.count) && self.historyArr.count) {
        return 42.0f;
    }
    if (section == 0) {
        return 10.0f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((self.currentArr.count - section) == 1) {
        return 42.0f;
    }
    
    return 17.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServiceModel *model;
    if (indexPath.section >= self.currentArr.count) {
        model = [self.historyArr objectAtIndex:indexPath.section - self.currentArr.count];
    }else{
        model = [self.currentArr objectAtIndex:indexPath.section];
    }
    PersonServiceDetail_VC *viewCtrl = [[PersonServiceDetail_VC alloc] init];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    viewCtrl.service_personal_job_id = model.service_personal_job_id;
    viewCtrl.service_personal_job_apply_id = model.service_personal_job_apply_id;
    WEAKSELF
    viewCtrl.block = ^(NSNumber *applyStatus){
        model.apply_status = applyStatus;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}   

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 && (!self.currentArr.count) && self.historyArr.count) {
        return self.sectionFooterView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (((self.currentArr.count - section) == 1) && (self.currentArr.count || self.historyArr.count)) {
        return self.sectionFooterView;
    }
    return nil;
}

#pragma mark - PersonServiceOrderCellDelegate
//
//- (void)btnOnClick:(ActionType)actionType withModel:(PersonServiceModel *)model{
//    if (actionType == ActionType_Apply) {
//        WEAKSELF
//        [MKAlertView alertWithTitle:@"提示" message:@"是否报名该邀约?" cancelButtonTitle:@"取消" confirmButtonTitle:@"报名" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [weakSelf sendRequest:actionType withModel:model];
//            }
//        }];
//    }else if (actionType == ActionType_Refuse){
//        WEAKSELF
//        [MKAlertView alertWithTitle:@"提示" message:@"是否拒绝该邀约?" cancelButtonTitle:@"取消" confirmButtonTitle:@"拒绝" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [weakSelf sendRequest:actionType withModel:model];
//            }
//        }];
//    }
//}
//
//- (void)sendRequest:(ActionType)actionType withModel:(PersonServiceModel *)model{
//    
//    WEAKSELF
//    [[XSJRequestHelper sharedInstance] stuDealWithServicePersonalJobApplyWithOptType:@(actionType) applyId:model.service_personal_job_apply_id block:^(id result) {
//        if (result) {
//            if (actionType == ActionType_Apply) {
//                [UIHelper toast:@"已报名，待雇主确认"];
//                model.apply_status = @2;
//            }else if (actionType == ActionType_Refuse){
//                model.apply_status = @3;
//            }
//            [weakSelf.tableView reloadData];
//        }
//    }];
//}

- (UIView *)sectionFooterView{
    if (!_sectionFooterView) {
        UIView *view = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitle:@"历史记录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setCornerValue:2.0f];
        [button addTarget:self action:@selector(historyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.greaterThanOrEqualTo(@120);
            make.height.equalTo(@30);
        }];
        _historyButton = button;
        _sectionFooterView = view;
        [self setHistoryBtnEnable:YES];
    }
    return _sectionFooterView;
}

#pragma mark - 自定义方法

- (void)judgeIsNoData{
    if (!(self.currentArr.count || self.historyArr.count)) {
        self.viewWithNoData.hidden = NO;
    }else{
        self.viewWithNoData.hidden = YES;
    }
}

- (void)setHistoryBtnEnable:(BOOL)enable{
    self.historyButton.enabled = enable;
    if (enable) {
        [self.historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.historyButton setImage:[UIImage imageNamed:@"v3_public_history_white"] forState:UIControlStateNormal];
        self.historyButton.backgroundColor = [UIColor XSJColor_tGrayHistoyTransparent];
    }else{
        [self.historyButton setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateNormal];
        [self.historyButton setImage:[UIImage imageNamed:@"v3_public_history"] forState:UIControlStateNormal];
        self.historyButton.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHistoryBtnWithNumber:(NSNumber *)titleNum{
    [self.historyButton setTitle:[NSString stringWithFormat:@"历史记录(%@)", titleNum] forState:UIControlStateNormal];
}

- (void)historyBtnOnClick:(UIButton *)sender{
    self.queryParam.page_num = @1;
    [self.tableView.footer beginRefreshing];
}

- (void)updatePersonServiceRedpoint{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self headerRefresh];
    });
    
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
