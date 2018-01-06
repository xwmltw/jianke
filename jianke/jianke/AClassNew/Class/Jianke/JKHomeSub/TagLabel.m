//
//  TagLabel.m
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "TagLabel.h"
#import "WDConst.h"

@implementation TagLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = MKCOLOR_RGB(255, 248, 225);
        self.textColor = MKCOLOR_RGB(121, 86, 73);
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.0f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MKCOLOR_RGBA(241, 231, 209,1).CGColor;
        
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    self.layer.cornerRadius = radius;
}

- (void)setText:(NSString *)text{
    super.text = text;
    
//    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+8, size.height+4);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




@implementation TagButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:MKCOLOR_RGB(121, 86, 71) forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"tagBG"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"tagBGChosen"] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(4, 8, 4, 8)];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 1.0f;
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = radius;
}

- (void)setText:(NSString *)text{
    [self setTitle:text forState:UIControlStateNormal];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+16, size.height+8);
}

- (void)setCloseIconAndText:(NSString *)text
{
    self.isShowCloseIcon = YES;
    [self setTitle:text forState:UIControlStateNormal];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [self setImage:[UIImage imageNamed:@"v230_close"] forState:UIControlStateNormal];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+16+19, size.height+8);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isShowCloseIcon) {
     
        CGRect titleFrame = self.titleLabel.frame;
        CGRect imageFrame = self.imageView.frame;
        
        titleFrame.origin.x = 10;
        imageFrame.origin.x = titleFrame.origin.x + titleFrame.size.width + 5;
        
        self.titleLabel.frame = titleFrame;
        self.imageView.frame = imageFrame;
    }
}

@end