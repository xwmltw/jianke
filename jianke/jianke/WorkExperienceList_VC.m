
//
//  WorkExperienceList_VC.m
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "WorkExperienceList_VC.h"
#import "PostWorkExpe_VC.h"
#import "WorkExpList_Cell.h"

@interface WorkExperienceList_VC () <WorkExpList_CellDelegate>{
    BOOL _isUpdateBlock;
}

@end

@implementation WorkExperienceList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作经历";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v324_post_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.backgroundColor = [UIColor XSJColor_newGray];
//    [self initWithNoDataViewWithStr:@"暂无工作经历" onView:self.tableView];
    [self initWithNoDataViewWithLabColor:nil imgName:nil onView:self.tableView strArgs:@"暂无工作经历",@"丰富的工作经历能提升简历质量", nil];
    self.tableView.estimatedRowHeight = 183.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"WorkExpList_Cell") forCellReuseIdentifier:@"WorkExpList_Cell"];
    self.refreshType = RefreshTypeHeader;
    [self getData:YES];
}

- (void)getData:(BOOL)isShowLoading{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryResumeExperienceList:isShowLoading block:^(ResponseInfo *result) {
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            NSArray *array = [ResumeExperienceModel objectArrayWithKeyValuesArray:[result.content objectForKey:@"resume_experience_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            weakSelf.dataSource = [array mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)headerRefresh{
    [self getData:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkExpList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkExpList_Cell" forIndexPath:indexPath];
    ResumeExperienceModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.delegate = self;
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeExperienceModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newGray];
    return view;
}

#pragma mark - WorkExpList_CellDelegate
- (void)WorkExpList_Cell:(WorkExpList_Cell *)cell actionType:(BtnOnClickActionType)actionType model:(ResumeExperienceModel *)model{
    switch (actionType) {
        case BtnOnClickActionType_editWorkExperience:{
            [self enterPostWork:model isEdit:YES];
        }
            break;
        case BtnOnClickActionType_deleteWorkExperience:{
            [MKAlertView alertWithTitle:nil message:@"确定删除该工作经历吗？" cancelButtonTitle:@"删除" confirmButtonTitle:@"取消" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self deleteResumeWith:model];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)rightItemOnClick{
    if (self.dataSource.count >= 5) {
        [UIHelper toast:@"最多只能添加5个工作经历"];
        return;
    }
    [self enterPostWork:nil isEdit:NO];
}

- (void)enterPostWork:(ResumeExperienceModel *)model isEdit:(BOOL)isEdit{
    PostWorkExpe_VC *vc = [[PostWorkExpe_VC alloc] init];
    vc.model = model;
    vc.isEdit = isEdit;
    WEAKSELF
    vc.block = ^(id result){
        _isUpdateBlock = YES;
        [weakSelf getData:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteResumeWith:(ResumeExperienceModel *)model{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] deleteResumeExperience:model.resume_experience_id block:^(id result) {
        if (result) {
            [weakSelf.dataSource removeObject:model];
            if (!weakSelf.dataSource.count) {
                weakSelf.viewWithNoData.hidden = NO;
            }
            _isUpdateBlock = YES;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)backToLastView{
    if (_isUpdateBlock) {
        MKBlockExec(self.block, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
