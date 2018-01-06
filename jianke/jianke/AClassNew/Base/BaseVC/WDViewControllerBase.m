//
//  WDViewControllerBase.m
//  jianke
//
//  Created by xiaomk on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"
#import "MKDeviceHelper.h"

@interface WDViewControllerBase ()

@property (nonatomic, strong) UIButton* navBackBtn;     //返回按钮
@end

@implementation WDViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor XSJColor_grayTinge];
    self.view.backgroundColor = [UIColor whiteColor];

    if (!self.isUIRectEdgeAll) {
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        if ([self respondsToSelector:@selector(modalPresentationCapturesStatusBarAppearance)]) {
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)]) {
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
    if (!self.isRootVC) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 80, 44);
        [backBtn setImage:[UIImage imageNamed:@"v3_public_img_back"] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backItem;

        UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        nevgativeSpaceLeft.width = -20;
        self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft,backItem];
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list = self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                NSArray *list2 = imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2 = (UIImageView *)obj2;
                        imageView2.hidden = YES;
                    }
                }
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *title = self.title.length ? self.title: NSStringFromClass([self class]);
    [TalkingData trackPageBegin:title];
#ifdef DEBUG
UIViewController *viewCtrl = [MKUIHelper getTopViewController];
NSLog(@"栈顶控制器为%@\n当前显示控制器为%@", [viewCtrl class], [self class]);
#endif
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
    [TalkingData trackPageEnd:title];
}

#pragma mark - ***** 无数据、无网络 View ******
- (void)initWithNoDataViewWithStr:(NSString*)str onView:(UIView*)view{
    [self initWithNoDataViewWithStr:str labColor:nil imgName:nil onView:view];
}

- (void)initWithNoDataViewWithStr:(NSString *)str labColor:(UIColor*)labColor imgName:(NSString*)imgName onView:(UIView *)view{
    [self initWithNoDataViewWithStr:str labColor:labColor imgName:imgName button:nil onView:view];
}

/** 初始化无网络 无数据 view (带按钮)*/
- (void)initWithNoDataViewWithStr:(NSString *)str labColor:(UIColor*)labColor imgName:(NSString*)imgName button:(NSString *)btnTitle onView:(UIView *)view{
    NSString* labStr;
    if (![[UserData sharedInstance] isLogin] && !self.isNotNeedLogin) {
        labStr = @"您还没有登录唷";
    }else{
        if (str) {
            labStr = str;
        }
    }
   self.viewWithNoData = [UIHelper noDataViewWithTitle:labStr titleColor:labColor image:imgName ? imgName : @"v3_public_nodata" button:btnTitle];
    [view addSubview:self.viewWithNoData];
    self.viewWithNoData.userInteractionEnabled = YES;
    self.viewWithNoData.frame = CGRectMake(0, 80, self.viewWithNoData.size.width, self.viewWithNoData.size.height);
    self.viewWithNoData.hidden = YES;
    
    if (btnTitle && btnTitle.length) {
        _btnWithNoData = (UIButton *)[view viewWithTag:998];
        [_btnWithNoData addTarget:self action:@selector(noDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //无信号
    self.viewWithNoNetwork = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    self.viewWithNoNetwork.userInteractionEnabled = NO;
    self.viewWithNoNetwork.frame = CGRectMake(0, 80, self.viewWithNoNetwork.size.width, self.viewWithNoNetwork.size.height);
    self.viewWithNoNetwork.hidden = YES;
    [self.view addSubview:self.viewWithNoNetwork];
}

- (void)setNoDataViewText:(NSString*)text{
    if (self.viewWithNoData) {
        UILabel *lab = (UILabel*)[self.viewWithNoData viewWithTag:666];
        lab.text = text;
    }
}

/** 初始化无网络 无数据 多文本 view */
- (void)initWithNoDataViewWithLabColor:(UIColor*)labColor imgName:(NSString*)imgName onView:(UIView *)view strArgs:(NSString *)arg1,... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *strArr = [NSMutableArray array];
    [strArr addObject:arg1];
    // 定义一个指向可选参数列表的指针
    va_list args;
    
    // 获取第一个可选参数的地址，此时参数列表指针指向函数参数列表中的第一个可选参数
    va_start(args, arg1);
    if(arg1)
    {
        // 遍历参数列表中的参数，并使参数列表指针指向参数列表中的下一个参数
        NSString *nextArg;
        while((nextArg = va_arg(args, NSString *)))
        {
            NSLog(@"Arg = %@", nextArg);
            [strArr addObject:nextArg];
        }
    }
    // 结束可变参数的获取(清空参数列表)
    va_end(args);
    
    NSString* labStr;
    if (![[UserData sharedInstance] isLogin]) {
        labStr = @"您还没有登录唷";
    }else{
        if (arg1) {
            labStr = arg1;
        }
    }
    self.viewWithNoData = [UIHelper noDataViewWithTitleArr:strArr titleColor:labColor image:imgName ? imgName : @"v3_public_nodata" button:nil];
    //    self.viewWithNoData = [UIHelper noDataViewWithTitle:labStr titleColor:labColor image:imgName ? imgName : @"v3_public_nodata" button:btnTitle];
    [view addSubview:self.viewWithNoData];
    self.viewWithNoData.userInteractionEnabled = YES;
    self.viewWithNoData.frame = CGRectMake(0, 80, self.viewWithNoData.size.width, self.viewWithNoData.size.height);
    self.viewWithNoData.hidden = YES;
    
    //    if (btnTitle && btnTitle.length) {
    //        _btnWithNoData = (UIButton *)[view viewWithTag:998];
    //        [_btnWithNoData addTarget:self action:@selector(noDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    
    //无信号
    self.viewWithNoNetwork = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    self.viewWithNoNetwork.userInteractionEnabled = NO;
    self.viewWithNoNetwork.frame = CGRectMake(0, 80, self.viewWithNoNetwork.size.width, self.viewWithNoNetwork.size.height);
    self.viewWithNoNetwork.hidden = YES;
    [self.view addSubview:self.viewWithNoNetwork];
    
}


- (void)createCloseBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"v3_public_close"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceLeft.width = -16;
    self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft,backItem];
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noDataButtonAction:(UIButton *)sender{
    ELog(@"点击");
}

#pragma mark - ***** 返回 ******
- (void)backToLastView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin{
    return !self.isRootVC;
}

#pragma mark - ***** 其他 ******
- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [UIApplication sharedApplication].statusBarStyle;
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
