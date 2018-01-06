//
//  JKNewsModel.h
//  jianke
//
//  Created by fire on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JKNewsModel : NSObject

@property (nonatomic, copy) NSString *headline_content; /*!< 头条的标题 */
@property (nonatomic, copy) NSString *headline_url; /*!< 头条的url */

@property (nonatomic, strong) NSNumber *start_time; /*!< 开始时间毫秒数 */
@property (nonatomic, strong) NSNumber *end_time; /*!< 结束时间毫秒数 */

@end
