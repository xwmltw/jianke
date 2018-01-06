//
//  IMHome_VC.m
//  ;
//
//  Created by xiaomk on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "IMHome_VC.h"
#import "IMChatListController.h"
#import "ImDataManager.h"
#import "ImConst.h"

@interface IMHome_VC ()<UIScrollViewDelegate>

//@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView *tableViewBg;
@property (nonatomic, strong) IMChatListController* chatList;
@property (nonatomic, copy) NSNumber* loginType;

@end


@implementation IMHome_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    [TalkingData trackEvent:@"消息铃铛页面"];
    
    self.title = @"消息";
    self.loginType = [[UserData sharedInstance] getLoginType];
    
    self.tableViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-64-49)];
    [self.view addSubview:self.tableViewBg];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    self.chatList = [[IMChatListController alloc] initWithHome:self];
    self.chatList.loginType = self.loginType.integerValue;
    self.chatList.view = self.tableViewBg;
    
    // 静音按钮
    UIButton *quietBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [quietBtn setImage:[UIImage imageNamed:@"v3_msg_ring_1"] forState:UIControlStateNormal];
    [quietBtn setImage:[UIImage imageNamed:@"v3_msg_ring_0"] forState:UIControlStateSelected];
    [quietBtn addTarget:self action:@selector(quietBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:quietBtn];
    
    UIBarButtonItem *nevgativeSpaceRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceRight.width = -12;
    self.navigationItem.rightBarButtonItems =  @[nevgativeSpaceRight,rightBarItem];
    
    // 设置静音按钮状态
    BOOL isQuiet = [[UserData sharedInstance] getUserImNoticeQuietState];
    quietBtn.selected = isQuiet;
    
}

- (void)quietBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    [[UserData sharedInstance] setUserImNoticeQuietState:btn.selected];
    if (btn.selected) {
        [UIHelper toast:@"已关闭提示音"];
    } else {
        [UIHelper toast:@"已开启提示音"];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [WDNotificationCenter addObserver:self selector:@selector(onImLoginSuccess:) name:OnImLoginSuccessNotify object:nil];

    if (![[ImDataManager sharedInstance] isUserLogin]) {
        [[ImDataManager sharedInstance] tryLogin];
        return;
    }
    [self.chatList viewWillAppear];
}

- (void)onImLoginSuccess:(NSNotification*)notify{
    [WDNotificationCenter removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatList viewWillAppear];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.chatList viewWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
