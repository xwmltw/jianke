//
//  XZVideoTool.h
//  jianke
//
//  Created by yanqb on 2016/11/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XZVideoToolImageUrlKey @"XZVideoToolImageUrlKey"
#define XZVideoToolVideoUrlKey @"XZVideoToolVideoUrlKey"

@interface XZVideoTool : NSObject
+ (instancetype)sharedInstance;

- (void)uploadVideoOnVC:(UIViewController *)viewCtrl compeleteBlock:(MKBlock)competeBlock failBlock:(MKBlock)failBlock;

@end
