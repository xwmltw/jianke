//
//  XHEmotionCollectionViewFlowLayout.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewFlowLayout.h"

#define kXHEmotionMinimumLineSpacing 10
#define kXHEmotionColumnCount 7
@implementation XHEmotionCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize);
        self.minimumLineSpacing = ([UIScreen mainScreen].bounds.size.width - kXHEmotionMinimumLineSpacing*2 - kXHEmotionImageViewSize*kXHEmotionColumnCount)/(kXHEmotionColumnCount - 1);
        self.sectionInset = UIEdgeInsetsMake(kXHEmotionMinimumLineSpacing/2, kXHEmotionMinimumLineSpacing, kXHEmotionMinimumLineSpacing/20, kXHEmotionMinimumLineSpacing);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

@end
