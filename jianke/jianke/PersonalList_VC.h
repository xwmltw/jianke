//
//  PersonalList_VC.h
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"
#import "MyEnum.h"

@interface PersonalList_VC : BottomViewControllerBase

@property (nonatomic, copy) NSNumber *cityId;

@property (nonatomic, copy) NSNumber *service_personal_job_id;  /*!< 个人服务订单Id */
@property (nonatomic, copy) NSNumber *service_type; /*!< 服务类型 第一版用的上面的枚举,但是发现不行,还是用这个属性好,有空把枚举替换为这个属性 */

@property (nonatomic, assign) BOOL isPopToPrevious;

@end
