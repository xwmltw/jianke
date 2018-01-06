//
//  ShareToGroupController.m
//  jianke
//
//  Created by fire on 15/12/31.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ShareToGroupController.h"
#import "IMGroupModel.h"
#import "WDChatView_VC.h"


@interface ShareToGroupController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupArray;

@end

@implementation ShareToGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.rowHeight = 48;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self getData];
}

    
- (void)getData{
    // 获取群组数据
    WEAKSELF
    [[UserData sharedInstance] imGetMgrGroupsWithBlock:^(NSArray *groupArray) {
        
        weakSelf.groupArray = groupArray;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    IMGroupModel *model = self.groupArray[indexPath.row];
    cell.textLabel.text = model.groupName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = MKCOLOR_RGB(155, 155, 155);
    titleLabel.text = @"    选择发送至群组：";
    return titleLabel;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMGroupModel *model = self.groupArray[indexPath.row];

    // 分享到选择的群组
    [WDChatView_VC shareJob:self.jobModel toImGroupVc:self IMGroupModel:model isBackToRootView:self.isBackToRootView];
    
}

@end
