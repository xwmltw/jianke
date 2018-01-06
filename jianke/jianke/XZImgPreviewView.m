//
//  XZImgPreviewView.m
//  jianke
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZImgPreviewView.h"
#import "UIView+MKExtension.h"
#import "UIImageView+WebCache.h"
#import "UIHelper.h"
#import "Masonry.h"

#define ImageViewH 200

@interface XZImgPreviewView () <UIScrollViewDelegate>{
    NSMutableArray *_imageViewArr;
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, weak) UIPageControl *pageCtrl;
@property (nonatomic, assign) showType showType;
@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XZImgPreviewView

- (instancetype)initWithFrame:(CGRect)frame WithImaArr:(NSArray *)imgArr{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViewArr =  [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        self.imgArr = [imgArr valueForKey:@"image"];
        [self setupViews];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

+ (void)showViewWithArray:(NSArray<UIImageView *> *)imgArr beginWithIndex:(NSInteger)index{
    XZImgPreviewView *preView = [self showViewWithArray:imgArr beginWithIndex:index showType:showType_default];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [preView showWithIndex:index];
}

+ (instancetype)showViewWithArray:(NSArray<UIImageView *> *)imgArr beginWithIndex:(NSInteger)index showType:(showType)showType{
    
    XZImgPreviewView *preView = [[XZImgPreviewView alloc] initWithFrame:SCREEN_BOUNDS WithImaArr:imgArr];
    preView.index = index;
    preView.showType = showType;
    if (showType == showType_delete) {
        preView.btn.hidden = NO;
    }
    preView.currentIndex = index;
    preView.oldFrame = [[imgArr objectAtIndex:index] convertRect:[imgArr objectAtIndex:index].bounds toView:preView];
    return preView;
}

- (void)setupViews{
    //uiscrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    scrollView.contentSize = CGSizeMake(self.width * self.imgArr.count, self.height - 1);
    scrollView.pagingEnabled = YES;
    
    _scrollView = scrollView;
    UIImageView *imageView = nil;
    for (NSInteger index = 0; index < self.imgArr.count; index++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * index, (self.height - ImageViewH) / 2, self.width, ImageViewH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = self.imgArr[index];
        [scrollView addSubview:imageView];
        [_imageViewArr addObject:imageView];
    }
    [self addSubview:scrollView];
}

- (void)showWithIndex:(NSInteger)index{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (self.imgArr.count > 1) {
        self.scrollView.delegate = self;
        
        //pagectrl
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        pageCtrl.numberOfPages = self.imgArr.count;
        pageCtrl.currentPage = index;
        pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
        pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageCtrl = pageCtrl;
        [self addSubview:pageCtrl];
        [pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.equalTo(@1);
            make.bottom.equalTo(self).offset(-30);
        }];
    }
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    
    UIImageView *imageView = [_imageViewArr objectAtIndex:index];
    CGRect tmpFrame = self.oldFrame;
    tmpFrame.origin = CGPointMake(SCREEN_WIDTH * index + tmpFrame.origin.x, tmpFrame.origin.y);
    self.oldFrame = tmpFrame;
    imageView.frame = self.oldFrame;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = CGRectMake(self.width * index, (self.height - ImageViewH) / 2, self.width, ImageViewH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    [self showWithIndex:self.index];
}

- (void)dismiss{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        MKBlockExec(self.dismissBlock, nil);
        [self removeFromSuperview];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    [self dismiss];
}

- (void)layoutContent{
    
}

#pragma mark - lazy
- (UIButton *)btn{
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"v324_delete_icon_white"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _btn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(36);
            make.right.equalTo(self).offset(-16);
        }];
    }
    return _btn;
}

- (void)btnOnClick:(UIButton *)sender{
    MKBlockExec(self.deleteBlock, self, self.currentIndex);
//    [self deleteImgWithIndex:self.currentIndex];
}

- (void)deleteImgWithIndex:(NSInteger)index{
    if (index >= self.imgArr.count) {
        return;
    }
    
    if (self.imgArr.count > 1) {
        
        if (self.currentIndex != 0 && (self.currentIndex + 1) >= self.imgArr.count) {
            self.currentIndex--;
        }
        
        NSMutableArray *tmpArr = [self.imgArr mutableCopy];
        [tmpArr removeObjectAtIndex:index];
        self.imgArr = [tmpArr copy];
        self.pageCtrl.numberOfPages = self.imgArr.count;
        
        UIImageView *imgView = [_imageViewArr objectAtIndex:index];
        [imgView removeFromSuperview];
        [_imageViewArr removeObjectAtIndex:index];
        
        [self.scrollView setContentSize:CGSizeMake(self.width * self.imgArr.count,  self.height - 1)];
        
        [_imageViewArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= index) {
                [UIView animateWithDuration:0.2f animations:^{
                   obj.x -= self.width;
                }];
            }
        }];
        
    }else{
        [self dismiss];
    }
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageCtrl.currentPage = currentPage;
    self.currentIndex = currentPage;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
