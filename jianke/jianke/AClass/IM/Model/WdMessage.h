//
//  WdMessage.h
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"

@class RCMessage;

@interface WdMessage : XHMessage

@property (nonatomic, strong) RCMessage* rcMsg;
@property (nonatomic, assign) BOOL bShowTimeLine;
@property (nonatomic, assign) BOOL bShowUserName;
@property (nonatomic, assign) BOOL bIsGroupManagerOwner; /*!< 是否是群主 */
@property (nonatomic, assign) BOOL bIsGroupManagerBD; /*!< 是否是BD */
@end
