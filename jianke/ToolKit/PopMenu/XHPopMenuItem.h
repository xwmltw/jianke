//
//  XHPopMenuItem.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kXHMenuTableViewWidth 128
#define kXHMenuTableViewSapcing 0

#define kXHMenuItemViewHeight 40
#define kXHMenuItemViewImageSapcing 9
#define kXHSeparatorLineImageViewHeight 0.5


@interface XHPopMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)color;

@end
