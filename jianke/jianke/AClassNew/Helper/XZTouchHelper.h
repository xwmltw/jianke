//
//  XZTouchHelper.h
//  jianke
//
//  Created by yanqb on 2017/3/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UITouchActionType) {
    UITouchActionType_allParttimeJob, //全部兼职页面
    UITouchActionType_zhongbao, //众包页面
    UITouchActionType_weekendParttimeJob,    //周末兼职
    UITouchActionType_shortTermParttimeJob,  //短期兼职
    UITouchActionType_findNotice,   //找通告
};

@interface XZTouchHelper : NSObject

+ (void)openWithApplicationcutItem:(UIApplicationShortcutItem *)shortcutItem;

@end
