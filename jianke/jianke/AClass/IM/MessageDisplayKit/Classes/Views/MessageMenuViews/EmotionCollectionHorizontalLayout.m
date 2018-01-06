//
//  EmotionCollectionHorizontalLayout.m
//  ShiJianKe
//
//  Created by hlw on 15/4/25.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "EmotionCollectionHorizontalLayout.h"
#import "XHEmotionManagerView.h"
#import "XHEmotion.h"

#define kXHEmotionMinimumLineSpacing 4


@implementation EmotionCollectionHorizontalLayout

///  返回内容大小，用于判断是否需要加快滑动

- (long)pageCount {

    return [self.collectionView numberOfSections];
}

-(CGSize)collectionViewContentSize
{
    float width = self.collectionView.frame.size.width * [self pageCount];
    return CGSizeMake(width, self.collectionView.frame.size.height);
}

//  返回YES，改变布局
// - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
// {
//     return YES;
// }

#pragma mark - UICollectionViewLayout
///  为每一个Item生成布局特性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    UICollectionView *collection = self.collectionView;
    
    long page = indexPath.section;

    CGSize size = collection.frame.size;
    
    float xMargin = 8;
    float xInterval = ((size.width - xMargin*2) - kXHEmotionPerRowItemCount * kXHEmotionImageViewSize)/ (kXHEmotionPerRowItemCount - 1);
    
    float x = page * size.width + xMargin + (kXHEmotionImageViewSize + xInterval) * (indexPath.item % kXHEmotionPerRowItemCount );
    float y = xMargin + (kXHEmotionImageViewSize + kXHEmotionMinimumLineSpacing) * (indexPath.item % EmotionPageCount / kXHEmotionPerRowItemCount );
    
    if (page + 1 == [self pageCount] && indexPath.item + 1 == [collection numberOfItemsInSection:page]) {
        //排在最后
        x = page * size.width + xMargin + (kXHEmotionImageViewSize + xInterval) * (kXHEmotionPerRowItemCount - 1);
    }
    
    attributes.center = CGPointMake(x + kXHEmotionImageViewSize/2, y + kXHEmotionImageViewSize/2);
    attributes.size = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize);
    
//    NSLog(@"indexPath.item=%ld,page=%ld,x=%f,y=%f,attributes.center.x=%f,attributes.center.y=%f", (long)indexPath.item, page, x, y,attributes.center.x, attributes.center.y);
    
    return attributes;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    if ([arr count] > 0) {
        return arr;
    }
    
    static NSMutableArray *attributes;
    if (attributes) {
        return attributes;
    }
    
    attributes = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger i = 0 ; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}




@end
