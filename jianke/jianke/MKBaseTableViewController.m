//
//  MKBaseTableViewController.m
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewController.h"

@interface MKBaseTableViewController ()

@end

@implementation MKBaseTableViewController



#pragma mark - Publish Method
- (void)configuraTableViewSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}

- (void)loadDataSource {
    [self.datasArray removeAllObjects];
    // subClasse
}

- (void)setUIHaveBottomView{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.btnBottom];
    [self.bottomView setBorderWidth:0.5 andColor:[UIColor XSJColor_grayLine]];
    
    WEAKSELF
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.btnBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset(12);
        make.right.equalTo(weakSelf.bottomView).offset(-12);
        make.top.equalTo(weakSelf.bottomView).offset(8);
        make.bottom.equalTo(weakSelf.bottomView).offset(-8);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.bottomView.mas_top);
    }];
}

- (void)btnBottomOnclick:(UIButton*)sender{
    //重写底部按钮事件
}


- (void)setUISingleTableView{
    [self.view addSubview:self.tableView];
    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - Propertys

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)setIsNeedHeadRefresh:(BOOL)isNeedHeadRefresh{
    if (isNeedHeadRefresh) {
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    }else{
        _tableView.header = nil;
    }
}

- (UIView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton*)btnBottom{
    if (!_btnBottom) {
        _btnBottom = [UIButton creatBottomButtonWithTitle:@"确定" addTarget:self action:@selector(btnBottomOnclick:)];
    }
    return _btnBottom;
}

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}


#pragma mark - ***** Life cycle ******
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableViewStyle = UITableViewStylePlain;
}

- (UITableViewStyle)tableViewStyle{
    if (!_tableViewStyle) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return _tableViewStyle;
}

- (void)dealloc {
//    self.tableView.delegate = nil;
//    self.tableView.dataSource = nil;
//    self.tableView = nil;
}





#pragma mark - ***** UITableView DataSource ******
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasArray.count ? _datasArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - ***** TableView Helper Method ******
- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
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
