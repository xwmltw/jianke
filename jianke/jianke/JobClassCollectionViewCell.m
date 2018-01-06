//
//  JobClassCollectionViewCell.m
//  jianke
//
//  Created by xiaomk on 16/1/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobClassCollectionViewCell.h"
#import "WDConst.h"

@implementation JobClassCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        
        self.labName = [[UILabel alloc] init];
        self.labName.textAlignment = NSTextAlignmentCenter;
        self.labName.font = [UIFont systemFontOfSize:16];
        self.labName.textColor = MKCOLOR_RGB(51, 51, 51);
        self.labName.numberOfLines = 1;
        self.labName.minimumScaleFactor = 8;
        self.labName.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.labName];
    }
    return self;
}
@end
