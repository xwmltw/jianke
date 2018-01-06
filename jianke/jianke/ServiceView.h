//
//  ServiceView.h
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceView;
typedef NS_ENUM(NSInteger, ServiceBtnType) {
    ServiceBtnType_lady = 100,
    ServiceBtnType_teacher,
    ServiceBtnType_actor,
    ServiceBtnType_saler,
    ServiceBtnType_modal,
    ServiceBtnType_host
};

@protocol ServiceViewDelegate <NSObject>

- (void)serviceView:(ServiceView *)serviceView actionType:(ServiceBtnType)actionType;

@end

@interface ServiceView : UIView

@property (nonatomic, weak) id<ServiceViewDelegate> delegate;

@end
