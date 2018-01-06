//
//  MenuMoneyViewController.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MenuMoneyViewController.h"
#import "MenuBarDefine.h"
#import "UIView+MKExtension.h"
#import "MenuTableViewCell.h"
#import "TableViewCellModel.h"
#import "MenuBarController.h"

@interface MenuMoneyViewController ()
@property (nonatomic, assign) NSInteger selectIndex; /** 选中的单元格 */
@property (nonatomic, strong) NSMutableArray *dataArray; /*!< 数据模型数组 */
@end

@implementation MenuMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view的frame
    self.tableView.x = 0;
    self.tableView.y = 0;
    self.tableView.width = kMenuContentWidth;
    self.tableView.height = kMenuContentHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // tableView
    self.tableView.bounces = NO;
//    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 设置数据
    [self setupData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [MenuTableViewCell cellWithTableView:tableView];
    
    // 数据
    cell.tableViewCellModel = self.dataArray[indexPath.row];
    
    // 去除选择效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"第%ld行Cell被选中", (long)indexPath.row);
    
    if (indexPath.row == 0) { // 标题不处理
        return;
    }
    
    // 取消原先选中
    TableViewCellModel *preModel =self.dataArray[self.selectIndex];
    preModel.selected = NO;
    
    // 标记当前选中
    TableViewCellModel *model = self.dataArray[indexPath.row];
    model.selected = YES;
    self.selectIndex = indexPath.row;
    self.selectType = [self.dataArray[indexPath.row] index];
    
    // 隐藏菜单
    [self.menuBarVC coverBtnClick];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
    }
    
    return kMenuContentBtnHeight;
}


// 处理分割线没在最左边问题：ios8以后才有的问题
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)setupData{
    self.dataArray = [NSMutableArray array];
    
    TableViewCellModel *data0 = [[TableViewCellModel alloc] init];
    data0.title = @"选择排序单位";
    data0.selected = NO;
    data0.index = -1;
    [self.dataArray addObject:data0];
    
    
    TableViewCellModel *data1 = [[TableViewCellModel alloc] init];
    data1.title = @"元/时";
    data1.selected = NO;
    data1.index = 2;
    [self.dataArray addObject:data1];
    
    TableViewCellModel *data2 = [[TableViewCellModel alloc] init];
    data2.title = @"元/天";
    data2.selected = NO;
    data2.index = 1;
    [self.dataArray addObject:data2];
    
    TableViewCellModel *data3 = [[TableViewCellModel alloc] init];
    data3.title = @"元/月";
    data3.selected = NO;
    data3.index = 3;
    [self.dataArray addObject:data3];
    
    TableViewCellModel *data4 = [[TableViewCellModel alloc] init];
    data4.title = @"元/次";
    data4.selected = NO;
    data4.index = 4;
    [self.dataArray addObject:data4];
    
    TableViewCellModel *data5 = [[TableViewCellModel alloc] init];
    data5.title = @"不限";
    data5.selected = YES;
    data5.index = 0;
    [self.dataArray addObject:data5];
    
    // 设置默认选中
    self.selectIndex = 5;
    self.selectType = 0;
    
    [self.tableView reloadData];
}

@end
