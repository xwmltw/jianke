//
//  LookupApplyJKListController.m
//  jianke
//
//  Created by fire on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  查询已报名兼客列表

#import "LookupApplyJKListController.h"
#import "UserData.h"
#import "ApplyJKCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface LookupApplyJKListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *applyJKList; /*!< 已报名兼客列表 */
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation LookupApplyJKListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyJKCell" bundle:nil] forCellReuseIdentifier:@"ApplyJKCell"];
    self.tableView.separatorColor = MKCOLOR_RGB(230, 230, 230);
    self.tableView.allowsSelection = NO;
    
    [self getData];    
}

- (void)getData
{
    [[UserData sharedInstance] queryApplyJobResumeListWithJobId:self.jobId block:^(NSArray *applyJKList) {
       
        self.applyJKList = applyJKList;
        
        [self setData];
    }];;
}


- (void)setData
{
    if (!self.applyJKList || self.applyJKList.count == 0) {
        self.title = @"录用详情 (0)";
        return;
    }
    
    self.title = [NSString stringWithFormat:@"录用详情 (%lu)", (unsigned long)self.applyJKList.count];
    [TalkingData trackEvent:@"岗位详情_已报名_录用详情"];

    [self.tableView reloadData];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.applyJKList) {
        
        return self.applyJKList.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplyJKCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyJKCell"];
    cell.model = self.applyJKList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ApplyJKCell" configuration:^(ApplyJKCell *cell) {
        
       cell.model = self.applyJKList[indexPath.row];
    }];
}


@end
