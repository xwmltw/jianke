//
//  XZOpenUrlHelper.h
//  jianke
//
//  Created by fire on 16/9/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZOpenUrlHelper : NSObject

/** m端跳原生 岗位详情页 */
+ (void)openJobDetailWithblock:(MKBlock)block;

/** 跳转web页面 */
+ (void)showNitifyOnWebWithUrl:(NSString *)url isAppOpen:(BOOL)isAppOpen;

@end
