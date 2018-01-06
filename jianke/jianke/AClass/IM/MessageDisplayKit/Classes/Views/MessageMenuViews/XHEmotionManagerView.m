//
//  XHEmotionManagerView.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionManagerView.h"

#import "XHEmotionSectionBar.h"

#import "XHEmotionCollectionViewCell.h"
#import "XHEmotionCollectionViewFlowLayout.h"
#import "EmotionCollectionHorizontalLayout.h"


@interface XHEmotionManagerView () <UICollectionViewDelegate, UICollectionViewDataSource, XHEmotionSectionBarDelegate>

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;

/**
 *  管理多种类别gif表情的滚动试图
 */
@property (nonatomic, weak) XHEmotionSectionBar *emotionSectionBar;

/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  配置默认控件
 */
- (void)setup;

@end

@implementation XHEmotionManagerView

- (void)reloadData {
    NSInteger numberOfEmotionManagers = [self.dataSource numberOfEmotionManagers];
    if (!numberOfEmotionManagers) {
        return ;
    }
    
    self.emotionSectionBar.emotionManagers = [self.dataSource emotionManagersAtManager];
    [self.emotionSectionBar reloadData];
    
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    NSInteger numberOfEmotions = emotionManager.emotions.count;
    self.emotionPageControl.numberOfPages = (numberOfEmotions / (kXHEmotionPerRowItemCount * 4) + (numberOfEmotions % (kXHEmotionPerRowItemCount * 4) ? 1 : 0));
    
    [self.emotionCollectionView reloadData];
}

#pragma mark - Life cycle

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    self.isShowEmotionStoreButton = YES;
    
    if (!_emotionCollectionView) {
        CGFloat xMargin = 0;
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(xMargin, 0, CGRectGetWidth(self.bounds) - xMargin*2, CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - kXHEmotionSectionBarHeight) collectionViewLayout:[[EmotionCollectionHorizontalLayout alloc] init]];
        emotionCollectionView.backgroundColor = self.backgroundColor;
//        emotionCollectionView.backgroundColor = [UIColor greenColor];
        [emotionCollectionView registerClass:[XHEmotionCollectionViewCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = YES;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;

        [self addSubview:emotionCollectionView];
        self.emotionCollectionView = emotionCollectionView;
    }
    
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame), CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = self.backgroundColor;
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
//    if (!_emotionSectionBar) {
//        XHEmotionSectionBar *emotionSectionBar = [[XHEmotionSectionBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPageControl.frame), CGRectGetWidth(self.bounds), kXHEmotionSectionBarHeight) showEmotionStoreButton:self.isShowEmotionStoreButton];
//        emotionSectionBar.delegate = self;
//        emotionSectionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        emotionSectionBar.backgroundColor = [UIColor colorWithWhite:0.886 alpha:1.000];
//        [self addSubview:emotionSectionBar];
//        self.emotionSectionBar = emotionSectionBar;
//    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionPageControl = nil;
    self.emotionSectionBar = nil;
    self.emotionCollectionView.delegate = nil;
    self.emotionCollectionView.dataSource = nil;
    self.emotionCollectionView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - XHEmotionSectionBar Delegate

- (void)didSelecteEmotionManager:(XHEmotionManager *)emotionManager atSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotionBar:)]) {
        [self.delegate didSelecteEmotionBar:section];
    }
//    self.selectedIndex = section;
//    self.emotionPageControl.currentPage = 0;
//    [self reloadData];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emotionPageControl.numberOfPages;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    NSInteger count = emotionManager.emotions.count;
    
    if ((section+1)*EmotionPageCount < count) {
        return EmotionPageCount;
    }
    
    return count - EmotionPageCount*section;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    long index = indexPath.section * EmotionPageCount + indexPath.row;
    cell.emotion = emotionManager.emotions[index];
    
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:atIndexPath:)]) {
//        XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:indexPath.section];
        XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:0];
        long index = indexPath.section * EmotionPageCount + indexPath.row;
        [self.delegate didSelecteEmotion:emotionManager.emotions[index] atIndexPath:indexPath];
    }
}

@end
