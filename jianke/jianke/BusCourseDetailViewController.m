//
//  BusCourseDetailViewController.m
//  jianke
//
//  Created by fire on 15/11/18.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "BusCourseDetailViewController.h"
#import "BusCourseDetailCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIHelper.h"

@interface BusCourseDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation BusCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"路线详情";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusCourseDetailCell" bundle:nil] forCellReuseIdentifier:@"BusCourseDetailCell"];
    [self.tableView reloadData];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        return 0;
    }else{
        return cell.frame.size.height;
    }
//    UITableViewCell* cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
//    return [tableView fd_heightForCellWithIdentifier:@"BusCourseDetailCell" configuration:^(BusCourseDetailCell *cell) {
//        
//        cell.step = self.stepArray[indexPath.row];
//    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusCourseDetailCell"];
    
    cell.stepLabel.text = self.stepArray[indexPath.row];
    CGSize labSize = [UIHelper getSizeWithString:cell.stepLabel.text width:SCREEN_WIDTH-32 font:[UIFont systemFontOfSize:16]];
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = labSize.height + 32;
    cell.frame = cellFrame;
//    cell.step = self.stepArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stepArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
