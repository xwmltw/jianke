//
//  XSJEditQuickReplyView.h
//  jianke
//
//  Created by xiaomk on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSJEditQuickReplyDelegate <NSObject>

@optional
/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)eqr_didSelecteMsg:(NSString*)msg;
- (void)eqr_btnEditOnclick;

@end

@interface XSJEditQuickReplyView : UIView

@property (nonatomic, strong) NSArray* msgArray;
@property (nonatomic, assign) id <XSJEditQuickReplyDelegate> delegate;

- (void)refreshWithData;

@end
