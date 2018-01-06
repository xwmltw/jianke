//
//  UIView+MKException.m
//  jianke
//
//  Created by xiaomk on 16/6/27.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "UIView+MKException.h"
#import "UIColor+Extension.h"
#import "UIView+MKExtension.h"

@implementation UIView(MKException)

- (void)addBorderInDirection:(BorderDirectionType)direction{
    [self addBorderInDirection:direction borderWidth:0.5 borderColor:[UIColor XSJColor_grayLine] isConstraint:YES];
}

- (void)addBorderInDirection:(BorderDirectionType)direction borderWidth:(CGFloat)width borderColor:(UIColor *)color isConstraint:(Boolean)isConstraint{
    if (isConstraint) {
        [self layoutIfNeeded];  //约束生效
    }
    if ((direction & BorderDirectionTypeTop) == BorderDirectionTypeTop) {
        [self addBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, width) color:color];
    }
    if ((direction & BorderDirectionTypeLeft) == BorderDirectionTypeLeft){
        [self addBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) color:color];
    }
    if ((direction & BorderDirectionTypeBottom) == BorderDirectionTypeBottom){
        [self addBorderWithFrame:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width) color:color];
    }
    if ((direction & BorderDirectionTypeRight) == BorderDirectionTypeRight){
        [self addBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) color:color];
    }
}

- (void)addBorderWithFrame:(CGRect)frame color:(UIColor *)color{
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = frame;
    borderLayer.backgroundColor = color.CGColor;
    [self.layer addSublayer:borderLayer];
}

- (void)setBorder{
    [self setBorderWidth:0.5 andColor:[UIColor XSJColor_grayLine]];
}

//@dynamic nodataView, noLoginView, noNetworkView;
//- (UIView *)nodataView{
//    if (!nodataView) {
//        nodataView = [[UIView alloc] initWithFrame:self.bounds];
//        nodataView.backgroundColor = [UIColor redColor];
//    }
//    return _nodataView;
//}
//
//- (UIView *)noNetworkView{
//    if (!self.noNetworkView) {
//        self.noNetworkView = [[UIView alloc] initWithFrame:self.bounds];
//        self.noNetworkView.backgroundColor = [UIColor greenColor];
//    }
//    return self.noNetworkView;
//}
//
//- (UIView *)noLoginView{
//    if (!self.noLoginView) {
//        self.noLoginView = [[UIView alloc] initWithFrame:self.bounds];
//        self.noLoginView.backgroundColor = [UIColor blueColor];
//    }
//    return self.noLoginView;
//}
@end
