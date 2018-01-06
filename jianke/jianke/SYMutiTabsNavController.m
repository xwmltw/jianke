//
//  SYMutiTabsNavController.m
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SYMutiTabsNavController.h"
#import "XSJConst.h"

@interface SYMutiTabsNavController () <UIScrollViewDelegate>

/**
 *  保存tabTitle的数组
 */
@property (nonatomic, strong, nullable) NSArray<NSString *> *tabTitles;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIScrollView *tabView;

@property (nonatomic, weak) UIView *tabLineView;

/**
 *  保存tab按钮的数组
 */
@property (nonatomic, strong) NSArray<UIButton *> *tabBtns;


@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  标记subController是否加载过数据
 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *subControllerLoadMarks;

@end

@implementation SYMutiTabsNavController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupFirstShow];
}


#pragma mark - 初始化方法
- (instancetype)initWithsubControllers:(NSArray <__kindof UIViewController<SYMutiTabsNavSubControllerDelegate> *> *)subControllers titleArray:(NSArray<NSString *> *)titleArray
{
    if (self = [super init]) {
        
        for (UIViewController *vc in subControllers) {
            [self addChildViewController:vc];
        }        
        
        self.tabTitles = titleArray;
        [self defaultSet];
    }
    
    return self;
}


- (instancetype)init
{
    __unused NSString *alertString = @"Please use \"- (instancetype)initWithsubControllers:\" instead!";
    NSAssert(0, alertString);
    return nil;
}

/**
 *  设置默认属性
 */
- (void)defaultSet
{
    self.tabTitleCountPerScreen = 3;
    
    self.tabTitleNormalColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];
    
    self.tabTitleHightlightColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    self.tabSelectLinecolor = [UIColor colorWithRed:238.0/255.0 green:255.0/255.0 blue:65.0/255.0 alpha:1.0];
    
    self.tabViewBackgroundColor = [UIColor XSJColor_blackBase];
    
    self.tabTitleFont = [UIFont systemFontOfSize:16];
    
    self.tabViewHeight = 36.0;
    
    self.tabDefaultSelectIndex = 0;

    self.dataDelayLoad = YES;
    
    self.reloadDateWhenShow = NO;
    
    self.currentIndex = self.tabDefaultSelectIndex;
    
    NSMutableArray *subControllerLoadMarks = [NSMutableArray array];
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *num = @(0);
        [subControllerLoadMarks addObject:num];
    }];
    
    self.subControllerLoadMarks = subControllerLoadMarks;
}


- (void)initUI
{
    
    // tabView
    CGRect tabViewFrame = self.view.bounds;
    tabViewFrame.size.height = self.tabViewHeight;
    CGFloat btnW = self.view.bounds.size.width / self.tabTitleCountPerScreen;
    
    UIScrollView *tabView = [[UIScrollView alloc] initWithFrame:tabViewFrame];
    tabView.contentSize = CGSizeMake(self.childViewControllers.count * btnW, tabViewFrame.size.height);
    tabView.backgroundColor = self.tabViewBackgroundColor;
    tabView.showsHorizontalScrollIndicator = NO;
    tabView.bounces = NO;
    tabView.scrollEnabled = NO;
    [self.view addSubview:tabView];
    self.tabView = tabView;
    
    // tabLineView
    CGRect tabLineViewFrame = CGRectZero;
    tabLineViewFrame.size = CGSizeMake(btnW, 3);
    tabLineViewFrame.origin = CGPointMake(0, tabViewFrame.size.height - tabLineViewFrame.size.height);
    
    UIView *tabLineView = [[UIView alloc] initWithFrame:tabLineViewFrame];
    tabLineView.backgroundColor = self.tabSelectLinecolor;
    [tabView addSubview:tabLineView];
    self.tabLineView = tabLineView;
    
    // tabBtn
    NSMutableArray *tabBtns = [NSMutableArray array];
    
    CGFloat btnY = 0;
    CGFloat btnH = self.tabViewHeight - self.tabLineView.bounds.size.height;
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat btnX = idx * btnW;
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [titleBtn setTitle:self.tabTitles[idx] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.tabTitleNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.tabTitleHightlightColor forState:UIControlStateDisabled];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.titleLabel.font = self.tabTitleFont;
        [tabView addSubview:titleBtn];
        [tabBtns addObject:titleBtn];

    }];
    
    self.tabBtns = tabBtns;
    
    CGFloat topH = [UIApplication sharedApplication].statusBarFrame.size.height;
    topH += self.navigationController.navigationBar.frame.size.height;
    
    // scrollerView
    CGRect scrollViewFrame = self.view.bounds;
    scrollViewFrame.size.height -= self.tabViewHeight + topH;
    scrollViewFrame.origin.y = self.tabViewHeight;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * self.childViewControllers.count, scrollView.bounds.size.height);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}


- (void)setupFirstShow
{
    
    if (self.dataDelayLoad) { // 每个subController显示的时候才获取数据
        
        [self updateBtnStateWithIndex:self.tabDefaultSelectIndex];
        [self updatePositionWithIndex:self.tabDefaultSelectIndex];
        
    } else { // 全部subController都获取数据
        
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj respondsToSelector:@selector(loadData)]) {
                [obj performSelector:@selector(loadData) withObject:nil];
            }
            
            self.subControllerLoadMarks[idx] = @(1);
        }];
        
                
        [self updateBtnStateWithIndex:self.tabDefaultSelectIndex];
        [self updatePositionWithIndex:self.tabDefaultSelectIndex];
    }
}

#pragma mark - 事件处理
- (void)titleBtnClick:(UIButton *)btn
{
    NSInteger index = [self.tabBtns indexOfObject:btn];
    
    [self updateBtnStateWithIndex:index];
    [self updatePositionWithIndex:index];
    
    // scrollView
    CGFloat scrollViewOffsetX = index * self.scrollView.bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(scrollViewOffsetX, 0);
    }];
}


- (void)updateBtnStateWithIndex:(NSInteger)index
{
    self.tabBtns[self.currentIndex].enabled = YES;
    self.currentIndex = index;
    self.tabBtns[self.currentIndex].enabled = NO;
}


- (void)updatePositionWithIndex:(NSInteger)index
{
    // 添加subControllerView
    CGFloat subControllerViewW = self.scrollView.bounds.size.width;
    CGFloat subControllerViewH = self.scrollView.bounds.size.height;
    CGFloat subControllerViewY = 0;
    CGFloat subControllerViewX = index * subControllerViewW;
    self.childViewControllers[index].view.frame = CGRectMake(subControllerViewX, subControllerViewY, subControllerViewW, subControllerViewH);
        
    [self.scrollView addSubview:self.childViewControllers[index].view];
    
    // 刷新subControllerView
    if (!self.subControllerLoadMarks[index].boolValue || self.reloadDateWhenShow) {
        
        if ([self.childViewControllers[index] respondsToSelector:@selector(loadData)]) {
            [self.childViewControllers[index] performSelector:@selector(loadData) withObject:nil];
        }
        
        self.subControllerLoadMarks[index] = @(1);
    }
    
    // tabLine
    UIButton *btn = self.tabBtns[index];
    [btn.titleLabel sizeToFit];
    CGRect bounds = self.tabLineView.bounds;
    CGFloat tabLineViewW = btn.titleLabel.bounds.size.width;
    bounds.size.width = tabLineViewW;

    CGPoint center = self.tabLineView.center;
    center.x = btn.center.x;
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
       
        weakSelf.tabLineView.bounds = bounds;
        weakSelf.tabLineView.center = center;
    }];
    
    // tabView
    index = index - (self.tabTitleCountPerScreen - 1);
    index = index >= 0 ? index : 0;
    CGFloat btnW = btn.bounds.size.width;
    CGFloat tabViewOffsetX = index * btnW;
    
    [UIView animateWithDuration:0.3 animations:^{       
        self.tabView.contentOffset = CGPointMake(tabViewOffsetX, 0);
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / self.scrollView.bounds.size.width + 0.5;
    
    [self updateBtnStateWithIndex:index];
    [self updatePositionWithIndex:index];
}

@end
