//
//  MenuBtn.h
//  jianke
//
//  Created by fire on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuBtnModel;
@interface MenuBtn : UIButton

@property (nonatomic, strong) MenuBtnModel *model;

- (instancetype)initWithModel:(MenuBtnModel *)aModel size:(CGSize)aSize;

@end
