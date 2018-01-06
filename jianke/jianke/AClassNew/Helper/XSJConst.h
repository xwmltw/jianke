//
//  XSJConst.h
//  jianke
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"
#import "UIButton+Extension.h"
#import "UIView+MKException.h"

#import "MKCategoryHead.h"
#import "MKAlertView.h"
#import "MKBlurView.h"
#import "MKActionSheet.h"
#import "MKOpenUrlHelper.h"
#import "MKDeviceHelper.h"

#import "XSJUIHelper.h"
#import "XSJRequestHelper.h"

#import "WDConst.h"
#import "XSJADHelper.h"


#define UIWindowLevel_custom        UIWindowLevelStatusBar - 1
#define UIWindowLevel_switchView    UIWindowLevelStatusBar + 9

#define Alert(_S_, ...) [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

