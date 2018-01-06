//
//  JobRefreshBackFooter.m
//  jianke
//
//  Created by fire on 15/12/29.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobRefreshBackFooter.h"

@interface JobRefreshBackFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *arrow;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation JobRefreshBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = MJRefreshColor(180, 180, 180);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // logo
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v240_arrow_up"]];
    arrow.contentMode = UIViewContentModeCenter;
    [self addSubview:arrow];
    self.arrow = arrow;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    
    self.arrow.bounds = CGRectMake(0, 10, self.bounds.size.width, 20);
    self.arrow.center = CGPointMake(self.bounds.size.width * 0.5, 20);
    self.label.frame = CGRectMake(0, 30, self.bounds.size.width, 20);
    self.loading.center = self.arrow.center;
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            if (oldState == MJRefreshStateRefreshing) {
                self.arrow.transform = CGAffineTransformIdentity;
                
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.loading.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                    if (self.state != MJRefreshStateIdle) return;
                    
                    self.label.text = @"继续拉,浏览下一个";
                    self.loading.alpha = 1.0;
                    [self.loading stopAnimating];
                    self.arrow.hidden = NO;
                }];
            } else {
                self.label.text = @"继续拉,浏览下一个";
                [self.loading stopAnimating];
                self.arrow.hidden = NO;
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrow.transform = CGAffineTransformIdentity;
                }];
            }
        }
            break;
        case MJRefreshStatePulling:
        {
            self.arrow.hidden = NO;
            [self.loading stopAnimating];
            self.label.text = @"松开吧";
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, M_PI);
            }];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.label.text = @"加载数据中";
            self.loading.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
            [self.loading startAnimating];
            self.arrow.hidden = YES;            
        }
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.label.text = @"木有数据了";
        default:
            break;
    }
}

@end
