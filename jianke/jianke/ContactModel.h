//
//  ContactModel.h
//  jianke
//
//  Created by fire on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ContactModel : NSObject

//@property (nonatomic, assign) BOOL is_show_telphone; /*!< Boolean 类型，true表示公开，false表示不公开 */
@property (nonatomic, copy) NSString* phone_num; /*!< 手机号码 */
@property (nonatomic, copy) NSString* name;          // 联系人
@property (nonatomic, copy) NSString* address;
@end


/**
 “phone_num”: “xxxx”, // 手机号码
 “is_show_telphone”:  xxxx, // Boolean 类型，true表示公开，false表示不公开
*/