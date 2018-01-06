//
//  BottomViewControllerBase.m
//  jianke
//
//  Created by xuzhi on 16/7/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MJRefresh.h"

@interface BottomViewControllerBase () <UIAlertViewDelegate>
@end

@implementation BottomViewControllerBase

- (instancetype)init{
    self = [super init];
    if (self) {
        _btnHeight = 44;
        _marginX = 16;
        _marginY = 12;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
}

//初始化UI
- (void)initUIWithType:(DisplayType)type{
    _type = type;
    switch (type) {
        case DisplayTypeTableViewAndBottom:{
            NSString *output = [NSString stringWithFormat:@"****%@\n****%s : 未设置btntitles",[self class],__FUNCTION__];
            NSAssert((self.btntitles && self.btntitles.count), output);
            [self newBottomView];
        }
            break;
        case DisplayTypeOnlyTableView:
            break;
        case DisplayTypeTableViewAndTopBottom:{
            [self newTopView];
            [self newBottomView];
        }
            break;
    }
    [self makeConstraint:type];
    [self newRefresh];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UIHelper createTableViewWithStyle:_tableViewStyle delegate:self onView:self.view];
    }
    return _tableView;
}

- (void)newTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _topView = topView;
    [self.view addSubview:topView];
}

- (void)newBottomView{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor XSJColor_grayTinge];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [self newBottomBtns];
}

- (void)newBottomBtns{
    NSMutableArray *btns = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *title in self.btntitles) {
        UIButton *button = [UIButton creatBottomButtonWithTitle:title addTarget:self action:@selector(didClickAction:)];
        button.tag = index;
        [self.bottomView addSubview:button];
        [btns addObject:button];
        index++;
    }
    _bottomBtns = [btns copy];
}

- (void)makeConstraint:(DisplayType)type{
    if (type == DisplayTypeOnlyTableView) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(self.view);
        }];
    }else if (type == DisplayTypeTableViewAndBottom) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeBtnConstraint];
        
    }else if (type == DisplayTypeTableViewAndTopBottom){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self makeBtnConstraint];
    }
}

- (void)newRefresh{
    switch (self.refreshType) {
        case RefreshTypeNone:
            break;
        case RefreshTypeHeader:{
            WEAKSELF
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headerRefresh];
            }];
        }
            break;
        case RefreshTypeFooter:{
            WEAKSELF
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf footerRefresh];
            }];
        }
            break;
        case RefreshTypeAll:{
            WEAKSELF
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headerRefresh];
            }];
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf footerRefresh];
            }];
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource ? _dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - 刷新事件

- (void)headerRefresh{
    
}

- (void)footerRefresh{
    
}

#pragma mark - 事件响应方法

- (void)didClickAction:(UIButton *)sender{
    if (self.btnEventBlock) {
        self.btnEventBlock(sender);
        return;
    }
    [self clickOnview:self.bottomView clickedButtonAtIndex:sender.tag];
}

- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark - setter方法

- (void)setRefreshType:(RefreshType)refreshType{
    _refreshType = refreshType;
    [self newRefresh];
}

- (void)setBtntitles:(NSArray *)btntitles{
    _btntitles = btntitles;
    if (self.type == DisplayTypeTableViewAndBottom) { //解决btnTitles赋值操作在初始化UI方法后面
        UIButton *button;
        NSArray *btns = self.bottomView.subviews;
        for (NSInteger index =0 ; index < btns.count; index++) {
            button = [btns objectAtIndex:index];
            if (index >= btntitles.count) {
                break;
            }
            [button setTitle:btntitles[index] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 其他

/** 显示底部视图 */
- (void)showBottomView{
    if (self.type == DisplayTypeTableViewAndBottom && self.bottomView.isHidden) {
        self.bottomView.hidden = NO;
        [self removeConstraints];
        [self makeConstraint:DisplayTypeTableViewAndBottom];
    }
}

/** 隐藏底部视图 */
- (void)hidesBottomView{
    if (self.type == DisplayTypeTableViewAndBottom) {
        self.bottomView.hidden = YES;
        [self removeConstraints];
        [self makeConstraint:DisplayTypeOnlyTableView];
    }
}

/** 清除所有约束 */
- (void)removeConstraints{

    [self.tableView removeConstraints:self.tableView.constraints];
    
    if (self.type == DisplayTypeTableViewAndBottom) {
        for (UIView *subView in self.bottomView.subviews) {
            if (subView.constraints) {
                [subView removeConstraints:subView.constraints];
            }
        }
        [self.bottomView removeConstraints:self.bottomView.constraints];
    }

}

- (void)makeBtnConstraint{
    NSInteger index = self.bottomBtns.count;
    CGFloat margin = _marginY;
    for (UIButton *button in self.bottomBtns) {
        margin = index * _marginY;
        index--;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(_marginX);
            make.right.equalTo(self.view).offset(-(_marginX));
            make.bottom.equalTo(self.bottomView).offset(-(index * _btnHeight + margin));
            make.height.equalTo(@(_btnHeight));
        }];
    }
    
    UIButton *preBtn = [self.bottomBtns firstObject];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(preBtn.mas_top).offset(-12);
    }];
    
//    [self.bottomView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7f borderColor:[UIColor XSJColor_tGrayTinge] isConstraint:YES];
}

@end
