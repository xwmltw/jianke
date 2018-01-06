//
//  NetworkTest_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NetworkTest_VC.h"
#import "XSJConst.h"
#import "WDRequestMgr.h"
#import "NetHelper.h"
#import "XSJSessionMgr.h"

@interface NetworkTest_VC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NetworkTest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"set seq = 0";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"set error code = 12";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"set error code = 13";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"change token";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [WDRequestMgr sharedInstance].seq = 0;
    }else if (indexPath.row == 1){
        [NetHelper setErrorCode:12];
    }else if (indexPath.row == 2){
        [NetHelper setErrorCode:13];
    }else if (indexPath.row == 3){
        [[XSJSessionMgr sharedInstance] setLatestSessionId:@"6666666666666666"];
        [XSJNetWork changeToken];
    }
    [UIHelper toast:@"OK"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
