//
//  TagLabel.h
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagLabel : UILabel

@end


@interface TagButton : UIButton

@property (nonatomic, assign) BOOL isShowCloseIcon;

- (void)setText:(NSString *)text;
- (void)setCloseIconAndText:(NSString *)text;
- (void)setRadius:(CGFloat)radius;
@end