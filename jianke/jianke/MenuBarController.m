//
//  MenuBarController.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客首页底部菜单工具条

#import "MenuBarController.h"
#import "WDConst.h"
#import "BarButton.h"
#import "MenuPositionViewController.h"
#import "MenuJobViewController.h"
#import "MenuTimeViewController.h"
#import "MenuMoneyViewController.h"
#import "MenuBarDefine.h"
#import "CollectionViewCellModel.h"
#import "JobClassifierModel.h"


@interface MenuBarController ()

@property (nonatomic, strong) UIButton *coverBtn; /*!< 遮罩按钮 */
@property (nonatomic, strong) UIView *menuContentView; /*!< 菜单内容View */

@property (nonatomic, assign, getter=isCoverBtnShowing) BOOL coverBtnShowing; /*!< 标志遮罩当前是否显示 */
@property (nonatomic, weak) BarButton *selBarBtn; /*!< 标志当前选中的barButton */
@property (nonatomic, weak) UIView *selMenuContentItem; /*!< 标志当前显示在menuContentView上的菜单View */

@property (nonatomic, weak) MenuPositionViewController *menuPositionVC; /*!< 位置控制器 */
@property (nonatomic, weak) MenuJobViewController *menuJobVC; /*!< 岗位控制器 */
@property (nonatomic, weak) MenuTimeViewController *menuTimeVC; /*!< 时间控制器 */
@property (nonatomic, weak) MenuMoneyViewController *menuMoneyVC; /*!< 薪资控制器 */

@end

@implementation MenuBarController

#pragma mark - 懒加载
- (UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_coverBtn setBackgroundColor:MKCOLOR_RGBA(60, 60, 60, 0.6)];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

- (UIView *)menuContentView
{
    if (!_menuContentView) {
        _menuContentView = [[UIView alloc] init];
        _menuContentView.width = kMenuContentWidth;
        _menuContentView.height = kMenuContentHeight;
        _menuContentView.x = self.view.x + 4;
        _menuContentView.y = self.view.y - kMenuContentHeight + 5;
        _menuContentView.backgroundColor = [UIColor whiteColor];
        _menuContentView.layer.cornerRadius = 2;
        _menuContentView.layer.masksToBounds = YES;
    }
    return _menuContentView;
}

- (MenuPositionViewController *)menuPositionVC
{
    if (!_menuPositionVC) {
        MenuPositionViewController *menuPositionVC = [[MenuPositionViewController alloc] init];
        menuPositionVC.menuBarVC = self;
        _menuPositionVC = menuPositionVC;
        [self.parentViewController addChildViewController:_menuPositionVC];
    }
    return _menuPositionVC;
}

- (MenuJobViewController *)menuJobVC
{
    if (!_menuJobVC) {
        MenuJobViewController *menuJobVC = [[MenuJobViewController alloc] init];
        menuJobVC.menuBarVC = self;
        _menuJobVC = menuJobVC;
        [self.parentViewController addChildViewController:_menuJobVC];
    }
    return _menuJobVC;
}

- (MenuTimeViewController *)menuTimeVC
{
    if (!_menuTimeVC) {
        MenuTimeViewController *menuTimeVC = [[MenuTimeViewController alloc] init];
        menuTimeVC.menuBarVC = self;
        _menuTimeVC = menuTimeVC;
        [self.parentViewController addChildViewController:_menuTimeVC];
    }
    return _menuTimeVC;
    
}

- (MenuMoneyViewController *)menuMoneyVC
{
    if (!_menuMoneyVC) {
        MenuMoneyViewController *menuMoneyVC = [[MenuMoneyViewController alloc] init];
        menuMoneyVC.menuBarVC = self;
        _menuMoneyVC = menuMoneyVC;
        [self.parentViewController addChildViewController:_menuMoneyVC];
    }
    return _menuMoneyVC;
}


- (void)setViewXWithType:(BOOL)bType{
    CGRect frame = self.view.frame;
    CGFloat menuBarViewX;
    if (bType) {
        menuBarViewX = SCREEN_WIDTH + (SCREEN_WIDTH - kMenuBarWidth) * 0.5;
    }else{
        menuBarViewX = (SCREEN_WIDTH - kMenuBarWidth) * 0.5;
    }
    frame.origin.x = menuBarViewX;
    self.view.frame = frame;
}

#pragma mark - 初始化方法
- (void)loadView
{
    // 设置view
    CGFloat menuBarViewX = SCREEN_WIDTH + (SCREEN_WIDTH - kMenuBarWidth) * 0.5 - 10;
    CGFloat menuBarViewY = SCREEN_HEIGHT - kMenuBarHeight - kMenuBarBotton - 4;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(menuBarViewX + 4, menuBarViewY, kMenuBarWidth + 8, kMenuBarHeight + 5)];
    self.view.backgroundColor = [UIColor clearColor];
    
    // 背景
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"main_bg_touming"];
//    bgImgView.center = self.view.center;
    [self.view addSubview:bgImgView];
    
    
    // 添加menu菜单按钮
    // 位置
    BarButton *positionBtn = [BarButton buttonWithNorImage:@"job_sx_wz_1" SelImage:@"job_sx_wz_0" target:self action:@selector(positionClick:) title:nil];
    positionBtn.x = 0;
    positionBtn.y = 2;
    positionBtn.width = kMenuBarBtnWidth;
    positionBtn.height = kMenuBarBtnHeight;
    [self.view addSubview:positionBtn];
    
    // 岗位
    BarButton *jobBtn = [BarButton buttonWithNorImage:@"job_sx_gw_1" SelImage:@"job_sx_gw_0" target:self action:@selector(jobClick:) title:nil];
    jobBtn.x = CGRectGetMaxX(positionBtn.frame);
    jobBtn.y = 2;
    jobBtn.width = kMenuBarBtnWidth;
    jobBtn.height = kMenuBarBtnHeight;
    [self.view addSubview:jobBtn];
    
    // 时间
    BarButton *timeBtn = [BarButton buttonWithNorImage:@"job_sx_time_1" SelImage:@"job_sx_time_0" target:self action:@selector(timeClick:) title:nil];
    timeBtn.x = CGRectGetMaxX(jobBtn.frame);
    timeBtn.y = 2;
    timeBtn.width = kMenuBarBtnWidth;
    timeBtn.height = kMenuBarBtnHeight;
    [self.view addSubview:timeBtn];
    
    // 薪资
    BarButton *moneyBtn = [BarButton buttonWithNorImage:@"job_sx_gx_1" SelImage:@"job_sx_gx_0" target:self action:@selector(moneyClick:) title:nil];
    moneyBtn.x = CGRectGetMaxX(timeBtn.frame);
    moneyBtn.y = 2;
    moneyBtn.width = kMenuBarBtnWidth;
    moneyBtn.height = kMenuBarBtnHeight;
    [self.view addSubview:moneyBtn];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

#pragma mark - 其他方法
/** 添加遮罩,显示菜单contentView */
- (void)addCoverBtn
{
    if (!self.isCoverBtnShowing) {
        [self.view.superview insertSubview:self.coverBtn belowSubview:self.view];
        [self.view.superview insertSubview:self.menuContentView aboveSubview:self.view];
        self.coverBtnShowing = YES;
    }
    
//    ELog(@"%@", NSStringFromCGRect(self.menuContentView.frame));
}

/** 去除遮罩,隐藏菜单contentView */
- (void)removeCoverBtn
{
    if (self.isCoverBtnShowing) {
        [self.coverBtn removeFromSuperview];
        [self.menuContentView removeFromSuperview];
        self.coverBtnShowing = NO;
    }
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(menuBar:didClickedWithChoose:)]) {
        
        NSMutableString *choose = [[NSMutableString alloc] init];
        
        // 城市ID
        NSString *cityID = [NSString stringWithFormat:@"query_condition:{city_id:%@", [[UserData sharedInstance] city].id];
        [choose appendString:cityID];
        
        // 位置
        if (self.menuPositionVC && self.menuPositionVC.selectArray.count > 0) {
            
            NSString *positionStr = @"";
            if (self.menuPositionVC.selectArray.count == 1) { // 可能为: 全福州 或 附近 或只有一个子区域
                
                CollectionViewCellModel *model =  self.menuPositionVC.selectArray.lastObject;
                if (model.type == CollectionViewCellModelTypeParentOption) { // 全福州
                    
                    positionStr = @"";
                } else if (model.type == CollectionViewCellModelTypeDefault) { // 附近
                    
                    LocalModel *local = [[UserData sharedInstance] local];
                    if (local) {
                        positionStr = [NSString stringWithFormat:@", coord_latitude:\"%@\",coord_longitude:\"%@\"", local.latitude, local.longitude];
                    } else {
                        positionStr = @"";
                    }
                    
                } else { // 子区域
                    
                    CityModel *city = model.model;
                    positionStr = [NSString stringWithFormat:@", address_area_id:\"%@\"", city.id];
                }
                
            } else if (self.menuPositionVC.selectArray.count > 1) { // 多个子区域
             
                NSArray *AreaArray = [self.menuPositionVC.selectArray valueForKey:@"model"];
                NSArray *areaIds = [AreaArray valueForKeyPath:@"id"];
                NSString *areaIdStr = [areaIds componentsJoinedByString:@","];
                positionStr = [NSString stringWithFormat:@", address_area_id:\"%@\"", areaIdStr];
            }
            
            [choose appendString:positionStr];
            [TalkingData trackEvent:@"兼客首页_位置筛选条件" label:choose];
        }
        
        
        // 岗位
        if (self.menuJobVC && self.menuJobVC.selectArray.count > 0) {
            
            NSString *jobStr = nil;
            if (self.menuJobVC.selectArray.count == 1) { // 可能为: 其他 或 不限 或只有一种岗位类型
                
                CollectionViewCellModel *model =  self.menuJobVC.selectArray.lastObject;
                if (model.type == CollectionViewCellModelTypeDefault) { // 不限
            } else { // 一种岗位, 其他
                    
                    JobClassifierModel *job = model.model;
                    jobStr = [NSString stringWithFormat:@", job_type_id:[%@]", job.job_classfier_id];
                    [TalkingData  trackEvent:@"兼客首页_岗位筛选条件" label:jobStr];

                    [choose appendString:jobStr];
                }
                
            } else if (self.menuJobVC.selectArray.count > 1) { // 多种岗位类型
                
                NSArray *jobArray = [self.menuJobVC.selectArray valueForKey:@"model"];
                NSArray *jobIds = [jobArray valueForKey:@"job_classfier_id"];
                NSString *jobIdStr = [jobIds componentsJoinedByString:@","];
                jobStr = [NSString stringWithFormat:@", job_type_id:[%@]", jobIdStr];
                [choose appendString:jobStr];
                [TalkingData  trackEvent:@"兼客首页_岗位筛选条件" label:choose];

            }
        }
        
        
        //  时间
        if (self.menuTimeVC) {
            
            if (self.menuTimeVC.selectType != 0) { // 不是不限
                NSString *timeCondition = [NSString stringWithFormat:@", left_time_type:%ld", (long)self.menuTimeVC.selectType];
                [choose appendString:timeCondition];
                [TalkingData trackEvent:@"兼客首页_时间筛选条件" label:choose];

            }
        }
        
        // 高薪
        if (self.menuMoneyVC) {
            
            if (self.menuMoneyVC.selectType != 0) { // 不是不限
                NSString *moneyCondition = [NSString stringWithFormat:@", salary_unit:%ld", (long)self.menuMoneyVC.selectType];
                [choose appendString:moneyCondition];
                [TalkingData trackEvent:@"兼客首页_高薪筛选条件" label:choose];
            }
        }
        
        [choose appendString:@"}"];
      

        [self.delegate menuBar:self didClickedWithChoose:choose];
    }
    
}

/** 设置选中的菜单 */
- (void)setSelBtn:(BarButton *)btn
{
    // 标志为当前选中菜单项
    btn.selected = !btn.selected;
    if (self.selBarBtn && self.selBarBtn != btn) {
        self.selBarBtn.selected = NO;
    }
    self.selBarBtn = btn;
    
    // 隐藏/显示遮罩及菜单的contentView
    if (btn.selected) {
        [self addCoverBtn];
    }
}


#pragma mark - 点击事件
/** 遮罩点击事件 */
- (void)coverBtnClick
{
    DLog(@"遮罩点击");
    
    // 动画缩回
    [self hideWithAnimation];
    
    // 去除选中标记
    if (self.selBarBtn) {
        self.selBarBtn.selected = NO;
    }
}

/** 动画缩回菜单 */
- (void)hideWithAnimation
{
    
    [self removeCoverBtn];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.menuContentView.height = 10;
//        self.menuContentView.y = self.view.y + 5;
//        
//    } completion:^(BOOL finished) {
//        
//        if (finished) {
//            // 移除遮罩,菜单
//            [self removeCoverBtn];
//        }
//        
//    }];
}

/** 动画弹出菜单 */
- (void)showWithAnimation
{
    self.menuContentView.height = 0;
    self.menuContentView.y = self.view.y + 5;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.menuContentView.y = self.view.y - kMenuContentHeight + 5;
        self.menuContentView.height = kMenuContentHeight;
        
    }];
}

/** 位置菜单点击 */
- (void)positionClick:(BarButton *)btn
{
    DLog(@"位置菜单点击");
    [self setSelBtn:btn];
    [TalkingData trackEvent:@"兼客首页_位置筛选"];

    // 切换菜单
    if (self.selMenuContentItem != self.menuPositionVC.view) {
        [self.selMenuContentItem removeFromSuperview];
        [self.menuContentView addSubview:self.menuPositionVC.view];
    }
    
    // 隐藏/显示遮罩及菜单的contentView
    if (btn.selected) {
        [self showWithAnimation];
    } else {
        [self hideWithAnimation];
    }
    
    self.selMenuContentItem = self.menuPositionVC.view;
}

/** 岗位菜单点击 */
- (void)jobClick:(BarButton *)btn
{
    DLog(@"岗位菜单点击");
    [self setSelBtn:btn];
    [TalkingData trackEvent:@"兼客首页_岗位筛选"];
    
    // 切换菜单
    if (self.selMenuContentItem != self.menuJobVC.view) {
        [self.selMenuContentItem removeFromSuperview];
        [self.menuContentView addSubview:self.menuJobVC.view];
    }

    // 隐藏/显示遮罩及菜单的contentView
    if (btn.selected) {
        [self showWithAnimation];
    } else {
        [self hideWithAnimation];
    }
    
    self.selMenuContentItem = self.menuJobVC.view;
}

/** 时间菜单点击 */
- (void)timeClick:(BarButton *)btn
{
    DLog(@"时间菜单点击");
    [TalkingData trackEvent:@"兼客首页_时间筛选"];

    [self setSelBtn:btn];
    // 切换菜单
    if (self.selMenuContentItem != self.menuTimeVC.view) {
        [self.selMenuContentItem removeFromSuperview];
        [self.menuContentView addSubview:self.menuTimeVC.view];
    }
    
    // 隐藏/显示遮罩及菜单的contentView
    if (btn.selected) {
        [self showWithAnimation];
    } else {
        [self hideWithAnimation];
    }
    
    self.selMenuContentItem = self.menuTimeVC.view;
    
}

/** 薪资菜单点击 */
- (void)moneyClick:(BarButton *)btn
{
    DLog(@"薪资菜单点击");
    [TalkingData trackEvent:@"兼客首页_高薪筛选"];
    
    [self setSelBtn:btn];
    
    // 切换菜单
    if (self.selMenuContentItem != self.menuMoneyVC.view) {
        [self.selMenuContentItem removeFromSuperview];
        [self.menuContentView addSubview:self.menuMoneyVC.view];
    }
    
    // 隐藏/显示遮罩及菜单的contentView
    if (btn.selected) {
        [self showWithAnimation];
    } else {
        [self hideWithAnimation];
    }
    
    self.selMenuContentItem = self.menuMoneyVC.view;
}


@end
