//
//  MenuView.m
//  jianke
//
//  Created by fire on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MenuView.h"
#import "MenuBtn.h"
#import "JKHomeModel.h"
#import "UIView+MKExtension.h"

const NSInteger kMenuColsPerRow = 4;    // 每行几列
const CGFloat kMenuPaddingV = 0;        // 垂直内边距
const CGFloat kMenuPaddingH = 0;        // 水平内边距
const CGFloat kMenuBtnMarginV = 0;      // 按钮垂直间距
const CGFloat kMenuBtnMarginH = 0;      // 按钮水平间距


@interface MenuView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation MenuView

- (instancetype)initWithModelArray:(NSArray *)modelArray{
    if (self = [super init]) {
        
        
        self.modelArray = [NSMutableArray arrayWithArray:modelArray];
        
        [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0 || idx == 2) {
                [self.modelArray removeObject:obj];
            }
            
        }];
//        self.backgroundColor = COLOR_RGB(233, 233, 233);
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

- (void)setup{
    if (!self.modelArray.count) {
        return;
    }    
    
    // 行数 & 列数 & 页数
    NSInteger rows = self.modelArray.count > kMenuColsPerRow ? 2 : 1;
    NSInteger cols = kMenuColsPerRow;
    NSInteger pages = (self.modelArray.count-1)/(2 * cols) + 1;
    
    // 每个按钮宽高
    CGFloat btnW = (SCREEN_WIDTH - 2 * kMenuPaddingH) / cols;
    CGFloat btnH = btnW;
    
    // 菜单尺寸
    CGFloat menuW = SCREEN_WIDTH;
    CGFloat menuH = kMenuPaddingV * 2 + rows * btnH + (rows - 1) * kMenuBtnMarginV;
    self.frame = CGRectMake(0, 0, menuW, menuH);
    
    // scrollView
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(pages * self.scrollView.width, self.scrollView.height);
    [self addSubview:self.scrollView];
    
    // pageControl
    self.pageControl.centerX = self.width * 0.5;
    self.pageControl.y = self.height - self.pageControl.height;
    self.pageControl.numberOfPages = pages;
    [self addSubview:self.pageControl];
    
    // 按钮
    NSInteger count = self.modelArray.count;
    for (NSInteger i = 0; i < count; i++) {
        
        NSInteger col = i % cols; // 当前是第几列
        NSInteger row = (i / cols) % rows; // 当前是第几行
        NSInteger page = i / (rows * cols); // 当前是第几页
        
        CGFloat btnX = page * menuW + kMenuPaddingH + col * (btnW + kMenuBtnMarginH);
        CGFloat btnY = kMenuPaddingV + row * (btnH + kMenuBtnMarginV);
        
        MenuBtnModel *model = self.modelArray[i];
        MenuBtn *btn = [[MenuBtn alloc] initWithModel:model size:CGSizeMake(btnW, btnH)];
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.x = btnX;
        btn.y = btnY;
        [self.scrollView addSubview:btn];
    }
    
    // 底部的线
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.height - 0.5, self.scrollView.width, 0.5)];
//    line.backgroundColor = MKCOLOR_RGB(220, 220, 220);
//    [self.scrollView addSubview:line];
}


//- (void)updateMenuWithModelArray:(NSArray*)modelArray{
//    [self.modelArray removeAllObjects];
//    [self.modelArray addObjectsFromArray:modelArray];
//    [self setup];
//}

/** 按钮点击 */
- (void)menuBtnClick:(MenuBtn *)btn{
    DLog(@"menuBtnClick");
    if ([self.delegate respondsToSelector:@selector(menuView:didClickBtn:)]) {
        [self.delegate menuView:self didClickBtn:btn];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;    
    CGFloat pageDouble = offsetX / scrollView.width;
    NSInteger pageInt = (NSInteger)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}


@end
