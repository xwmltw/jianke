//
//  XSJADHelper.h
//  jianke
//
//  Created by xiaomk on 16/8/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XSJADType){
    XSJADType_jobDetail = 1,
    XSJADType_homeJobList,
    XSJADType_applySuccess,
};


@interface XSJADHelper : NSObject

+ (BOOL)getAdIsShowWithType:(XSJADType)adType;

+ (void)closeAdWithADType:(XSJADType)adType;

+ (CGFloat)getHeightWithADType:(XSJADType)adType;

+ (void)clickAdWithADType:(XSJADType)adType withModel:(id)adModel currentVC:(UIViewController *)currentVC;

@end
