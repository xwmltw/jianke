//
//  UICustomTextField.m
//  ShiJianKe
//
//  Created by 何仕德 on 15/3/11.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "WdTextField.h"
#import "WdTextFieldDelegate.h"

@interface WdTextField()
{
    WdTextFieldDelegate* _wd_delegate;
}

@end


@implementation WdTextField


- (void)awakeFromNib {
    _wd_delegate = [[WdTextFieldDelegate alloc] init];
    self.delegate=_wd_delegate;
}

@end
