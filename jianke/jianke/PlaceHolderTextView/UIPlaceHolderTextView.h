//
//  UIPlaceHolderTextView.h
//  ShiJianKe
//
//  Created by hlw on 15/2/13.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDConst.h"

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic,assign) NSInteger maxLength;
- (void)textChanged:(NSNotification*)notification;

//编辑中  执行的block代码
@property (nonatomic,strong) WdBlock_Id block;
@end
