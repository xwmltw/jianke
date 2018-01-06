//
//  XSJADHelper.m
//  jianke
//
//  Created by xiaomk on 16/8/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJADHelper.h"
#import "XSJConst.h"
#import "WebView_VC.h"
#import "JobDetail_VC.h"
#import "TopicJobList_VC.h"
#import "ZBHome_VC.h"


static NSString* const WDUserDefault_baiduSSPBanner     = @"WDUserDefault_baiduSSPBanner";
static NSString* const WDUserDefault_ssp_homeJobList     = @"WDUserDefault_ssp_homeJobList";
static NSString* const WDUserDefault_ssp_applySuccess     = @"WDUserDefault_ssp_applySuccess";


@implementation XSJADHelper

+ (BOOL)getAdIsShowWithType:(XSJADType)adType{
    ClientGlobalInfoRM *globalModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];

    NSString* SSPCloseDate;
    
    if (adType == XSJADType_jobDetail) {
        if (!globalModel.bottom_job_detail_ad) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_baiduSSPBanner];
    }else if (adType == XSJADType_homeJobList){
        if (globalModel && globalModel.ad_on_off.job_list_third_party_ad_open.integerValue != 1) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_ssp_homeJobList];
        return NO;      //产品那边还没 申请到ssp 数据流的广告，先默认关闭；
    }else if (adType == XSJADType_applySuccess){
        if (!globalModel.bottom_apply_success_ad) {
            return NO;
        }
        SSPCloseDate = [WDUserDefaults stringForKey:WDUserDefault_ssp_applySuccess];
    }
    
    long long time = [DateHelper getTimeStamp4Second];
    NSString* todayDate = [DateHelper getDateFromTimeString:[NSString stringWithFormat:@"%lld",time]];
    BOOL ret = ![SSPCloseDate isEqualToString:todayDate];
    return ret;
}

+ (void)closeAdWithADType:(XSJADType)adType{

    long long time = [DateHelper getTimeStamp4Second];
    NSString* todayDate = [DateHelper getDateFromTimeString:[NSString stringWithFormat:@"%lld",time]];
    if (adType == XSJADType_jobDetail) {
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_baiduSSPBanner];
    }else if (adType == XSJADType_homeJobList){
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_ssp_homeJobList];
    }else if (adType == XSJADType_applySuccess){
        [WDUserDefaults setObject:todayDate forKey:WDUserDefault_ssp_applySuccess];
    }
    [WDUserDefaults synchronize];
}

+ (CGFloat)getHeightWithADType:(XSJADType)adType{
    switch (adType) {
        case XSJADType_jobDetail:
        case XSJADType_applySuccess:{
            CGFloat bannerH = SCREEN_WIDTH*(160.00/750.00);
            return bannerH;
        }
            break;
        default:
            return SCREEN_WIDTH*(160.00/750.00);
            break;
    }
}

+ (void)clickAdWithADType:(XSJADType)adType withModel:(id)adModel currentVC:(UIViewController *)currentVC{
    if (!adModel) {
        return;
    }
    switch (adType) {
        case XSJADType_jobDetail:
        case XSJADType_applySuccess:{
            [self hadelModel:adModel supportZB:YES block:^(UIViewController *vc) {
                if (vc) {
                    [currentVC.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;
        default:
            break;
    }
}

+ (void)hadelModel:(AdModel *)model supportZB:(BOOL)isSupportZB block:(MKBlock)block{
    switch (model.ad_type.intValue) {
        case 1:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
//            if (isSupportZB && [model.ad_detail_url rangeOfString:@"zhongbao.shijianke"].location != NSNotFound) {
//                ZBHome_VC *viewCtrl = [[ZBHome_VC alloc] init];
//                viewCtrl.isnotBelongsTabBar = YES;
//                viewCtrl.hidesBottomBarWhenPushed = YES;
//                MKBlockExec(block, viewCtrl);
//                return;
//            }
            model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = model.ad_detail_url;
            vc.title = model.ad_name;
            vc.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, vc);
        }
            break;
        case 2:{
            if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                return;
            }
            //进入岗位详情
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
            vc.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, vc);
        }
            break;
        case 3:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
        }
            break;
        case 4:{
            TopicJobList_VC *vc = [[TopicJobList_VC alloc] init];
            vc.adDetailId = model.ad_detail_id.stringValue;
            vc.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, vc);
        }
            break;
        default:
            break;
    }
}

@end
