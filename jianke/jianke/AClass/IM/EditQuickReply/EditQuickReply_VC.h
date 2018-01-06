//
//  EditQuickReply_VC.h
//  jianke
//
//  Created by xiaomk on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"
#import "EQRMsgModel.h"

typedef NS_ENUM(NSInteger, EQRUpdateType) {
    EQRUpdateType_Add = 1,
    EQRUpdateType_Del   = 2,
    EQRUpdateType_Update  = 3,
    EQRUpdateType_Move  = 4
};

@interface EditQuickReply_VC : WDViewControllerBase

@end
