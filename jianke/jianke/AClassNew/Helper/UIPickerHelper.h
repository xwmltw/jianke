//
//  UIPickerHelper.h
//  jianke
//
//  Created by xuzhi on 16/8/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPickerHelper : NSObject

+ (instancetype)sharedInstance;

- (void)presentImagePickerOnVC:(UIViewController *)viewCtrl sourceType:(UIImagePickerControllerSourceType)sourceType finish:(MKBlock)finishBlock;
- (void)presentImagePickerOnVC:(UIViewController *)viewCtrl sourceType:(UIImagePickerControllerSourceType)sourceType finish:(MKBlock)finishBlock cancel:(MKBlock)cancelBlock;

@end
