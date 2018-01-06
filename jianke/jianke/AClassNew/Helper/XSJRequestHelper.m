//
//  XSJRequestHelper.m
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJRequestHelper.h"
#import "XSJConst.h"
#import <AdSupport/AdSupport.h>
#import "ResponseInfo.h"
#import "JobModel.h"
#import "PayDetailModel.h"
#import "NSString+XZExtension.h"
#import "WelcomeJoinJK_VC.h"

@interface XSJRequestHelper(){
    
}

@end

static ClientGlobalInfoRM *s_clientGlobalInfoModel = nil;   /*!< 全局配置信息 */

@implementation XSJRequestHelper

Impl_SharedInstance(XSJRequestHelper);

#pragma mark - ***** 网络端开后从新 连接上网络 ******
- (void)connectNetworkAgain{
    if (self.isLostNetwork) {
        self.isLostNetwork = NO;
        [self getClientGlobalInfoWithBlock:^(id result) {
            
        }];
    }
}



#pragma mark - ***** 自动登录 ******

- (void)activateAutoLoginWithBlock:(MKBlock)block{
    if (![[UserData sharedInstance] getIsLogoutActive] && ![[UserData sharedInstance] isLogin]) {
        [[XSJRequestHelper sharedInstance] autoLogin:^(ResponseInfo *result) {
            if (result) {
                NSString *trueName = [result.content objectForKey:@"true_name"];
                if (!trueName.length) {
                    [MKUIHelper getTopNavigationCtrl:^(UINavigationController *nav) {
                        WelcomeJoinJK_VC *viewCtrl = [[WelcomeJoinJK_VC alloc] init];
                        viewCtrl.isNotShowJobTrends = YES;
                        viewCtrl.hidesBottomBarWhenPushed = YES;
                        viewCtrl.block = ^(id result){
                            [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
                            [nav popToRootViewControllerAnimated:YES];
                            MKBlockExec(block, result);
                        };
                        [nav pushViewController:viewCtrl animated:YES];
                    }];
                }else{
                    MKBlockExec(block, result);
                }
            }else{
                MKBlockExec(block, result);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
}

- (void)autoLogin:(MKBlock)block{
    NSString *userName = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
    if (password && password.length > 0) {
        [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_commonPassword isShowNetworkErr:NO bolck:block];
    }else{
        NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].dynamicPassword;
        if (password && password.length > 0) {
            [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_dynamicPassword isShowNetworkErr:NO bolck:block];
        }else{
            MKBlockExec(block, nil);
        }
    }
}

- (void)loginWithUsername:(NSString*)userName pwd:(NSString*)password bolck:(MKBlock)block{
    [self loginWithUsername:userName pwd:password loginPwdType:LoginPwdType_commonPassword isShowNetworkErr:YES bolck:block];
}

- (void)loginWithUsername:(NSString*)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType bolck:(MKBlock)block{
    [self loginWithUsername:userName pwd:password loginPwdType:loginPwdType isShowNetworkErr:YES bolck:block];
}

- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType isShowNetworkErr:(BOOL)isShowNetworkErr bolck:(MKBlock)block{
    if (userName.length > 0 && password.length > 0) {
        NSNumber* loginType = [[UserData sharedInstance] getLoginType];
        if (loginType.intValue == 0) {
            loginType = [NSNumber numberWithInt:WDLoginType_JianKe];
        }
        
        UserLoginPM* model = [[UserLoginPM alloc] init];
        model.username = userName;
        model.user_type = loginType;
        
        if (loginPwdType == LoginPwdType_dynamicSmsCode) {          /*!< 动态验证码 */
            model.dynamic_sms_code = password;
        }else if (loginPwdType == LoginPwdType_dynamicPassword){    /*!< 动态密码 */
            NSString *pass = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
            model.dynamic_password = pass;
        }else if (loginPwdType == LoginPwdType_commonPassword){     /*!< 普通密码 */
            NSString *pass = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
            model.password = pass;
        }

        NSString* content = [model getContent];
        if ([UserData sharedInstance].registrationID.length) {
            content = [content stringByAppendingFormat:@", \"push_id\": \"%@\"", [UserData sharedInstance].registrationID];
        }
        
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_userLogin" andContent:content];
        request.isShowLoading = isShowNetworkErr;
        request.isShowErrorMsg = isShowNetworkErr;
        if (loginPwdType == LoginPwdType_dynamicSmsCode) {
            request.isShowErrorMsg = NO;
        }
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {
                if (isShowNetworkErr) {
                    [UIHelper toast:@"登录成功"];
                }
                [[UserData sharedInstance] setLoginStatus:YES];
                [[UserData sharedInstance] setLogoutActive:NO];
                NSNumber *userId = [response.content objectForKey:@"id"];
                [[UserData sharedInstance] setUserId:userId];
                [[UserData sharedInstance] setLoginType:loginType];
                
                if (loginPwdType == LoginPwdType_dynamicSmsCode) {          /*!< 动态验证码 */
                    NSString *dynamicPassword = [response.content objectForKey:@"dynamic_password"];
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:nil dynamicPassword:dynamicPassword];
                }else if (loginPwdType == LoginPwdType_commonPassword){
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:password dynamicPassword:nil];
                }else if (loginPwdType == LoginPwdType_dynamicPassword){
                    [[XSJUserInfoData sharedInstance] savePhone:userName password:nil dynamicPassword:password];
                }
                
                [TalkingDataAppCpa onLogin:userName];
                
                [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(id result) {
                    MKBlockExec(block, response);
                }];
            }else{
                if (loginPwdType == LoginPwdType_dynamicSmsCode && response ) {    //动态密码登录  用户不存在
                    if (response.errCode.integerValue == 8) {
                        MKBlockExec(block, response);
                        return ;
                    }else if (response.errCode.integerValue == 9){
                        [UIHelper toast:@"请输入正确的动态密码"];
                        return ;
                    }else{
                         [UIHelper toast:@"请输入正确的账号或动态密码"];
                        return;
                    }
                }else{
                    [UIHelper toast:@"请输入正确的账号或密码"];
                    return;
                }
                
                MKBlockExec(block, nil);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
}

#pragma mark - ***** 获取验证码 ******
//"opt_type" :  操作类型  , 1 注册 , 2 找回密码 , 3 修改手机号码  -- 注册 (1) 判断 是否已经被注册 , (2): 判断 号码是否存在 , (3): 判断 是否已经被注册 .
//"user_type" : 用户类型 ,  1:企业 ，2:学生 , --}

- (void)getAuthNumWithPhoneNum:(NSString*)phoneNum andBlock:(MKBlock)block withOPT:(WdVarifyCodeOptType)optType userType:(NSNumber*)userType{
    GetSmsAuthenticationCodePM* model = [[GetSmsAuthenticationCodePM alloc] init];
    model.phone_num = phoneNum;
    model.opt_type = optType;
    model.user_type = userType;
    NSString* content = [model getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getSmsAuthenticationCode" andContent:content];
    request.isShowLoading = YES;
    request.loadingMessage = @"获取验证码...";
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            MKBlockExec(block,nil);
        }
    }];
}

#pragma mark - ***** 获取全局配置信息 ******
- (void)getClientGlobalInfoWithBlock:(MKBlock)block{
    [self getClientGlobalInfoMust:NO withBlock:block];
}

- (void)getClientGlobalInfoMust:(BOOL)must withBlock:(MKBlock)block{
    if (!must && s_clientGlobalInfoModel) {
        block(s_clientGlobalInfoModel);
    }else{
        GetClientGlobalPM* model = [[GetClientGlobalPM alloc] init];
        model.city_id = [[UserData sharedInstance] city] ? [[UserData sharedInstance] city].id : @(211);
        model.client_type = [XSJUserInfoData getClientType];
        int versionInt = [MKDeviceHelper getAppIntVersion];
        model.app_version_code = @(versionInt);
        model.product_type = [XSJUserInfoData getProductType];
        
        NSString* content = [model getContent];
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getClientGlobalInfo" andContent:content];
        request.isShowLoading = NO;
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {
                ClientGlobalInfoRM* model = [ClientGlobalInfoRM objectWithKeyValues:response.content];
                if (model) {
                    s_clientGlobalInfoModel = model;
                    MKBlockExec(block,model)
                    return ;
                }
            }
            MKBlockExec(block,nil)
        }];
    }
}

- (ClientGlobalInfoRM*)getClientGlobalModel{
    if (s_clientGlobalInfoModel) {
        return s_clientGlobalInfoModel;
    }
    return nil;
}

static NSString* const XSJUserDefault_IDFA  = @"XSJUserDefault_IDFA";

/** 保存设备信息 */
- (void)postDeviceInfoWithBlock:(MKBlock)block{
    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfa = [UIDevice currentDevice].name;
    NSString *oldIDFA = [WDUserDefaults objectForKey:XSJUserDefault_IDFA];
    if (oldIDFA && [oldIDFA isEqualToString:idfaStr]) {
        MKBlockExec(block, @"1");
    }else{
        ActivateDeviceModel *model = [[ActivateDeviceModel alloc] init];
        model.system = [MKDeviceHelper getSysVersionString];
        model.uid = [UIDeviceHardware getUUID];
        model.dev_name = [MKDeviceHelper getPlatformString];
        model.idfa = idfaStr;
        
        NSString *content = [model getContent];
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postIosDevInfo" andContent:content];
        request.isShowLoading = NO;
        request.isShowErrorMsg = NO;
        [request sendRequestWithResponseBlock:^(id response) {
            if (response) {
                [WDUserDefaults setObject:idfaStr forKey:XSJUserDefault_IDFA];
                [WDUserDefaults synchronize];
                MKBlockExec(block, response);
            }else{
                MKBlockExec(block, nil);
            }
        }];
    }
}

/** 查询钱袋子账户信息 */
- (void)queryAccountMoneyWithBlock:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountMoney" andContent:@""];
    request.isShowLoading = NO;
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

/** 拨打免费电话 */
- (void)callFreePhoneWithCalled:(NSString *)called block:(MKBlock)block{
    FreeCallPM *model = [[FreeCallPM alloc] init];
    model.plat_type = @(1);
    model.caller = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    model.called = called;
    model.opt_type = @(0);
    NSString* content = [model getContent];
    
    WEAKSELF
    [self requestCallFreeWithContent:content block:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSNumber *leftTime = response.content[@"left_can_call"];
            if (leftTime.integerValue > 0) {
                NSString *msg = [NSString stringWithFormat:@"您剩余免费电话时间:%ld分钟",((leftTime.integerValue-1)/60)+1];
                DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"拨打电话" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"免费电话", @"直接拨打",@"取消",nil];
                [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        model.opt_type = @(1);
                        NSString *content2 = [model getContent];
                        [weakSelf requestCallFreeWithContent:content2 block:^(ResponseInfo* response) {
                            if (response && [response success]) {
                                NSNumber *isCanCall = response.content[@"is_can_call"];
                                if (isCanCall.integerValue == 1) {
                                    [UIHelper toast:@"开始拨号..."];
                                    return ;
                                }
                            }
                            [UIHelper toast:@"免费电话拨打失败"];
                            [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
                        }];
                    }else if (buttonIndex == 1){
                        [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
                    }
                }];
                return ;
            }
        }
        [[MKOpenUrlHelper sharedInstance] callWithPhone:called];
    }];
}

- (void)requestCallFreeWithContent:(NSString *)content block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_callFreePhone" andContent:content];
    request.isShowLoading = YES;
//    request.isShowNetworkErrorMsg = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

/** 雇主查询打卡请求接口 */
- (void)entQueryPunchRequestList:(EntQueryPunch *)punch block:(MKBlock)block{
    NSString *content = [punch getContent];
    RequestInfo *request=[[RequestInfo alloc] initWithService:@"shijianke_entQueryPunchRequestList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            PunchClockModel *result = [PunchClockModel objectWithKeyValues:response.content];
            MKBlockExec(block,result);
        }else{
            MKBlockExec(block,nil);
        }
    }];
}


/** 雇主发起点名接口 */
- (void)entIssuePunchRequest:(NSString *)job_id clockTime:(NSString *)date block:(MKBlock)block{
    NSString *contet = [NSString stringWithFormat:@"job_id:%@,punch_the_clock_time:%@",job_id,date];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entIssuePunchRequest" andContent:contet];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 雇主结束打卡接口 */
- (void)entClosePunchRequest:(NSString *)request_id block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"punch_the_clock_request_id:%@",request_id];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entClosePunchRequest" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}


/** 修改支付列表接口 */
- (void)entChangeSalaryUnConfirmStu:(NSString *)itemId withTel:(NSString *)telphone withTrueName:(NSString *)name block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"item_id\":\"%@\",\"telphone\":\"%@\",\"true_name\":\"%@\"",itemId,telphone,name];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entChangeSalaryUnConfirmStu" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block,response);
        }
    }];
}

/** 猜你喜欢接口 */
- (void)getJobListGuessYouLike:(GetJobLikeParam *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getJobListGuessYouLike" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            NSArray *jobList = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            MKBlockExec(block,jobList);
        }
    }];
}

/** 招聘余额接口 */
- (void)queryAcctVirtualDetailList:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctVirtualDetailList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                AcctVirtualResponseModel *acctVirtualList = [AcctVirtualResponseModel objectWithKeyValues:response.content];
                MKBlockExec(block,acctVirtualList);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}


/** 用户虚拟账户流水明细查询 */
- (void)queryAcctVirtualDetailItem:(DetailItmeParam *)param block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctVirtualDetailItem" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            if (block) {
                NSArray *result = [PayDetailModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"stu_list"]];
                MKBlockExec(block,result);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}

/** 兼客获取自己的最新认证信息 */
- (void)getLatestVerifyInfo:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getLatestVerifyInfo" andContent:nil];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                MKBlockExec(block,response);
            }
        }else{
            MKBlockExec(block,nil);
        }
    }];
}

/** 收藏岗位 */
- (void)collectJob:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@",jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_collectJob" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 取消收藏岗位 loading */
- (void)cancelCollectedJob:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@",jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelCollectedJob" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}


/** 取消收藏岗位 */
- (void)cancelCollectedJob:(NSString *)jobId block:(MKBlock)block{
    [self cancelCollectedJob:jobId isShowLoding:NO block:block];
}

/** 查询收藏岗位列表 */
- (void)getCollectedJobList:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [queryParam getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCollectedJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *result = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"parttime_job_list"]];
            MKBlockExec(block, result);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 账户交易流水查询 */
- (void)queryAccDetail:(QueryParamModel *)queryParam withJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"%@,job_id:%@",[queryParam getContent],jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctDetail_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 广告点击日志接口 */
- (void)queryAdClickLogRecordWithADId:(NSNumber *)AdId{
    NSString *content = [NSString stringWithFormat:@"ad_id:%@",AdId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_adClickLogRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        ELog(@" ad_id : %@",AdId);
    }];
}

/** 人脉王岗位推送开关 */
- (void)openSocialActivistJobPush:(NSString *)optType block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_openSocialActivistJobPush" andContent:[NSString stringWithFormat:@"opt_type:%@",optType]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }

    }];
}

/** 获取人脉王任务列表 */
- (void)getSocialActivistTaskList:(NSString *)inHistory queryParam:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"in_history\":\"%@\"",inHistory];
    if (param) {
        content = [NSString stringWithFormat:@"%@,%@",[param getContent], content];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_getSocialActivistTaskList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            SocialActivistTaskListModel *model = [SocialActivistTaskListModel objectWithKeyValues:response.content];
            MKBlockExec(block, model);
        }else{
            MKBlockExec(block, nil);
        }
        
    }];
}

/** 记录图文消息点击日志 */
- (void)graphicPushLogClickRecord:(NSString *)contentId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"content_id:%@",contentId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_graphicPushLogClickRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);        
    }];
}

/** 兼客联系岗位申请 */
- (void)postStuContactApplyJob:(NSString *)jobId resultType:(NSNumber *)resultType remark:(NSString *)remakr block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\", \"stu_contact_result_type\":\"%@\"", jobId, resultType];
    if (remakr) {
        content = [NSString stringWithFormat:@"%@, \"contact_remark\":\"%@\"", content, remakr];
    }
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuContactApplyJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
    
}

/** 查询电话联系岗位的兼客列表 */
- (void)queryContactApplyJobResumeList:(QueryParamModel *)queryParam jobId:(NSString *)jobId block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"%@, job_id:%@", [queryParam getContent], jobId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_queryContactApplyJobResumeList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 记录通知栏消息点击日志 */
- (void)noticeBoardPushLogClickRecord:(NSString *)messageId block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"message_id:%@", messageId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_noticeBoardPushLogClickRecord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 记录搜索关键字 */
- (void)recordSearchKeyWord:(NSString *)keyWord block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"key_word\":\"%@\"", keyWord];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_recordSearchKeyWord" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 查询增值服务列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_queryJobVasList" andContent:nil];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 雇主购买岗位增值服务 */
- (void)entRechargeJobVas:(NSString *)jobId totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, total_amount:%@, vas_order_type:%@, vas_order_vas_id:%@", jobId, totalAmount, orderType, orderId];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_entRechargeJobVas" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询岗位订阅增值服务信息 */
- (void)queryJobVasInfo:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobVasInfo" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客获取被邀约个人服务列表 */
- (void)stuQueryServicePersonalApplyJobListWithParam:(QueryParamModel *)queryParam inHistory:(NSNumber *)isHistory block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"in_history: %@", isHistory];
    if (isHistory) {
        content = [content stringByAppendingFormat:@", %@",  [queryParam getContent]];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuQueryServicePersonalApplyJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客处理个人服务邀约 */
- (void)stuDealWithServicePersonalJobApplyWithOptType:(NSNumber *)optType applyId:(NSNumber *)applyId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_apply_id:%@, opt_type:%@", applyId, optType];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuDealWithServicePersonalJobApply" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取个人服务需求详情 */
- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_id:%@", personaJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServicePersonalJobDetail" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取关注雇主列表 */
- (void)getFocusEntListWithQueryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    NSString *content = [queryParam getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getFocusEntList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 关注雇主 */
- (void)stuFocusEntWithAccountId:(NSNumber *)accountId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"ent_account_id: %@", [NSString stringNoneNullFromValue:accountId]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuFocusEnt" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 取消关注雇主 */
- (void)cancelFocusEntWithAccountId:(NSNumber *)accountId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"ent_account_id: %@", accountId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelFocusEnt" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取已申请的团队服务列表 */
- (void)queryServiceTeamApplyListWithEntID:(NSString *)entId status:(NSNumber *)status block:(MKBlock)block{
    NSString *content = nil;
    if (entId) {
        content = [NSString stringWithFormat:@"enterprise_id:%@", entId];
    }
    if (status) {
        content = content ? [NSString stringWithFormat:@"%@, status:%@", content, status] :[NSString stringWithFormat:@"status:%@", status];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryServiceTeamApplyList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取个人服务兼客列表 */
- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId orderType:(NSNumber *)orderType param:(QueryParamModel *)param block:(MKBlock)block{
    cityId = cityId ? cityId : @211 ;
    NSString *content = [NSString stringWithFormat:@"service_type:%@, city_id:%@, %@", serviceType, cityId ,[param getContent]];
    if (jobId) {
        content = [NSString stringWithFormat:@"%@, service_personal_job_id:%@", content, jobId];
    }
    if (orderType) {
        content = [NSString stringWithFormat:@"%@, order_type:%@", content, orderType];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getServicePersonalStuList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *result = [ServicePersonalStuModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_stu_list"]];
            MKBlockExec(block, result);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取个人服务兼客列表 */
- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId param:(QueryParamModel *)param block:(MKBlock)block{
    [self getServicePersonalStuList:serviceType cityId:cityId jobId:jobId orderType:nil param:param block:block];
}

/** 获取城市个人服务需求列表 */
- (void)queryServicePersonalJobListWithServiceType:(NSNumber *)serviceType cityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    cityId = cityId ? cityId : @211 ;
    NSString *content = [NSString stringWithFormat:@"service_type:%@, city_id:%@, %@", serviceType, cityId ,[queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryServicePersonalJobList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客报名个人服务需求 */
- (void)applyServicePersonalJobWithJobId:(NSNumber *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_personal_job_id:%@", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_applyServicePersonalJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 提交推送平台信息（极光推送） */
- (void)postThirdPushPlatInfo:(NSString *)push_id block:(MKBlock)block{
    NSNumber *accountType = @2;
    NSString *content = [NSString stringWithFormat:@"\"push_id\":\"%@\", \"account_type\":\"%@\"", push_id, accountType];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postThirdPushPlatInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}

/** 查询宅任务列表 */
- (void)queryZhaiTaskListWithCityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block{
    cityId = cityId ? cityId : @211;
    NSString *content = [NSString stringWithFormat:@"query_condition:{city_id: %@}, %@", cityId, [queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryZhaiTaskList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 查询服务类型申请信息 */
- (void)queryServiceApplyInfoWithServiceType:(NSNumber *)serviceType block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"service_type: %@", serviceType];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryServiceApplyInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 检测用户登陆状态 */
- (void)checkUserLogin:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_checkUserLogin" andContent:nil];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客查询普通岗位信息 */
- (void)queryJobListFromApp:(RequestParamWrapper *)param block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:[param getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客取消报名 */
- (void)cancelApplyJob:(NSNumber *)jobId reasonStr:(NSString *)reaseonStr block:(MKBlock)block{
    NSUInteger apply_job_id = jobId.unsignedIntegerValue;
    NSString *content = [NSString stringWithFormat:@"apply_job_id:%lu, stu_reciv_apply_reason:%@", (unsigned long)apply_job_id, [[reaseonStr dataUsingEncoding:NSUTF8StringEncoding] simpleJsonString]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelApplyJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客修改简历其他信息 */
- (void)postResumeOtherInfoWithDes:(NSString *)des isPublick:(NSNumber *)isPublick block:(MKBlock)block{
    NSString *content = @"";
    if (des) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@"\"desc\": \"%@\"", [NSString stringNoneNullFromValue:des]]];
    }
    if (isPublick) {
        if (content.length) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@", \"is_public\": \"%@\"", isPublick]];
        }else{
            content = [content stringByAppendingString:[NSString stringWithFormat:@"\"is_public\": \"%@\"", isPublick]];
        }
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postResumeOtherInfo" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客查询简历工作经历信息 */
- (void)queryResumeExperienceList:(BOOL)isShowLoading block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryResumeExperienceList" andContent:nil];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客提交简历工作经历信息 */
- (void)postResumeExperience:(ResumeExperienceModel *)model block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postResumeExperience" andContent:[model getContent]];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

/** 兼客删除简历工作经历信息 */
- (void)deleteResumeExperience:(NSNumber *)resumeId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"resume_experience_id\": \"%@\"", resumeId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_deleteResumeExperience" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
    }];
}

#pragma mark - ***** 弃用 ******
/** 获取广告,兼客头条,雇主头条 */
- (void)getAdvertisementListWithAdSiteId:(NSString *)adSiteId cityId:(NSString *)cityId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"ad_site_id:%@, city_id:%@", adSiteId, cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getAdvertisementList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}

@end


