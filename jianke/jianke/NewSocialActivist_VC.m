//
//  NewSocialActivist_VC.m
//  jianke
//
//  Created by fire on 16/8/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NewSocialActivist_VC.h"
#import "NewSocialActivistCell.h"
#import "XHPopMenu.h"
#import "SociaAcitvistModel.h"
#import "SalaryModel.h"
#import "JKDetailController.h"
#import "TopicJobList_VC.h"
#import "WebView_VC.h"

@interface NewSocialActivist_VC ()

@property (nonatomic, strong) NSMutableArray *historicArr;
@property (nonatomic, strong) NSMutableArray *currectArr;
@property (nonatomic, strong) XHPopMenu *popMenu;
@property (nonatomic, strong) QueryParamModel *queryParam;

@property (nonatomic, strong) SocialActivistTaskListModel *responseModel;

//sectionHeaderView
@property (nonatomic, strong) UIView *historiyHeaderView;
@property (nonatomic, weak) UIButton *historyBtn;
@property (nonatomic, strong) UIView *currentHeaderView;
@property (nonatomic, weak) UILabel *label;

@end

@implementation NewSocialActivist_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我是人脉王";
    [self setData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)setData{
    self.historicArr = [NSMutableArray array];
    self.currectArr = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithObjects:self.currectArr, self.historicArr, nil];
    self.queryParam = [[QueryParamModel alloc] init];
}

- (void)initUI{
   [self setHeaderView];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"NewSocialActivistCell") forCellReuseIdentifier:@"NewSocialActivistCell"];
    [self initWithNoDataViewWithStr:@"您还没有任何推广记录，快去推广岗位吧！" labColor:nil imgName:@"v3_public_nobill" button:@"去推广" onView:self.view];
}

#pragma mark - 网络

- (void)headerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getSocialActivistTaskList:@"0" queryParam:nil block:^(SocialActivistTaskListModel *result) {
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            weakSelf.responseModel = result;
            [weakSelf setNavItem];
            self.label.text = [NSString stringWithFormat:@"累计获得佣金%.2f元",result.all_receive_reward.floatValue * 0.01];
            [self.historyBtn setTitle:[NSString stringWithFormat:@"历史记录(%@)",result.in_history_task_list_count] forState:UIControlStateNormal];
            if (result.task_list && result.task_list.count) {
                weakSelf.viewWithNoData.hidden = YES;
                [weakSelf.currectArr removeAllObjects];
                [weakSelf.currectArr addObjectsFromArray:result.task_list];
                [weakSelf.tableView reloadData];
                return;
            }
            [weakSelf footerRefresh];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getSocialActivistTaskList:@"1" queryParam:self.queryParam block:^(SocialActivistTaskListModel *result) {
        [weakSelf.tableView.footer endRefreshing];
        if (result) {
            [weakSelf updateBtnStatus:NO];
            if (result.task_list && result.task_list.count) {
                [weakSelf.historicArr addObjectsFromArray:result.task_list];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
                return;
            }
            [weakSelf judgeNodataStatus];
        }
    }];

}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = [self.dataSource objectAtIndex:section];
    return array ? array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NewSocialActivistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewSocialActivistCell" forIndexPath:indexPath];
        SociaAcitvistModel *model = [self.currectArr objectAtIndex:indexPath.row];
        [cell setData:model];
        return cell;
    }else if (indexPath.section == 1){
        static NSString *identifier = @"UItabelviewcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.textColor = [UIColor XSJColor_tBlackTinge];
            cell.detailTextLabel.textColor = [UIColor XSJColor_tGrayTinge];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        SociaAcitvistModel *model = [self.historicArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.job_title;
        if (model.social_activist_reward_unit.integerValue == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f/元/人",model.social_activist_reward.floatValue * 0.01];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f/元/人/天",model.social_activist_reward.floatValue * 0.01];
        }
        return cell;
    }
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 205.0f;
    }else if (indexPath.section == 1){
        return 55.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.currectArr.count) {
        return self.currentHeaderView;
    }else if (section == 1 && (self.currectArr.count || self.historicArr.count)){
        return self.historiyHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.currectArr.count) {
        return 48;
    }else if (section == 1){
        return 46;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SociaAcitvistModel *model = nil;
    if (indexPath.section == 0) {
        model = [self.currectArr objectAtIndex:indexPath.row];
    }else if (indexPath.section == 1){
        model = [self.historicArr objectAtIndex:indexPath.row];
    }
    JKDetailController *viewCtrl = [[JKDetailController alloc] init];
    viewCtrl.jobId = model.job_id;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 其他

- (void)setHeaderView{
    _historiyHeaderView = [[UIView alloc] init];
    _historiyHeaderView.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithTitle:@"历史记录" bgColor:[UIColor XSJColor_tGrayMiddle] image:@"v3_public_history_white" target:self sector:@selector(getHistoriyData)];
    [button setTitleColor:[UIColor XSJColor_tGrayTinge] forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:@"v3_public_history"] forState:UIControlStateDisabled];
    [button setCornerValue:3.0f];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    self.historyBtn = button;
    [_historiyHeaderView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_historiyHeaderView);
        make.width.greaterThanOrEqualTo(@120);
        make.height.equalTo(@30);
    }];
    
    _currentHeaderView = [[UIView alloc] init];
    _currentHeaderView.backgroundColor = [UIColor colorWithRed:0/255.0 green:118/255.0 blue:255/255.0 alpha:0.03];
    UILabel *label = [UILabel labelWithText:[NSString stringWithFormat:@"累计获得佣金%@元",self.responseModel.all_receive_reward] textColor:[UIColor XSJColor_tBlue] fontSize:15.0f];
    self.label = label;
    [_currentHeaderView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currentHeaderView);
        make.left.equalTo(_currentHeaderView).offset(16);
    }];
}

- (void)noDataButtonAction:(UIButton *)sender{
    ELog(@"进入人脉兼职专题");
    TopicJobList_VC *viewCtrl = [[TopicJobList_VC alloc] init];
    viewCtrl.adDetailId = self.responseModel.job_topic_id.stringValue;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)showMenu{
    [self.popMenu showMenuAtPoint:CGPointMake(self.view.width - 130, 55)];
}

- (XHPopMenu *)popMenu{
    if (!_popMenu) {
        NSArray *altTitles = @[@"接收推送", @"取消推送"];
        XHPopMenuItem *popMenuPlublishItem = [[XHPopMenuItem alloc] initWithImage:nil title:@"人脉王介绍"];
        XHPopMenuItem *popMenuCloseItem = [[XHPopMenuItem alloc] initWithImage:nil title:altTitles[self.responseModel.is_receive_social_activist_push.integerValue]];
        XHPopMenu *epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuPlublishItem, popMenuCloseItem]];
        epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
            if (index == 0) {
                ELog(@"进入人脉王介绍");
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                viewCtrl.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,KUrl_SocialAcIntrol];
                [self.navigationController pushViewController:viewCtrl animated:YES];                
            }else if (index == 1){
                ELog(@"取消/接受推送开启");
                [self updatePushStatus:altTitles item:menuItem];
                WEAKSELF
                [[XSJRequestHelper sharedInstance] openSocialActivistJobPush:(self.responseModel.is_receive_social_activist_push.integerValue == 1) ? @"1" : @"0" block:^(id result) {
                    if (!result){
                        [UIHelper toast:@"网络错误,请重试"];
                        [weakSelf updatePushStatus:altTitles item:menuItem];
                    }
                }];
            }
        };
        _popMenu = epPopMenu;
    }
    return _popMenu;
}

- (void)setNavItem{
    //rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"msg_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
}

- (void)getHistoriyData{
    ELog(@"获取历史记录");
    [self.tableView.footer beginRefreshing];
}

- (void)judgeNodataStatus{
    if (!self.currectArr.count && !self.historicArr.count) {
        self.viewWithNoData.hidden = NO;
    }else{
        self.viewWithNoData.hidden = YES;
    }
}

- (void)updateBtnStatus:(BOOL)enable{
    [self.historyBtn setEnabled:enable];
    self.historyBtn.backgroundColor = enable ? [UIColor XSJColor_tGrayMiddle] : [UIColor clearColor] ;
}

- (void)updatePushStatus:(NSArray *)altTitles item:(XHPopMenuItem *)menuItem{
    if (self.responseModel.is_receive_social_activist_push.integerValue == 1) {
        self.responseModel.is_receive_social_activist_push = @0;
        menuItem.title = altTitles[0];
    }else{
        self.responseModel.is_receive_social_activist_push = @1;
        menuItem.title = altTitles[1];
    }
    [UserData delayTask:0.2f onTimeEnd:^{
        [_popMenu makeTabelviewReload];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    ELog(@"dealloc");
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
