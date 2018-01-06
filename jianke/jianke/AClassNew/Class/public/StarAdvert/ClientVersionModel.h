//
//  ClientVersionModel.h
//  jianke
//
//  Created by xiaomk on 16/3/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientVersionModel : NSObject
@property (nonatomic, copy) NSString* version;  //版本号
@property (nonatomic, copy) NSString* url;      //升级地址
@property (nonatomic, copy) NSString* need_force_update;    //是否强制升级 1是 0否
@end
