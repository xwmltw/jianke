//
//  TagView.h
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TagView;
@protocol TagDelegate <NSObject>

- (void)tagView:(TagView *)tagView didClickWithIndex:(NSUInteger)index;

@end

@interface TagView : UIView

//@property (nonatomic, strong) UIView* contenView;
@property (nonatomic, strong) NSMutableArray* btnsArray;

- (instancetype)initWithWidth:(CGFloat)width;
@property (nonatomic, assign) id <TagDelegate> deletage;

- (void)showTagsWithArray:(NSMutableArray*)tags;
- (void)showTagsWithArray:(NSMutableArray*)tags isEnable:(BOOL)isEnable;
- (void)showTagsWithArray:(NSMutableArray*)tags isEnable:(BOOL)isEnable isShowCloseIcon:(BOOL)isShowCloseIcon;

- (CGFloat)getTagViewHeight;

@end
