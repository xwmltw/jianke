//
//  EQRMsgModel.h
//  jianke
//
//  Created by xiaomk on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamModel.h"

@interface EQRMsgModel : NSObject
@property (nonatomic, copy) NSArray* student_quick_reply;
@property (nonatomic, copy) NSArray* ent_quick_reply;
@end

@interface EQRSendMsgModel : ParamModel
@property (nonatomic, copy) NSString* data_content;
@property (nonatomic, copy) NSString* custom_info_type;
@end

