//
//  XZNotifyView.h
//  jianke
//
//  Created by xuzhi on 16/9/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZNotifyView : UIView

@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *url;

/**
 *  @decription 具有单击跳转web页面的伪造通知栏
 *  @warning    如果url为nil时，不具备跳转web页面功能
 *  @param  content 通知内容
 *  @param  url 跳转链接
 */
+ (void)showWithContent:(NSString *)content url:(NSString *)url;

/**
 *  @decription 带点击事件的伪造通知栏
 *  @warning    
 *  @param content  显示内容
 *  @param clickBlock   点击通知栏回调
 */
+ (void)showWithContent:(NSString *)content clickBlock:(MKBlock)clickBlock;


/**
 *  @decription 带点击事件的伪造通知栏
 *  @warning    当url不为nil时，点击通知栏自带跳转web页面功能
 *  @param  content 通知内容
 *  @param  url 跳转链接
 *  @param  clickBlock  点击通知栏回调
 */

+ (void)showWithContent:(NSString *)content url:(NSString *)url clickBlock:(MKBlock)clickBlock;

/**
 *  @decription 带各种事件的伪造通知栏
 *  @warning    当url不为nil时，点击通知栏自带跳转web页面功能
 *  @param  content 通知内容
 *  @param  url 跳转链接
 *  @param  didShowBlock    通知栏显示完成回调
 *  @param  clickBlock  点击通知栏回调(这玩意不就是为了web跳转用么？如果url不为nil，block也不为nil时，不冲突么？当然不冲突，已经作了处理，那么该功能基本可以不用于跳转web页了，可以用它坐一些事件点击统计等用处了)
 *  @param  dismissBlock    通知栏消失后回调
 */

+ (void)showWithContent:(NSString *)content url:(NSString *)url didShowBlock:(MKBlock)didShowBlock clickBlock:(MKBlock)clickBlock dismissBlock:(MKBlock)dismissBlock;

@end
