//
//  UploadCard_VC.h
//  jianke
//
//  Created by 时现 on 15/11/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"
#import "WDConst.h"

@interface UploadCard_VC : WDViewControllerBase

@property (nonatomic,strong)NSNumber *photo_type;//照片类型
@property (nonatomic, copy) MKBlock block;

@end
