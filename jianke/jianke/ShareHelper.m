//
//  ShareHelper.m
//  jianke
//
//  Created by fire on 15/10/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  分享

#import "ShareHelper.h"
#import "UserData.h"
#import "WDConst.h"
#import "SDWebImageManager.h"

@implementation ShareHelper

+ (void)shareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info{
   
    [UMSocialConfig setSnsPlatformNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSms]];
    
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:nil
                                      shareText:info.share_content
                                     shareImage:[UIImage imageNamed:@"main_icon_logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline, nil]
                                       delegate:nil];
    
    [UMSocialData defaultData].extConfig.qqData.title = info.share_title;
    [UMSocialData defaultData].extConfig.qzoneData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = info.share_title;
    
    NSString* shareUrl = [info.share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    
}


+ (void)customShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block{
    DLog(@"xxxxx");
    
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"InvitePerson"];
    snsPlatform.displayName = @"人才库";
    snsPlatform.bigImageName = @"v210_wjj3";
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        DLog(@"分享到人才库");
        MKBlockExec(block, nil);
    };
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    [UMSocialConfig setSnsPlatformNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSms, @"InvitePerson"]];
    
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:nil
                                      shareText:info.share_content
                                     shareImage:[UIImage imageNamed:@"main_icon_logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline, @"InvitePerson", nil]
                                       delegate:nil];
    
    [UMSocialData defaultData].extConfig.qzoneData.title = info.share_title;
    [UMSocialData defaultData].extConfig.qqData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = info.share_title;
    
    NSString* shareUrl = [info.share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
}
//红包分享
+ (void)shareRedBaoWith:(UIViewController *)vc info:(RedBaoModel *)info block:(MKBlock)block{
    
    if (!info) {
        return;
    }
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = info.red_packets_activity_title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = info.job_title;
    NSString* shareUrl = [info.red_packets_share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
        ShareCellModel *model = [[ShareCellModel alloc] init];
        model.type = ShareTypeWechatTimeline;
        model.shareName = @"朋友圈";
        model.shareIcon = @"v240_wechatTimeline";
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    
        WEAKSELF
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"分享至:" objArray:@[model] titleKey:@"shareName"];
        [sheet setImageKey:@"shareIcon" imageValueType:MKActionSheetButtonImageValueType_name];
        sheet.maxShowButtonCount = 5.6;
    
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {

            [weakSelf postShareToRedBao:UMShareToWechatTimeline info:info vc:vc block:block];
        
        }];
    

    
    
}
+ (void)postShareToRedBao:(NSString *)snsPlatform info:(RedBaoModel *)info vc:(UIViewController *)vc block:(MKBlock)block{
    id image;
    
    if (info.red_packets_share_img_url && info.red_packets_share_img_url.length) {
        image = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.red_packets_share_img_url]];
    }else{
        image = [UIImage imageNamed:@"main_icon_logo"];
    }
    UMSocialUrlResource* resource = [[UMSocialUrlResource alloc]init];
    resource.url =info.red_packets_share_url;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsPlatform] content:info.job_title image:image location:nil urlResource:resource presentedController:vc completion:^(UMSocialResponseEntity *response){
         ELog(@"UM response %u",response.responseCode);
        if (response.responseCode == UMSResponseCodeSuccess) {
            MKBlockExec(block,nil);
            [UIHelper toast:@"分享成功"];
        }
    }];
}



+ (void)jobShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block{
    NSArray *snsPlatformArray;
    if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer) {
        snsPlatformArray = @[@(ShareTypeInvitePerson), @(ShareTypeIMGroup), @(ShareTypeWechatSession), @(ShareTypeWechatTimeline), @(ShareTypeQQ), @(ShareTypeToQzone),@(ShareTypeSina)];
    }else{
        snsPlatformArray = @[@(ShareTypeWechatSession), @(ShareTypeWechatTimeline), @(ShareTypeQQ), @(ShareTypeToQzone),@(ShareTypeSina)];
    }
    [self shareWithSnsArray:snsPlatformArray vc:vc info:info block:block];
    
}


+ (void)platFormShareWithVc:(UIViewController *)vc info:(ShareInfoModel *)info block:(MKBlock)block{
    NSArray *snsPlatformArray = @[@(ShareTypeWechatSession), @(ShareTypeWechatTimeline), @(ShareTypeQQ), @(ShareTypeToQzone),@(ShareTypeSina)];
    [self shareWithSnsArray:snsPlatformArray vc:vc info:info block:block];
}


+ (void)shareWithSnsArray:(NSArray *)aSnsArray vc:(UIViewController *)vc info:(ShareInfoModel *)info1 block:(MKBlock)block{
    if (!info1) {
        return;
    }
    ShareInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:info1]];
    [UMSocialData defaultData].extConfig.qqData.title = info.share_title;
    [UMSocialData defaultData].extConfig.qzoneData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = info.share_title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = info.share_title;
    
    NSString* shareUrl = [info.share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    
    NSMutableArray *shareArray = [[NSMutableArray alloc] init];
    for (NSNumber *snsType in aSnsArray) {
        ShareCellModel *model = [[ShareCellModel alloc] init];
        model.type = snsType.integerValue;
        
        switch (snsType.integerValue) {
            case ShareTypeToQzone:{
                model.shareName = @"QQ空间";
                model.shareIcon = @"v240_qzone";
            }
                break;
            case ShareTypeQQ:{
                model.shareName = @"QQ";
                model.shareIcon = @"v240_qq";
            }
                break;
            case ShareTypeWechatTimeline:{
                model.shareName = @"朋友圈";
                model.shareIcon = @"v240_wechatTimeline";
            }
                break;
            case ShareTypeWechatSession:{
                model.shareName = @"微信好友";
                model.shareIcon = @"v240_wechatSession";
            }
                break;
            case ShareTypeSina:{
                model.shareName = @"微博";
                model.shareIcon = @"v240_sina";
            }
                break;
            case ShareTypeIMGroup:{
                model.shareName = @"群组";
                model.shareIcon = @"v240_group";
            }
                break;
            case ShareTypeInvitePerson:{
                model.shareName = @"人才库";
                model.shareIcon = @"v240_invitePerson";
            }
                break;
            default:
                break;
        }
        
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            if (snsType.integerValue == ShareTypeWechatSession || snsType.integerValue == ShareTypeWechatTimeline) {
                continue;
            }
        }
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            if (snsType.integerValue == ShareTypeQQ || snsType.integerValue == ShareTypeToQzone) {
                continue;
            }
        }
        [shareArray addObject:model];
    }
    WEAKSELF
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"分享至:" objArray:shareArray titleKey:@"shareName"];
    [sheet setImageKey:@"shareIcon" imageValueType:MKActionSheetButtonImageValueType_name];
    sheet.maxShowButtonCount = 5.6;
    [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        ShareCellModel *model = [shareArray objectAtIndex:buttonIndex];
        MKBlockExec(block, @(model.type));
        switch (model.type) {
            case ShareTypeInvitePerson:
            case ShareTypeIMGroup:
                break;
            case ShareTypeWechatSession:{
                [weakSelf postShareToSns:UMShareToWechatSession info:info vc:vc];
            }
                break;
            case ShareTypeWechatTimeline:{
                [weakSelf postShareToSns:UMShareToWechatTimeline info:info vc:vc];
            }
                break;
            case ShareTypeQQ:{
                [weakSelf postShareToSns:UMShareToQQ info:info vc:vc];
            }
                break;
            case ShareTypeToQzone:{
                [weakSelf postShareToSns:UMShareToQzone info:info vc:vc];
            }
                break;
            case ShareTypeSina:{
                if (info.share_url.length > 0) {
                    info.share_content = [info.share_content stringByAppendingString:info.share_url];
                }
                [weakSelf postShareToSns:UMShareToSina info:info vc:vc];
            }
                break;
            default:
                break;
        }
    }];
}


+ (void)postShareToSns:(NSString *)snsPlatform info:(ShareInfoModel *)info vc:(UIViewController *)vc{
    id image;
    if (info.share_img_url && info.share_img_url.length) {
        image = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.share_img_url]];
    }else{
        image = [UIImage imageNamed:@"main_icon_logo"];
    }
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsPlatform] content:info.share_content image:image location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
        ELog(@"UM response %u",response.responseCode);
        if (response.responseCode == UMSResponseCodeSuccess) {
            [UIHelper toast:@"分享成功"];
        }
    }];
}

@end


@implementation ShareCellModel
@end
