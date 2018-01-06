//
//  ZBBannerView.h
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBBannerView;
@protocol ZBBannerViewDelegate <NSObject>

- (void)zbBannerView:(ZBBannerView *)bannerView btnOnClick:(NSInteger)index;

@end

@interface ZBBannerView : UIView

@property (nonatomic, weak) id<ZBBannerViewDelegate> delegate;

- (void)setModelArr:(NSArray *)arr;


@end
