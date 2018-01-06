//
//  QrCodeViewController.h
//  jianke
//
//  Created by fire on 15/11/9.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface QrCodeViewController : WDViewControllerBase

@property (nonatomic, strong) NSString *qrCode; /*!< 二维码内容 */
@property (nonatomic, strong) NSNumber *expireTime; /*!< 二维码过期时间的毫秒数，3分钟就是 3*60 * 1000 */
@property (nonatomic, copy) NSString *jobId;

@end
