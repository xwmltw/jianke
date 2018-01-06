//
//  GCMCollectionViewCell.m
//  jianke
//
//  Created by xiaomk on 16/1/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "GCMCollectionViewCell.h"
#import "WDConst.h"

@implementation GCMCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.btnHead = [[UIButton alloc] init];
        [self addSubview:self.btnHead];
        
        self.labName = [[UILabel alloc] init];
        self.labName.textAlignment = NSTextAlignmentCenter;
        self.labName.numberOfLines = 1;
        self.labName.font = [UIFont systemFontOfSize:12];
        self.labName.textColor = [UIColor XSJColor_tGray];
        self.labName.minimumScaleFactor = 8;
        self.labName.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.labName];
        
        self.imgDelete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v260_icon_delete"]];
        [self addSubview:self.imgDelete];
    }
    return self;
}

@end
