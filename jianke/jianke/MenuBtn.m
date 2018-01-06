//
//  MenuBtn.m
//  jianke
//
//  Created by fire on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MenuBtn.h"
#import "UIView+MKExtension.h"
#import "UIButton+WebCache.h"
#import "JKHomeModel.h"

const CGFloat kmarginBetweenImgAndTitle = 5;

@interface MenuBtn()

@property (nonatomic, assign) CGSize size;

@end

@implementation MenuBtn

- (instancetype)initWithModel:(MenuBtnModel *)model size:(CGSize)aSize{
    if (self = [super init]) {
        self.model = model;
        self.size = aSize;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.width = self.size.width;
    self.height = self.size.height;
    
    [self sd_setImageWithURL:[NSURL URLWithString:self.model.special_entry_icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"v231_menu_placehoder"]];
    [self setTitle:self.model.special_entry_title forState:UIControlStateNormal];
    [self setTitleColor:MKCOLOR_RGBA(0, 0, 0, 0.72) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 计算标题实际尺寸
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    attrDic[NSFontAttributeName] = self.titleLabel.font;
    CGRect titleRect = [self.currentTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    
    // 图片宽高
    CGFloat imageW = 46;
    CGFloat imageH = 46;
    
    // 标题宽高
    CGFloat titleW = titleRect.size.width;
    CGFloat titleH = titleRect.size.height;
    
    // 图片位置
    CGFloat imageX = (self.width - imageW) * 0.5;
    CGFloat imageY = (self.height - imageH - titleH - kmarginBetweenImgAndTitle) * 0.5;
    
    // 标题位置
    CGFloat titleX = (self.width - titleW) * 0.5;
    CGFloat titleY = imageH + imageY + kmarginBetweenImgAndTitle;
    
    // 设置标题及图片frame
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
}

@end
