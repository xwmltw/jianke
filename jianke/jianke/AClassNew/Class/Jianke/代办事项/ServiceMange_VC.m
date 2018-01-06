//
//  ServiceMange_VC.m
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ServiceMange_VC.h"
#import "WorkHistoryController.h"
#import "QRcodeScan_VC.h"
#import "ToolBarItem.h"

@interface ServiceMange_VC ()<ToolBarItemDelegate>

@end

@implementation ServiceMange_VC

- (void)viewDidLoad {
//    self.isRootVC = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"待办事项";
    [self initNavigationButton];
    [self updateVC];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([XSJUserInfoData sharedInstance].MyWaitToDoOpen) {
        self.selectedIndex = 0;
        [XSJUserInfoData sharedInstance].MyWaitToDoOpen = NO;
    }
    [self setItemBudgeAtIndex:1];
}

- (void)updateVC{
    JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
    if (jkModel.is_apply_service_personal.integerValue != 1) {
        self.customToolBar.hidden = YES;
        self.customToolBar.height = 0.01;
        self.selectedIndex = 0;
    }else{
        self.customToolBar.hidden = NO;
        self.customToolBar.height = 49;
    }
}

- (void)initNavigationButton{
    
    UIButton *btnQrCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQrCode.frame = CGRectMake(0, 0, 66, 44);
    btnQrCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnQrCode setTitle:@"扫码录用" forState:UIControlStateNormal];
    [btnQrCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQrCode addTarget:self action:@selector(btnQrCodeOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnQrCode];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 创建toolBar

/**
 *  创建toolBar
 */

- (UIView *)customToolBar{
    if (!_customToolBar) {
        [self createToolBar];
    }
    return _customToolBar;
}
- (void)createToolBar{
    if (!self.toolBarTitles.count) {
        ELog(@"不创建toolBar")
        return;
    }
    NSAssert((self.childVCs.count), @"未给childVCs赋值");
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    toolBar.backgroundColor = [UIColor XSJColor_blackBase];
    _customToolBar = toolBar;
    [self.view addSubview:toolBar];
    ToolBarItem *item = nil;
    for (NSInteger index = 0; index < self.toolBarTitles.count; index++) {
        item = [self createToolBarItem:self.toolBarTitles[index]];
        [item setItemTag:index];
        [_customToolBar addSubview:item];
        [self layoutToolBarBtns];
    }
    self.selectedIndex = 0;
}

- (ToolBarItem *)createToolBarItem:(NSString *)title{
    ToolBarItem *item = [[ToolBarItem alloc] init];
    item.itemTitle = title;
    item.delegate = self;
    return item;
}

/**
 *  对toolBar排序
 */

- (void)layoutToolBarBtns{
    NSArray *subViews = [_customToolBar subviews];
    CGFloat width = SCREEN_WIDTH / subViews.count;
    CGFloat height = _customToolBar.height;
    for (NSInteger index = 0; index < subViews.count; index++) {
        UIView *view = [subViews objectAtIndex:index];
        view.frame = CGRectMake(width * index, 0, width, height);
    }
}

#pragma mark - ToolBarItemDelegate toolBar点击业务

- (void)toolBarItem:(ToolBarItem *)item selecedIndex:(NSInteger)selectedIndex{
    ELog(@"第%ld个item被点击了", selectedIndex);
    self.selectedIndex = selectedIndex;
    [self clearBugdeAtIndex:selectedIndex];
}

- (void)clearBugdeAtIndex:(NSInteger)index{
    if (index == 1) {
        if ([XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint) {
            [WDNotificationCenter postNotificationName:ClearPersonaServiceJobNotification object:nil];
        }
        [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
        ToolBarItem *toolBarItem = self.customToolBar.subviews[index];
        toolBarItem.budgeView.hidden = YES;
    }
}

/**
 *  重写selectedIndex点方法,同时赋予创建childVC的业务
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self setSelectedBtnHightLight:selectedIndex];
    if (![self hasSelectedVCAtIndex:selectedIndex]){
        UIViewController *vc = [self.childVCs objectAtIndex:selectedIndex];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customToolBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    [self setChildVCShowAtIndex:selectedIndex];
}

- (void)setSelectedBtnHightLight:(NSInteger)selectedIndex{
    for (ToolBarItem *item in self.customToolBar.subviews) {
        item.color = MKCOLOR_RGBA(150, 150, 150, 0.88);
    }
    if (selectedIndex < self.customToolBar.subviews.count) {
        ToolBarItem *item = [self.customToolBar.subviews objectAtIndex:selectedIndex];
        item.selectedColor = [UIColor whiteColor];
    }
}

- (void)setChildVCShowAtIndex:(NSInteger)index{
    NSArray *views = [self.childVCs valueForKey:@"view"];
    for (UIView *view in views) {
        view.hidden = YES;
    }
    UIView *view = [views objectAtIndex:index];
    view.hidden = NO;
}

- (BOOL)hasSelectedVCAtIndex:(NSInteger)index{
    UIViewController *vc = [self.childVCs objectAtIndex:index];
    return !([self.childViewControllers indexOfObject:vc] == NSNotFound);
}

- (ToolBarItem *)toolBarItemAtIndex:(NSInteger)index{
    ToolBarItem *toolBarItem = self.customToolBar.subviews[index];
    return toolBarItem;
}
//
//- (void)updatePersonServiceRedpoint{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.selectedIndex != 1) {
//            [self setItemBudgeAtIndex:1];
//        }
//        if ([XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint){
//            if (self.tabBarController.selectedIndex == 1 && self.selectedIndex != 1) {
//                [self.tabBarController.tabBar showSmallBadgeOnItemIndex:1];
//            }
//        }
//    });
//    
//}

- (void)setItemBudgeAtIndex:(NSInteger)index{
    if ([XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint) {
        ToolBarItem *toolBarItem = [self toolBarItemAtIndex:index];
        toolBarItem.budgeView.hidden = NO;
    }
}

- (void)btnRecordOnclick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            WorkHistoryController *vc = [[WorkHistoryController alloc] init];
            vc.isFromInfoCenter = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}


- (void)btnQrCodeOnClick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            [UIDeviceHardware getCameraAuthorization:^(id obj) {
                QRcodeScan_VC* vc = [[QRcodeScan_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}

@end
