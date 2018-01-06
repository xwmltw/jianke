//
//  NewsView.h
//  jianke
//
//  Created by fire on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKNewsModel.h"
#import "NewsBtn.h"

@class NewsView, NewsBtn;

@protocol NewsViewDelegate <NSObject>

- (void)newsView:(NewsView *)aNewsView btnClick:(NewsBtn *)aBtn;

@end



@interface NewsView : UIView

- (instancetype)initWithNewsModelArray:(NSArray *)aModelArray size:(CGSize)aSize;
@property (nonatomic, weak) id<NewsViewDelegate> delegate;

@end
