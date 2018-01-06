//
//  GuideUIManager.h
//  jianke
//
//  Created by xiaomk on 16/6/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideUIType ) {
    GuideUIType_jobDetailBaozhao = 1,
    GuideUIType_jobDetailRMW,
    GuideUIType_EPHomeScrollAd,
};

@class GuideView;
typedef void(^GuideUIManagerBlock)(GuideView* guideView, id obj);

@interface GuideUIManager : NSObject
+ (void)showGuideWithType:(GuideUIType)type block:(GuideUIManagerBlock)block;
@end


@interface GuideView : UIView
- (instancetype)initWithType:(GuideUIType)type block:(GuideUIManagerBlock)block;
- (void)show;
@end



