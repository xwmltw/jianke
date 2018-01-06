//
//  XZTabBarCtrl.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZTabBarCtrl.h"

@interface XZTabBarCtrl ()

@end

@implementation XZTabBarCtrl

- (void)viewDidLoad {

    [super viewDidLoad];

    [self.view addSubview:self.customToolBar];
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
    UIButton *button = nil;
    for (NSInteger index = 0; index < self.toolBarTitles.count; index++) {
        button = [self createToolBarBtn:self.toolBarTitles[index]];
        button.tag = index;
        [_customToolBar addSubview:button];
        [self layoutToolBarBtns];
    }
    self.selectedIndex = 0;
}

- (UIButton *)createToolBarBtn:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button addTarget:self action:@selector(toolBarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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

#pragma mark - toolBar点击业务

- (void)toolBarBtnOnClick:(UIButton *)sender{
    self.selectedIndex = sender.tag;
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
    for (UIButton *button in self.customToolBar.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:MKCOLOR_RGBA(150, 150, 150, 0.88) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        }
    }
    if (selectedIndex < self.customToolBar.subviews.count) {
        UIButton *button = [self.customToolBar.subviews objectAtIndex:selectedIndex];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
}

- (void)setChildVCShowAtIndex:(NSInteger)index{
    NSArray *views = [self.childVCs valueForKey:@"view"];
    [views enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    UIView *view = [views objectAtIndex:index];
    view.hidden = NO;
}

- (BOOL)hasSelectedVCAtIndex:(NSInteger)index{
    UIViewController *vc = [self.childVCs objectAtIndex:index];
    return !([self.childViewControllers indexOfObject:vc] == NSNotFound);
}

@end
