//
//  MySubscribleList_VC.m
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MySubscribleList_VC.h"
#import "MysubscribleCell.h"
#import "EpProfile_VC.h"

@interface MySubscribleList_VC () <MysubscribleCellDelegate>

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation MySubscribleList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v3_public_info_whith"] style:UIBarButtonItemStylePlain target:self action:@selector(showHelpTips)];
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self initWithNoDataViewWithLabColor:nil imgName:nil onView:self.tableView strArgs:@"您还没有关注任何人",@"关注您感兴趣的雇主让兼职更加轻松" , nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"MysubscribleCell") forCellReuseIdentifier:@"MysubscribleCell"];
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getFocusEntListWithQueryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [EPModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"ent_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getFocusEntListWithQueryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [EPModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"ent_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MysubscribleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MysubscribleCell" forIndexPath:indexPath];
    cell.delegate = self;
    EPModel *epModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell setEpModel:epModel atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EPModel *epModel = [self.dataSource objectAtIndex:indexPath.row];
    EpProfile_VC *viewCtrl = [[EpProfile_VC alloc] init];
    viewCtrl.isLookForJK = YES;
    viewCtrl.isFromGroupMembers = YES;
    viewCtrl.accountId = epModel.account_id.description;
    WEAKSELF
    viewCtrl.block = ^(BOOL isUpdate){
        if (isUpdate) {
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (weakSelf.dataSource.count < 1) {
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - MysubscribleCellDelegate

- (void)mysubscribleCell:(MysubscribleCell *)cell atIndexPtah:(NSIndexPath *)indexPath{
    EPModel *epModel = [self.dataSource objectAtIndex:indexPath.row];
    WEAKSELF
    [MKAlertView alertWithTitle:@"提示" message:@"是否取消关注该雇主？" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[XSJRequestHelper sharedInstance] cancelFocusEntWithAccountId:epModel.account_id block:^(id result) {
                if (result) {
                    [UIHelper toast:@"成功取消关注"];
                    [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.dataSource.count < 1) {
                        weakSelf.viewWithNoData.hidden = NO;
                    }
                }
            }];
        }
    }];
}

#pragma mark - 其他

- (void)showHelpTips{
    [MKAlertView alertWithTitle:@"提示" message:@"关注雇主，可即时接收其发布的岗位推送消息" cancelButtonTitle:nil confirmButtonTitle:@"确定" completion:nil];
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
