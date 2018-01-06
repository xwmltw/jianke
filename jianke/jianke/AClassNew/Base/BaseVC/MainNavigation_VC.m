//
//  MainNavigation_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MainNavigation_VC.h"
#import "WDConst.h"
#import "JobDetail_VC.h"
#import "WDViewControllerBase.h"

@interface MainNavigation_VC ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavigation_VC

#pragma mark - ***** 自定义方法 ******
+ (void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = [UIColor XSJColor_blackBase];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                   };
    
 
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];                                                                                                               
//    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor XSJColor_blackBase]] forBarMetrics:UIBarMetricsDefault];
//    navBar.translucent = NO;
//    navBar.barStyle = UIBarStyleDefault;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    ELog("=====MainNavigation_VC init");
    if (self = [super initWithRootViewController:rootViewController]) {
   
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    ELog(@"viewController ==== %@", [viewController class]);
//    if ([self.childViewControllers.lastObject isKindOfClass:[viewController class]]) {
//        if (![viewController isKindOfClass:[JobDetail_VC class]]) {
//            return;
//        }
//    }
    [super pushViewController:viewController animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;


}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL ok = YES;
    if ([self.topViewController isKindOfClass:[WDViewControllerBase class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            WDViewControllerBase *vc = (WDViewControllerBase *)self.topViewController;
            ok = [vc gestureRecognizerShouldBegin];
        }
    }
    
    return ok;
}

#pragma mark - 其他方法
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - view 创建 执行顺序
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
//}
//
//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//}
//
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//}
//
//- (void)dealloc{
//}



@end
