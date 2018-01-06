//
//  NewsBtn.m
//  jianke
//
//  Created by fire on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "NewsBtn.h"
#import "UIView+MKExtension.h"
#import "JKHomeModel.h"

@implementation NewsBtn


- (instancetype)initWithModel:(AdModel *)aModel size:(CGSize)aSize
{
    if (self = [super init]) {
        
        self.model = aModel;
        self.width = aSize.width;
        self.height = aSize.height;
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setTitleColor:MKCOLOR_RGB(51, 51, 51) forState:UIControlStateNormal];
        [self setTitle:aModel.ad_name forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    return self;
}


- (void)setModel:(AdModel *)model
{
    _model = model;
    [self setTitle:model.ad_name forState:UIControlStateNormal];
}


@end
