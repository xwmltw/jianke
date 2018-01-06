//
//  conditionBtnView.m
//  jianke
//
//  Created by fire on 15/11/20.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "conditionBtnView.h"
#import "UIView+MKExtension.h"

const CGFloat kPaddingH = 24;
const CGFloat kPaddingV = 10;
const CGFloat kBtnH = 20;
const CGFloat kMarginH = 16;
const CGFloat kMarginV = 18;

@interface conditionBtnView ()

@end

@implementation conditionBtnView

- (instancetype)initWithBtnArray:(NSArray *)btnArray width:(CGFloat)width
{

    if (self = [super init]) {
        
        // 报名限制
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"报名限制";
        titleLabel.x = 0;
        titleLabel.y = kMarginV;
        titleLabel.height = 20;
        titleLabel.width = 200;
        [self addSubview:titleLabel];
        
        // 条件
        for (UIButton *btn in btnArray) {
            [self setupBtn:btn];
        }
        
        CGFloat x = 0;
        CGFloat y = CGRectGetMaxY(titleLabel.frame) + kPaddingV;
        
        NSInteger count = btnArray.count;
        for (NSInteger i = 0; i < count; i++) {
            
            UIButton *btn = btnArray[i];
            
            if (x + btn.width + kPaddingH > width) {
                x = 0;
                y += btn.height + kPaddingV;
            }
            
            btn.x = x;
            btn.y = y;
            x += btn.width + kPaddingH;
            
            [self addSubview:btn];
        }
        
        self.x = kMarginH;
        self.y = 0;
        self.width = width;
        self.height = y + kPaddingV + kBtnH;
    }
    
    return self;
}


- (void)setupBtn:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"v230_circle"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:MKCOLOR_RGB(89, 89, 89) forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    CGSize maxSize = CGSizeMake(200, kBtnH);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    CGFloat width = [btn.currentTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width + 20;
    btn.width = width;
    btn.height = kBtnH;
}


@end
