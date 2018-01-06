//
//  GuideCoverView.m
//  jianke
//
//  Created by fire on 15/12/1.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "GuideCoverView.h"
#import "UIView+MKExtension.h"
#import "WDConst.h"

@interface GuideCoverView ()

@property (nonatomic, weak) UIView *dotView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *msgLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *msgArray;
@property (nonatomic, copy) MKBlock block;
@property (nonatomic, strong) UIWindow *guideWindow;
@end


@implementation GuideCoverView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.index = 0;
        [self setupData];
        [self setupUI];
    }

    return self;
}


- (void)setupUI
{
    // 背景
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.5);

    // 左右滑动手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
    
    // 白色圆点
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(106, 5, 10, 10)];
    dotView.backgroundColor = [UIColor whiteColor];
    dotView.layer.cornerRadius = 5;
    dotView.layer.masksToBounds = YES;
    [self addSubview:dotView];
    self.dotView = dotView;
    
    // 白色线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(109, 15, 3, 200)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    
    // 白色矩形
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(16, 200, SCREEN_WIDTH - 32, 140)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 3;
    containerView.layer.masksToBounds = YES;
    [self addSubview:containerView];
    
    // 左右滑动手势
    UISwipeGestureRecognizer *containerViewLeftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    containerViewLeftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [containerView addGestureRecognizer:containerViewLeftSwipe];
    
    UISwipeGestureRecognizer *containerViewRightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    containerViewRightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [containerView addGestureRecognizer:containerViewRightSwipe];
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, containerView.width - 60, 20)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.text = self.titleArray.firstObject;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLab];
    self.titleLab = titleLab;
    
    
    // 消息
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, containerView.width - 80, 40)];
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.textColor = MKCOLOR_RGB(54, 54, 54);
    msgLabel.text = self.msgArray.firstObject;
    msgLabel.numberOfLines = 0;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:msgLabel];
    self.msgLabel = msgLabel;
    
    
    // 左边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"V230_chevron_left_0"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"V230_chevron_left_1"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:leftBtn];
    
    
    // 右边按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(containerView.width - 40, 50, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"V230_chevron_right_0"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"V230_chevron_right_1"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:rightBtn];
    
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((containerView.width - 80) * 0.5, 120, 80, 20)];
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl = pageControl;
    [containerView addSubview:pageControl];
    
}


- (void)setupData
{
    
    self.titleArray = @[@"返回顶部", @"兼客名片"];
    self.msgArray = @[@"浏览岗位时，点击时间条任意一处即可返回顶部。", @"兼客名片内容已全部收入头像按钮中。轻按头像即可查看。"];
}


- (void)showGuideWithBlock:(MKBlock)block
{
    DLog(@"xx======%lu", (unsigned long)[UIApplication sharedApplication].windows.count);
    
    _block = block;
    
    UIWindow *guideWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideWindow.windowLevel = UIWindowLevel_custom;
    [guideWindow makeKeyAndVisible];
    [guideWindow addSubview:self];
    self.guideWindow = guideWindow;
}

- (void)hideGuide{
    if (_block) {
        _block(nil);
    }
    [self.guideWindow resignKeyWindow];
    self.guideWindow = nil;
    [self removeFromSuperview];
}

- (void)leftBtnClick:(UIButton *)btn
{
    if (self.index > 0) {
        self.index--;
        [self changeShow];
    }
}

- (void)rightBtnClick:(UIButton *)btn
{
    if (self.index < 1) {
        
        self.index++;
        [self changeShow];
        
    } else {
        
        [self hideGuide];
    }
}

- (void)changeShow
{
    self.pageControl.currentPage = self.index;
    self.titleLab.text = self.titleArray[self.index];
    self.msgLabel.text = self.msgArray[self.index];
    
    
    switch (self.index) {
        case 0:
        {
            self.dotView.frame = CGRectMake(106, 5, 10, 10);
            self.lineView.frame = CGRectMake(109, 15, 3, 200);
            if (self.block) {
                self.block(@(0));
            }
        }
            break;
            
        case 1:
        {
            self.dotView.frame = CGRectMake(36, 70, 10, 10);
            self.lineView.frame = CGRectMake(39, 80, 3, 150);
            if (self.block) {
                self.block(@(1));
            }
        }
            break;
            
//        case 2:
//        {
//            self.dotView.frame = CGRectMake(SCREEN_WIDTH - 130, 40, 10, 10);
//            self.lineView.frame = CGRectMake(SCREEN_WIDTH - 126, 50, 3, 100);
//        }
//            break;
//            
//        case 3:
//        {
//            self.dotView.frame = CGRectMake(SCREEN_WIDTH - 45, SCREEN_HEIGHT - 55, 10, 10);
//            self.lineView.frame = CGRectMake(SCREEN_WIDTH - 41, 290, 3, SCREEN_HEIGHT - 335);
//        }
//            break;
    }
}



- (void)swipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self rightBtnClick:nil];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leftBtnClick:nil];
    }
}

@end
