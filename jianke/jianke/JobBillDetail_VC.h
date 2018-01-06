//
//  JobBillDetail_VC.h
//  jianke
//
//  Created by 时现 on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface JobBillDetail_VC : WDViewControllerBase

@property (nonatomic, copy) NSNumber *job_id;           /*!< 岗位id */
@property (nonatomic, copy) NSNumber *isAccurateJob;    /*!< 是否为精确岗位 */
@property (nonatomic, copy) NSNumber *bill_status;      /*!< 账单状态，非必填 */

@property (nonatomic, assign) BOOL isFromPay;           /*!< 是否是支付完成过来的 */
@end
