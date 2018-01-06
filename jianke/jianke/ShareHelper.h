//
//  ShareHelper.h
//  jianke
//
//  Created by fire on 15/10/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  分享

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import "ShareInfoModel.h"
#import "RedBaoModel.h"


typedef NS_ENUM(NSInteger, ShareType) {
    
    ShareTypeInvitePerson,
    ShareTypeIMGroup,
    ShareTypeWechatSession,
    ShareTypeWechatTimeline,
    ShareTypeQQ,
    ShareTypeToQzone,
    ShareTypeSina
};

@interface ShareHelper : NSObject

@property (nonatomic,strong) ShareInfoModel * shareInfo;

+ (void)shareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info;

+ (void)customShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block;

+ (void)jobShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block;

+ (void)platFormShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block;

+ (void)shareRedBaoWith:(UIViewController *)vc info:(RedBaoModel *)info block:(MKBlock)block;
@end


@interface ShareCellModel : NSObject

@property (nonatomic, copy) NSString *shareName;
@property (nonatomic, copy) NSString *shareIcon;
@property (nonatomic, assign) ShareType type;

@end
