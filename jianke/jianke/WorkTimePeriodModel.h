//
//  WorkTimePeriodModel.h
//  jianke
//
//  Created by fire on 15/11/6.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WorkTimePeriodModel : NSObject

@property (nonatomic, strong) NSNumber *f_start; /*!<  <long>第一段开始时间的毫秒数 */
@property (nonatomic, strong) NSNumber *f_end; /*!< 第一段结束时间的毫秒数 */

@property (nonatomic, strong) NSNumber *s_start; /*!< 第二段开始时间的毫秒数 */
@property (nonatomic, strong) NSNumber *s_end; /*!< 第二段结束时间的毫秒数 */

@property (nonatomic, strong) NSNumber *t_start; /*!< 第三段开始时间的毫秒数 */
@property (nonatomic, strong) NSNumber *t_end; /*!< 第三段结束时间的毫秒数 */

@end
