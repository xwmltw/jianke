//
//  NewFeature_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "NewFeature_VC.h"
#import "WDConst.h"
#import "Login_VC.h"
#import "MainNavigation_VC.h"
#import "CityTool.h"


@interface NewFeature_VC () <UIScrollViewDelegate> {
    CGFloat _bottomViewHeight;
    BOOL _annimationStatus1;
    NSMutableArray* _textViewBgArray;
    NSMutableArray* _textImgBgArray;
    int _pageNow;
    NSArray *_labTitles;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView* logoImg;

@property (nonatomic, assign) BOOL isNeedJumpButton;
@end

@implementation NewFeature_VC

const int kNewFeatureImageCount = 3;

- (instancetype)init{
    if (self = [super init]) {
        _pageNow = 0;
        _bottomViewHeight = 52;
        _textViewBgArray = [[NSMutableArray alloc] init];
        _textImgBgArray = [[NSMutableArray alloc] init];
        
        _isNeedJumpButton = YES;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [CityTool getCurrentCityWithBlock:^(id obj) {
        if (!obj) {
            //            [UIHelper toast:@"定位失败"];
        }
    }];
    
    // 1.添加底部注册/登陆按钮
    [self setupBtn];
    
    // 2.添加UISrollView
    [self setupScrollView];
    
    // 3.添加pageControl
    [self setupPageControl];
    
    [self initJkjzImg];
    
//    [self textBgViewAnimation];
    
    // 跳过按钮
    if (self.isNeedJumpButton) {
        UIButton* btnJumpStart = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnJumpStart setTitle:@"跳过" forState:UIControlStateNormal];
        [btnJumpStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnJumpStart.titleLabel.font = HHFontSys(kFontSize_3);
        [btnJumpStart setBackgroundColor:[UIColor XSJColor_shadeBg]];
        [btnJumpStart setCornerValue:18];
//        [btnJumpStart setImage:[UIImage imageNamed:@"v3_public_skip"] forState:UIControlStateNormal];
        [btnJumpStart addTarget:self action:@selector(btnOnClickStart:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnJumpStart];
        
        [btnJumpStart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-16);
            make.top.equalTo(self.view).offset(28);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(36);
        }];
    }
    
    //    WEAKSELF
    //    [UserData delayTask:0.1 onTimeEnd:^{
    //        [UIView beginAnimations:@"View Filp" context:nil];
    //        [UIView setAnimationDuration:0.4];
    //        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:weakSelf.logoImg cache:NO];
    //        [UIView commitAnimations];
    //        weakSelf.logoImg.image = [UIImage imageNamed:@"guide_logo"];
    //
    //        [UserData delayTask:0.4 onTimeEnd:^{
    //            [UIView transitionWithView:weakSelf.jkjzImg duration:1 options:0 animations:^{
    //                weakSelf.jkjzImg.alpha = 1;
    //            } completion:^(BOOL finished) {
    //            }];
    //        }];
    //    }];
}

#pragma mark - ***** 底部按钮 按钮事件 ******
- (void)setupBtn{
    
    if (!self.isFromeSetting) {
        // 底部工具条
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footerView];
        
        WEAKSELF
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.view);
            make.height.mas_equalTo(_bottomViewHeight);
        }];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [loginBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor whiteColor];
        [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:loginBtn];
        
        UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [regBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
        regBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [regBtn setBackgroundColor:[UIColor XSJColor_base]];
        [regBtn addTarget:self action:@selector(regBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:regBtn];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView);
            make.bottom.equalTo(footerView);
            make.left.equalTo(footerView);
            make.right.equalTo(regBtn.mas_left);
        }];
        
        [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView);
            make.bottom.equalTo(footerView);
            make.right.equalTo(footerView);
            make.left.equalTo(loginBtn.mas_right);
            make.width.equalTo(loginBtn.mas_width);
        }];
    }
    
}

#pragma mark - ***** 初始化 UISrollView ******
- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_bottomViewHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * kNewFeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    _labTitles = @[@[@"找到适合你的兼职", @"新鲜的外壳，不变的内核\n我们将继续为您提供合适的高质量兼职"], @[@"个人服务", @"无论你是模特、礼仪、主持、商演、家教\n还是校园代理都可在此申请啦"], @[@"微信即时通知", @"绑定微信获取录用即时通知"]];
    
    for (int index = 0; index < kNewFeatureImageCount; index++) {
        
        UIView* pageView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_bottomViewHeight)];
        pageView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:pageView];
        
//        if (index == 0) {
//            UIImageView* logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_bg_0"]];
//            [pageView addSubview:logoImg];
//            
//            [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(pageView);
//                make.top.equalTo(pageView).offset(140);   //v3.0.8之前
////                make.top.equalTo(pageView).offset(70);
//            }];
//        }else{
            //背景image
            UIImageView* pageImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_bg_%d", index]]];
            [pageView addSubview:pageImg];
            
            UIView* textBgView = [[UIView alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 140, pageView.frame.size.width, 140)];
            [pageView addSubview:textBgView];
            UIImageView* textBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_text_bg"]];
            textBgImg.frame = textBgView.bounds;
            [textBgView addSubview:textBgImg];
            
//            NSString* textImgName = [NSString stringWithFormat:@"guide_text_%d", index];
//            UIImageView* textImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:textImgName]];
//            [textBgView addSubview:textImg];
            NewFeatureTextView *textImg = [[NewFeatureTextView alloc] initWithFrame:CGRectZero withTitle:_labTitles[index][0] subTitle:_labTitles[index][1]];
            [textBgView addSubview:textImg];
        
            [pageImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(pageView);
                make.top.equalTo(pageView.mas_top).offset(70);
            }];
            
            [textImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(textBgView);
                make.bottom.equalTo(textBgView).offset(-40);
            }];
            
            textImg.alpha = 1;
            [_textViewBgArray addObject:textBgView];
            [_textImgBgArray addObject:textImg];
        }
//    }
}

/** 添加pageControl */
- (void)setupPageControl{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.numberOfPages = kNewFeatureImageCount;
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor XSJColor_base];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    WEAKSELF
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-_bottomViewHeight);
    }];
}

/** 兼客兼职 动画 */
- (void)initJkjzImg{
    UIImageView* jkjzImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_jkjz_big"]];
    [self.view addSubview:jkjzImg];
    
    [jkjzImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(-60);
    }];
    
    [UserData delayTask:0.6 onTimeEnd:^{
        [UIView transitionWithView:jkjzImg duration:0.6 options:0 animations:^{
            jkjzImg.frame = CGRectMake((SCREEN_WIDTH-70)/2, 32, 80, 20);
        } completion:^(BOOL finished) {
        }];
    }];
}


#pragma mark - ***** ScorlllView delegate ******
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.x > 1 && self.pageControl.currentPage == self.pageControl.numberOfPages - 1){
        [self changeMainScene];
    }
}

/** 只要UIScrollView滚动了,就会调用 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//     1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    ELog(@"====offsetX:%f", offsetX);
//     2.求出页码
    double pageDouble = offsetX / SCREEN_WIDTH;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;

    int pageChange = pageInt;
    if (pageChange > _pageNow) {
        _pageNow = pageChange;
        [self textBgViewAnnimation];
    }
}

- (void)textBgViewAnnimation{
    if (_pageNow == 1) {
        [self textBgViewAnimation];
    }else{
        [self textImgAnimation];
    }
}


- (void)textBgViewAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView* textBgView in _textViewBgArray) {
            [UIView transitionWithView:textBgView duration:0.3 options:0 animations:^{
                CGRect frame = textBgView.frame;
                frame.origin.y = SCREEN_HEIGHT - _bottomViewHeight - 140;
                textBgView.frame = frame;
            } completion:^(BOOL finished) {
                [self textImgAnimation];
            }];
        }
    });
}

- (void)textImgAnimation{
    UIImageView* textImg = [_textImgBgArray objectAtIndex:_pageNow-1];
    [UIView transitionWithView:textImg duration:0.5 options:0 animations:^{
        textImg.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}












#pragma mark - ***** 按钮事件 ******
//注册按钮
- (void)regBtnClick{
    Login_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    vc.isFromNewFrature = YES;
    vc.isToRegister = YES;
    vc.isShowGuide = YES;
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = nav;
}
//登录按钮
- (void)loginBtnClick{
    Login_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    vc.isFromNewFrature = YES;
    vc.isShowGuide = YES;
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = nav;
}

// X 按钮
- (void)btnOnClickStart:(id)sender{
    [self changeMainScene];
}

- (void)changeMainScene{
    if (!self.isFromeSetting) {
        [XSJUIHelper showMainScene];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

//- (void)jkjzImgAnnimationMoveTop:(BOOL)toTop{
//    WEAKSELF
//    if (toTop) {
//        [UIView transitionWithView:self.jkjzImg duration:0.4 options:0 animations:^{
//            weakSelf.jkjzImg.frame = CGRectMake((SCREEN_WIDTH-70)/2, 32, 70, 16);
//        } completion:^(BOOL finished) {
//            _annimationStatus1 = YES;
//        }];
//    }else{
//        [UIView transitionWithView:self.jkjzImg duration:0.4 options:0 animations:^{
//            weakSelf.jkjzImg.frame = CGRectMake((SCREEN_WIDTH-144)/2, 292, 144, 32);
//        } completion:^(BOOL finished) {
//            _annimationStatus1 = NO;
//        }];
//    }
//}

- (void)dealloc{
    ELog(@"......newFeature dealloc");
    _textViewBgArray = nil;
    _textImgBgArray = nil;
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

@interface NewFeatureTextView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;

@end

@implementation NewFeatureTextView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title subTitle:(NSString *)subTitle{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.titleLab.text = title;
        self.subTitleLab.text = subTitle;
    }
    return self;
}

- (void)setupUI{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:24.0f];
    self.titleLab.textColor = MKCOLOR_RGB(51, 51, 51);
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.textAlignment = NSTextAlignmentCenter;
    self.subTitleLab.font = [UIFont systemFontOfSize:14.0f];
    self.subTitleLab.textColor = MKCOLOR_RGB(118, 118, 118);
    self.subTitleLab.numberOfLines = 0;
    
    [self addSubview:_titleLab];
    [self addSubview:_subTitleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25);
        make.width.greaterThanOrEqualTo(@1);
        make.height.equalTo(@33);
    }];
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.height.greaterThanOrEqualTo(@1);
    }];
}

@end
