//
//  FeedBackController.m
//  jianke
//
//  Created by fire on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  吐槽冲我来

#import "FeedBackController.h"
#import "TalkToBoss_VC.h"
#import "WDConst.h"
#import "WebView_VC.h"
#import "ImDataManager.h"

@interface FeedBackController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"吐槽冲我来";

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - TableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    switch (indexPath.row) {
//        case 0: // 帮助中心
//        {
//            cell.imageView.image = [UIImage imageNamed:@"v250_buhuiyong"];
//            cell.textLabel.text = @"帮助中心";
//        }
//            break;
        case 0: // 对话产品汪
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_talk"];
            cell.textLabel.text = @"对话产品汪";
        }
            break;
        case 1: //联系客服
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_kefu"];
            cell.textLabel.text = @"联系客服";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: // 对话产品汪
        {
            TalkToBoss_VC *phone=[UIHelper getVCFromStoryboard:@"Public" identify:@"sid_TalkToBoss"];
            [self.navigationController pushViewController:phone animated:YES];
        }
            break;
        case 1:  //联系客服
        {
            [TalkingData trackEvent:@"联系客服"];

            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }
            }];

        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
