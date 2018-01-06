//
//  MyInfoCollect_cell3.m
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCollect_cell3.h"
#import "WDConst.h"

@interface MyInfoCollect_cell3 ()

@end

@implementation MyInfoCollect_cell3

- (UILabel *)labTitle{
    if (!_labTitle) {
        UILabel *label = [UILabel labelWithText:@"切换为雇主 >" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _labTitle = label;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _labTitle;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-16);
        }];
    }
    return _imageView;
}

@end
