//
//  UserData.m
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "UserData.h"
#import "SSKeychain.h"
#import "WDCache.h"
#import "JKModel.h"
#import "EPModel.h"
#import "camellia.h"
#import "WDConst.h"
#import "JobClassifierModel.h"
#import "JobDetailModel.h"
#import "JobQAInfoModel.h"
#import "GrabJobClassModel.h"
#import "JobTopicModel.h"
#import "IdentityCardAuth_VC.h"
#import "ImDataManager.h"
#import "IMGroupModel.h"
#import "IMGroupDetailModel.h"
#import "JKHomeModel.h"
#import "ClientVersionModel.h"
#import "TalkingDataAppCpa.h"
#import "ClientGlobalInfoRM.h"
#import "XSJRequestHelper.h"
#import "UIDeviceHardware.h"
#import "WebView_VC.h"
#import "ZhaiTaskModel.h"
#import "RedBaoModel.h"

@interface UserData(){
    BOOL _isFirstLogin;         //是否第一次登录
    NSNumber* _loginType;       //登录类型
    BOOL _loginStatus;          //是否登录
    NSString* _tureName;        //真名
    NSString* _identity;        //身份证

    
    //IM 快捷回复
    EQRMsgModel* _eqrMsgModel;
}

@property (nonatomic, copy) NSNumber* userId;       //账号ID
@property (nonatomic, copy) NSString* userPhone;    //用户电话 账号
@property (nonatomic, copy) NSString* password;     //用户密码



@end

@implementation UserData
Impl_SharedInstance(UserData);

static ClientGlobalInfoRM *s_clientGlobalInfoModel = nil;   /*!< 全局配置信息 */

static JKModel *s_jkModel = nil; /*!< 兼客模型 */
static EPModel *s_epModel = nil; /*!< 雇主模型 */


static LocalModel *_local; /** 定位信息 */
static CityModel *_city; /*!< 当前选择的城市 */
static NSString *_jobListMD5; /** 岗位分类MD5 */
static NSArray *_jobList; /** 岗位分类 */

static NSString *_grabJobClassListMD5; /*!< 当前城市岗位分类MD5 */
static NSArray *_grabJobClassList; /*!< 当前城市岗位分类数组 */

static NSString *_jobTopicListMD5; /*!< 专题列表MD5 */
static NSArray *_jobTopicList; /*!< 专题列表数组 */

static NSArray *s_jobTagList; /*!< 岗位福利列表 */






+ (NSString*)getMoneyFormatWithNum:(NSNumber*)num{
    if (num.intValue > 0) {
        return [NSString stringWithFormat:@"+%.2f",((CGFloat)num.intValue)/100];
    }else{
        return [NSString stringWithFormat:@"%.2f",((CGFloat)num.intValue)/100];
    }
}



+ (void)delayTask:(float)time onTimeEnd:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}




#pragma mark - 单例方法
//======================================
- (instancetype)init{
    _loginStatus = NO;
    _isFirstLogin = YES;
    _isUpdateWithEPHome = NO;
    _loginType = [WDUserDefaults objectForKey:WdUserDefault_UserLoginType];
    if (!_loginType) {
        _loginType = [NSNumber numberWithInteger:WDLoginType_JianKe];
        [WDUserDefaults setObject:_loginType forKey:WdUserDefault_UserLoginType];
        [WDUserDefaults synchronize];
        ELog(@"===init loginType");
    }
    
    return self;
}





// 控制仅显示一次相关方法
// 分期乐
- (void)setIsYetShowFenQLAlertView:(BOOL)isYetShow{
    [WDUserDefaults setBool:YES forKey:@"WDUserDefaults_FenQiLe"];
    [WDUserDefaults synchronize];
}
- (BOOL)getIsYetShowFenQLAlertView{
    return [WDUserDefaults boolForKey:@"WDUserDefaults_FenQiLe"];
}

- (void)setIsHasOpen:(BOOL)isHasOpen{
    [WDUserDefaults setBool:isHasOpen forKey:WDUserDefault_isFirstOpenWithNotify];
    [WDUserDefaults synchronize];
}
- (BOOL)getIsHasOpen{
    return [WDUserDefaults boolForKey:WDUserDefault_isFirstOpenWithNotify];
}

- (BOOL)isHasOpenYet{
    return [WDUserDefaults boolForKey:[NSString stringWithFormat:@"isFirstOpenByKizy"]];
}

- (void)setHasOpenYet{
    if (![self isLogin]) {
        [self setLogoutActive:YES];
    }
    [WDUserDefaults setBool:YES forKey:@"isFirstOpenByKizy"];
    [WDUserDefaults synchronize];
}

/** 是否是VIP城市 */
- (BOOL)isEnableVipService{
    return (self.city.enableVipService.integerValue == 1);
}

/** 是否是开通直通车城市 */
- (BOOL)isEnableThroughService{
    return (self.city.enableThroughService.integerValue == 1);
}

//==========================用户数据

- (BOOL)isFirstLogin{
    return _isFirstLogin;
}

- (void)setFirstLoginStatusToNO{
    _isFirstLogin = NO;
}

//====获取用户登录状态
/** 是否可以自动登录 */
- (void)getUserStatus:(StatusBlock)statusBlock{
    if ([[UserData sharedInstance] isLogin]) {
        MKBlockExec(statusBlock, UserLoginStatus_loginSuccess);
    }else{
        if (![[UserData sharedInstance] isHasOpenYet]) {    //当app第一次安装时，getIsLogoutActive是为NO的，所以需要强制给它赋值为YES（登出状态）
            [[UserData sharedInstance] setHasOpenYet];
        }
        if (![[UserData sharedInstance] getIsLogoutActive]) {
            MKBlockExec(statusBlock, UserLoginStatus_canAutoLogin);
        }else{
            MKBlockExec(statusBlock, UserLoginStatus_needManualLogin);
        }
    }
}



//====退出登录调用方法
- (void)loginOutUpdateData{
    [[UserData sharedInstance] setLoginStatus:NO];
    [[UserData sharedInstance] setLogoutActive:YES];
    _eqrMsgModel = nil;
    
}

- (void)setLogoutActive:(BOOL)isActive{
    [WDUserDefaults setBool:isActive forKey:WDUserDefault_isLogoutActive];
    [WDUserDefaults synchronize];
}

- (BOOL)getIsLogoutActive{
    return [WDUserDefaults boolForKey:WDUserDefault_isLogoutActive];
}




- (BOOL)isLogin{
    return _loginStatus;
}

- (void)setLoginStatus:(BOOL)bStatus{
    _loginStatus = bStatus;
}

- (void)userIsLogin:(BOOL)isShowGuide block:(MKBlock)block{
    if (_loginStatus) {
        block(_loginType);
    }else{
        [MKAlertView alertWithTitle:@"登录提示" message:@"您还没有登录唷~请登录解锁更多惊喜!" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [UIHelper showLoginVC:isShowGuide withBlock:block];
            }
        }];
    }
}

- (void)userIsLogin:(MKBlock)block{
    [self userIsLogin:NO block:block];
}


- (BOOL)getUserImNoticeQuietState
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", UserImNoticeQuietStateKey, [self getUserId]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (void)setUserImNoticeQuietState:(BOOL)isQuiet
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", UserImNoticeQuietStateKey, [self getUserId]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isQuiet forKey:key];
    [userDefaults synchronize];
}


- (BOOL)getUserHideHelpState
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%ld", UserImHideHelpViewKey, [self getUserId], (long)[self getLoginType].integerValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}


- (void)setUserHideHelpState:(BOOL)isShow
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%ld", UserImHideHelpViewKey, [self getUserId], (long)[self getLoginType].integerValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:key];
    [userDefaults synchronize];
}


- (BOOL)getEpHideNewsViewStateWithAdId:(NSNumber *)adId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@", EPHideNewsViewKey, [self getUserId], adId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (void)setEpHideNewsViewState:(BOOL)isShow adId:(NSNumber *)adId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@", EPHideNewsViewKey, [self getUserId], adId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:key];
    [userDefaults synchronize];
}

- (void)setLoginType:(NSNumber *)loginType{
    _loginType = loginType;
    [WDUserDefaults setObject:loginType forKey:WdUserDefault_UserLoginType];
    [WDUserDefaults synchronize];
}

- (NSNumber*)getLoginType{
    if (!_loginType) {
        _loginType = [WDUserDefaults objectForKey:WdUserDefault_UserLoginType];
    }
    return _loginType;
}




- (void)setUserId:(NSNumber*)userId{
    _userId = userId;
}

- (NSNumber*)getUserId{
    return _userId;
}


- (void)setUserTureName:(NSString*)tureName{
    _tureName = tureName;
    [WDUserDefaults setObject:tureName forKey:WDUserDefaults_TureName];
    [WDUserDefaults synchronize];
}
- (NSString*)getUserTureName{
    if (!_tureName) {
        _tureName = [WDUserDefaults stringForKey:WDUserDefaults_TureName];
    }
    return _tureName;
}

- (void)setUserIdentity:(NSString*)identity{
    _identity = identity;
    [WDUserDefaults setObject:identity forKey:WDUserDefaults_Identity];
    [WDUserDefaults synchronize];
}

- (NSString*)getUserIdentity{
    if (!_identity) {
        _identity = [WDUserDefaults stringForKey:WDUserDefaults_Identity];
    }
    return _identity;
}


/** 保存当前城市 */
- (void)setCity:(CityModel *)city{
    _city = city;
    
    // 保存沙盒
    [WDCache saveCacheToFile:city fileName:UserDefault_sjk_cityInfo];
}

/** 获取当前城市 */
- (CityModel *)city{
    if (_city) {
        return _city;
    }
    
    _city = [WDCache getCacheFromFile:UserDefault_sjk_cityInfo withClass:[CityModel class]];    
    return _city;
}



/** 保存用户定位信息 */
- (void)setLocal:(LocalModel *)local{
    ELog(@"========保存定位城市到沙盒===");
    _local = local;
    
    // 保存定位信息到沙盒
    [WDCache saveCacheToFile:local fileName:UserDefault_sjk_localInfo];
}

/** 获取用户定位信息 */
- (LocalModel *)local{
    if (_local) {
        return _local;
    }
    _local = [WDCache getCacheFromFile:UserDefault_sjk_localInfo withClass:[LocalModel class]];
    return _local;
}




#pragma mark - 请求各种数据====================
- (void)initUserDataWithJkModel:(JKModel*) model{
    ELog("=====初始化 jk userdata 数据");
    [self setUserId:model.account_id];
    [self setUserTureName:model.true_name ? model.true_name : @""];
    [self setUserIdentity:model.id_card_no];
}

- (void)initUserDataWithEpModel:(EPModel *)model{
    ELog("=====初始化 ep userdata 数据");
    [self setUserId:model.account_id];
    [self setUserTureName:model.true_name ? model.true_name : @""];
    [self setUserIdentity:model.id_card_no];
}


- (JKModel*)getJkModelFromHave{
    return s_jkModel;
}

- (EPModel*)getEpModelFromHave{
    return s_epModel;
}


- (void)saveJKModel:(JKModel*)jkmodel{
    if (jkmodel) {
        s_jkModel = jkmodel;
    }
}

- (void)saveEPModel:(EPModel*)epmodel{
    if (epmodel) {
        s_epModel = epmodel;
    }
}

/** 是否订阅了兼职意向 */
- (BOOL)isSubscribedJob{
    return (s_jkModel.is_subscribe_job.integerValue == 1);
}

/** 获取兼客简历 */
- (void)getJKModelWithBlock:(MKBlock)block{
//    if (s_jkModel) {
//        block(s_jkModel);
//    } else {
        [self getJKModelWithContent:@"" block:block];
//    }
}

- (void)getJKModelWithAccountId:(NSString*)accountId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"account_id\":\"%@\"", accountId];
    [self getJKModelWithContent:content block:block];
}

/** 获取指定用户简历 */
- (void)getJKModelWithResumeId:(NSString *)resumeId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"resume_id:\"%@\"", resumeId];
    [self getJKModelWithContent:content block:block];
}

/** 向服务端请求简历 */
- (void)getJKModelWithContent:(NSString *)content block:(MKBlock)block{
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getResumeDetail" andContent:content];
    request.isShowLoading = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        JKModel *model = nil;
        if (response && response.success) {
            model = [JKModel objectWithKeyValues:response.content];
            if ([content isEqualToString:@""] || content == nil) { // 请求自己的简历
                s_jkModel = model;
                [[UserData sharedInstance] initUserDataWithJkModel:s_jkModel];   //保存初始化 用户信息
            }
        }
        MKBlockExec(block, model);
    }];
}

/** 获取雇主信息 */
- (void)getEPModelWithBlock:(MKBlock)block{
//    if (s_epModel) {
//        block(s_epModel);
//    } else {
        [self getEPModelWithContent:@"" block:block];
//    }
}

- (void)getEPModelWithEpAccount:(NSString*)account block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"account_id\":\"%@\"", account];
    [self getEPModelWithContent:content block:block];
}

/** 获取指定雇主的信息 */
- (void)getEPModelWithEpid:(NSString *)epid block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"enterprise_id:%@", epid];
    [self getEPModelWithContent:content block:block];
}

/** 向服务器请求雇主信息 */
- (void)getEPModelWithContent:(NSString *)content block:(MKBlock)block{
    RequestInfo *info = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseBasicInfo" andContent:content];
    info.isShowLoading = NO;
    info.loadingMessage = @"数据加载中...";
    [info sendRequestWithResponseBlock:^(ResponseInfo *response) {
        EPModel *model = nil;
        if (response && response.success) { // 有数据
            model = [EPModel objectWithKeyValues:response.content];
            if ([content isEqualToString:@""] || content == nil) {
                s_epModel = model;
//#warning text
//                s_epModel.identity_mark = @(2);
//                s_epModel.partner_service_fee_type = @2;
//                s_epModel.partner_service_fee = @5;
//#warning text
                [[UserData sharedInstance] initUserDataWithEpModel:s_epModel];
            }
        }
        if (block) {
            block(model);
        }

    }];
}

/** 获取岗位分类列表 */
- (void)getJobClassifierListWithBlock:(MKBlock)block{
//    if (!_jobListMD5 || [_jobListMD5 isEqualToString:@""]) {
//        // 从沙盒取数据
//        _jobListMD5 = [WDUserDefaults objectForKey:UserDefault_sjk_jobListMD5Info];
//        
//        if (!_jobListMD5) {
//            _jobListMD5 = @"";
//        }
//    }
    
    _jobListMD5 = @"";

    NSString* content = [NSString stringWithFormat:@"md5_hash:\"%@\"", _jobListMD5];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobClassifierList" andContent:content];
    request.isShowLoading = NO;
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
//            NSString* md5_hash = [response.content objectForKey:@"md5_hash"];
//            if (![md5_hash isEqualToString:_jobListMD5]) { // 数据过期了..
//                
//                _jobListMD5 = md5_hash;
                _jobList = [JobClassifierModel objectArrayWithKeyValuesArray:response.content[@"job_classifier_list"]];
//                // 存储数据到沙盒
//                [WDUserDefaults setObject:_jobListMD5 forKey:UserDefault_sjk_jobListMD5Info];
//                [WDUserDefaults synchronize];
//                [WDCache saveWithNSKeyedUnarchiver:_jobList fileName:UserDefault_sjk_jobListInfo];
//            } else { // 数据未过期,直接从沙盒取
//                if (!_jobList) {
//                    _jobList = [WDCache getWithNSKeyedUnarchiver:UserDefault_sjk_jobListInfo withClass:[NSArray class]];
//                }
//            }
            if (!_jobList) {
                _jobList = [[NSArray alloc] init];
            }
            if (block) {
                block(_jobList);
            }
        }else{
            block(nil);
        }
    }];
}

- (void)getRedBaoDetailWithJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\"",jobId];
    
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuLockRedPackets" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];

}

- (void)getJobDetailWithJobId:(NSString *)jobId andIsFromSAB:(NSInteger)isFormSAB isShowLoding:(BOOL)isShowLoding Block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"job_id:%@,from_social_activist_broadcast:%@, account_type:2", jobId, [NSString stringWithFormat:@"%lu",(unsigned long)isFormSAB]];
    NSString *pushId = [UserData sharedInstance].registrationID;
    if (pushId) {
        content = [content stringByAppendingFormat:@", \"push_id\":\"%@\"", pushId];
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getJobDetail" andContent:content];
    
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            JobDetailModel *jobDetail = [JobDetailModel objectWithKeyValues:response.content];
            MKBlockExec(block, jobDetail);
        } else {
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取岗位详情 */
- (void)getJobDetailWithJobId:(NSString *)jobId Block:(MKBlock)block{
    [self getJobDetailWithJobId:jobId andIsFromSAB:0 isShowLoding:YES Block:block];
}

/** 通过jobUuid获取岗位详情 */
- (void)getJobDetailWithJobUuid:(NSString *)jobUuid isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_uuid:\"%@\", \"account_type\":\"2\"", jobUuid];
    NSString *pushId = [UserData sharedInstance].registrationID;
    if (pushId) {
        content = [content stringByAppendingFormat:@", \"push_id\":\"%@\"", pushId];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getJobDetail" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            JobDetailModel *jobDetail = [JobDetailModel objectWithKeyValues:response.content];
            MKBlockExec(block, jobDetail);
        } else {
            MKBlockExec(block, nil);
        }
    }];
}



/** 兼客针对岗位提出疑问 */
- (void)stuJobQuestionWithJobId:(NSString *)jobId quesiton:(NSString *)question block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id: \"%@\", question: \"%@\"", jobId, question];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuJobQuestion" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, @(1));
        }
    }];
}

/** 雇主针对疑问进行解答 */
- (void)entJobAnswerWithJobId:(NSString *)jobId quesitonId:(NSString *)questionId answer:(NSString *)answer block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id: \"%@\", question_id: \"%@\", answer: \"%@\"", jobId, questionId, answer];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entJobAnswer" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, @(1));
        }
    }];
}

/** 兼客/雇主查询岗位提问和答复 */
- (void)queryJobQAWithJobId:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id: %@", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobQA" andContent:content];
    request.isShowLoading = isShowLoding;
//    request.loadingMessage = @"正在提交, 请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *qaList = [JobQAInfoModel objectArrayWithKeyValuesArray:response.content[@"list"]];
            if (block) {
                block(qaList);
            }
        }
    }];
}

/** 兼客/雇主查询岗位提问和答复 --支持分页*/
- (void)queryJobQAWithParam:(QueryJobQAParam *)param isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobQA" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *qaList = [JobQAInfoModel objectArrayWithKeyValuesArray:response.content[@"list"]];
            MKBlockExec(block, qaList);
        }else{
            MKBlockExec(block,nil);
        }
    }];
}


/** 查询报名岗位的兼客列表 */
- (void)queryApplyJobResumeListWithJobId:(NSString *)jobId block:(MKBlock)block
{
    NSString *content = [NSString stringWithFormat:@"job_id: %@, query_param:{page_size: 999}", jobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryApplyJobResumeList" andContent:content];
        request.isShowLoading = NO;
        request.loadingMessage = @"正在提交, 请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *jkList = [JKModel objectArrayWithKeyValuesArray:response.content[@"apply_job_resume_list"]];
            if (block) {
                block(jkList);
            }
        }
    }];
}



/** 获取指定城市的抢单岗位分类 */
- (void)getGrabJobClassListOfCity:(CityModel *)city block:(MKBlock)block
{
    if (!_grabJobClassListMD5 || [_grabJobClassListMD5 isEqualToString:@""]) {

        // 从沙盒取数据
        _grabJobClassListMD5 = [WDUserDefaults objectForKey:UserDefault_sjk_grabJobClassListMD5Info];
        
        if (!_grabJobClassListMD5) {
            _grabJobClassListMD5 = @"";
        }
    }
    
    NSString *cityId = city.id.description;
    if (!cityId) {
        cityId = @"211";
    }
    
//    NSString *content = [NSString stringWithFormat:@"\"data_version \":\"%@\", city_id:\"%@\"", _grabJobClassListMD5, cityId];
    
    NSString *content = [NSString stringWithFormat:@"city_id:\"%@\"", cityId];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getGrabSingleJobClassifierList" andContent:content];
//    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSString* md5_hash = response.content[@"data_version "];
//            if (![md5_hash isEqualToString:_grabJobClassListMD5]) { // 数据过期了..
            
            _grabJobClassListMD5 = md5_hash;
            if (response.content[@"list"]) {
                _grabJobClassList = [GrabJobClassModel objectArrayWithKeyValuesArray:response.content[@"list"]];
            }
            
                // 存储数据到沙盒
//                [WDUserDefaults setObject:_grabJobClassListMD5 forKey:UserDefault_sjk_grabJobClassListMD5Info];
//                [WDUserDefaults synchronize];
//                [WDCache saveWithNSKeyedUnarchiver:_grabJobClassList fileName:UserDefault_sjk_grabJobClassListInfo];
//            } else { // 数据未过期,直接从沙盒取
//                if (!_grabJobClassList) {
//                    _grabJobClassList = [WDCache getWithNSKeyedUnarchiver:UserDefault_sjk_grabJobClassListInfo withClass:[NSArray class]];
//                }
//            }
            block(_grabJobClassList);
        }
    }];
}


/** 雇主查询报名的兼客列表, 只返回response, 数据需要自己解析 */
- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type queryParam:(QueryParamModel *)param block:(MKBlock)block{
    [self entQueryApplyJobListWithJobId:jobId listType:type boardDate:nil queryParam:param block:block];
}

/** 雇主查询报名的兼客列表, 上传时间，只返回response, 数据需要自己解析 */
- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type boardDate:(NSNumber*)boardDate queryParam:(QueryParamModel *)param block:(MKBlock)block{
    [self entQueryApplyJobListWithJobId:jobId listType:type boardDate:boardDate queryParam:param isShowLoading:NO block:block];
}

- (void)entQueryApplyJobListWithJobId:(NSString *)jobId listType:(NSNumber *)type boardDate:(NSNumber*)boardDate queryParam:(QueryParamModel *)param isShowLoading:(BOOL)isShowLoading block:(MKBlock)block{

    GetQueryApplyJobModel *model = [[GetQueryApplyJobModel alloc] init];
    model.job_id = jobId;
    model.on_board_date = boardDate;
    model.list_type = type;
    if (param) {
        model.query_param = param;
    }else{
        model.is_need_pagination = @(0);
    }
    NSString *content = [model getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryApplyJobList" andContent:content];
    request.isShowLoading = isShowLoading;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block,response);
    }];
}


//==========================================
/** 企业确认/确认工作完成 处理一天的*/
- (void)entConfirmWorkCompleteWithApplyJobIdList:(NSArray *)list andDate:(NSString*)dateStr block:(MKBlock)block{
    NSString* content;
    if (dateStr == nil) {
        content = [NSString stringWithFormat:@"apply_job_id_list:[%@]", [list componentsJoinedByString:@","]];
    }else{
        content = [NSString stringWithFormat:@"apply_job_id_list:[%@],opernate_date:\"%@\"", [list componentsJoinedByString:@","], dateStr];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entConfirmWorkComplete" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}

/** 企业确认/批量确认工作完成 */
- (void)entConfirmWorkCompleteWithApplyJobIdList:(NSArray *)list block:(MKBlock)block{
    [self entConfirmWorkCompleteWithApplyJobIdList:list andDate:nil block:block];
}

//==========================================
/** 完工一天*/
- (void)entConfirmWorkCompleteWithJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block{
    NSString *content;
    if (dateStr == nil) {
        content = [NSString stringWithFormat:@"job_id:%@", jobId];
    }else{
        content = [NSString stringWithFormat:@"job_id:%@,opernate_date:\"%@\"", jobId,dateStr];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entConfirmWorkComplete" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}

/** 全部完工 */
- (void)entConfirmWorkCompleteWithJobId:(NSString *)jobId block:(MKBlock)block
{
    [self entConfirmWorkCompleteWithJobId:jobId andDate:nil block:block];
}
//==========================================
/** 企业确认兼客未到岗：已沟通一致 一天的*/

- (void)entConfirmStuNotCompleteWorkWithApplyJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block{
    NSString *content;
    if (dateStr == nil) {
        content = [NSString stringWithFormat:@"apply_job_id:%@", jobId];
    }else{
        content = [NSString stringWithFormat:@"apply_job_id:%@,opernate_date:\"%@\"", jobId,dateStr];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entConfirmStuNotCompleteWork" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}


/** 企业确认兼客未到岗：已沟通一致 */
- (void)entConfirmStuNotCompleteWorkWithApplyJobId:(NSString *)jobId block:(MKBlock)block{
    
    [self entConfirmStuNotCompleteWorkWithApplyJobId:jobId andDate:nil block:block];
}
//==========================================
- (void)entConfirmStuBreakPromiseWithApplyJobId:(NSString *)jobId andDate:(NSString*)dateStr block:(MKBlock)block{
    NSString *content;
    if (dateStr == nil ) {
        content = [NSString stringWithFormat:@"apply_job_id:%@", jobId];
    }else{
        content = [NSString stringWithFormat:@"apply_job_id:%@,opernate_date:\"%@\"", jobId, dateStr];
    }

    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entConfirmStuBreakPromise" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}

/** 企业确认兼客未到岗：放鸽子 */
- (void)entConfirmStuBreakPromiseWithApplyJobId:(NSString *)jobId block:(MKBlock)block{
    [self entConfirmStuBreakPromiseWithApplyJobId:jobId andDate:nil block:block];
}
//==========================================

/** 雇主对兼客工作情况评分 */
- (void)entScoreStuApplyJobWithApplyJobId:(NSString *)jobId evaluLevel:(NSNumber *)level block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"apply_job_id_list:[%@], evalu_level:%@", jobId, level];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entScoreStuApplyJob" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}

/** 雇主对兼客工作情况进行评论 */
- (void)entCommetStuApplyJobWithApplyJobId:(NSString *)jobId evaluContent:(NSString *)evaluContent block:(MKBlock)block
{
    NSString *content = [NSString stringWithFormat:@"apply_job_id_list:[%@], evalu_content:\"%@\"", jobId, evaluContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entCommetStuApplyJob" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
    
    
}



/** 企业聘用/拒绝聘用申请岗位处理 */
- (void)entEmployApplyJobWithWithApplyJobIdList:(NSArray *)list employStatus:(NSNumber *)status employMemo:(NSString *)memo block:(MKBlock)block
{
    EmployApplyJobPM *param = [[EmployApplyJobPM alloc] init];
    param.apply_job_id_list = list;
    param.employ_status = status;
    param.employ_memo = memo;
    NSString *content = [param getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entEmployApplyJob" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}

/** 企业批量聘用/拒绝聘用申请岗位处理 */
- (void)entEmployApplyJobWithWithJobId:(NSString *)jobId employStatus:(NSNumber *)status employMemo:(NSString *)memo block:(MKBlock)block
{
    
    EmployApplyJobPM *param = [[EmployApplyJobPM alloc] init];
    param.job_id = jobId;
    param.employ_status = status;
    param.employ_memo = memo;
    NSString *content = [param getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entEmployApplyJob" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在提交,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}


/** 兼客查询兼客的工作经历 */
- (void)stuQueryWorkExpericeWithQueryParam:(QueryParamModel *)param block:(MKBlock)block{
    NSString *content = param? [param getContent] : @"";
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuQueryWorkExperice_v2" andContent:content];
    request.isShowLoading = NO;
//    request.loadingMessage = @"正在查询,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (block) {
            block(response);
        }
    }];    
}


/** 获取学校列表(可按条件查询) */
- (void)querySchoolListWithAreaId:(NSString *)areaId cityId:(NSString *)cityId schoolName:(NSString *)schoolName block:(MKBlock)block
{
    SchoolPM *param = [[SchoolPM alloc] init];
    param.address_area_id = areaId;
    param.city_id = cityId;
    param.school_name = schoolName;
    
    NSString *content = param? [param getContent] : @"";
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_querySchoolList" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"正在查询,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (block) {
            block(response);
        }
    }];
}


/** 发布岗位 */
- (void)postParttimeJobWithContent:(NSString *)content block:(MKBlock)block
{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postParttimeJob" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"发布中,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (block) {
            block(response);
        }
    }];
}


/** 完善简历姓名 */
- (void)stuUpdateTrueName:(NSString *)name block:(MKBlock)block
{
    NSString *content = [NSString stringWithFormat:@"\"true_name\":\"%@\"", name];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postResumeInfo_V1" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"发送中,请稍候";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (block) {
            block(response);
        }
    }];
}

/** 统计企业已发布的岗位数 */
- (void)getPublishedJobNumWithIsSearchToday:(NSNumber *)isSearchToday block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"is_search_today\":%@", isSearchToday];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getTodayPublishedJobNum" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}


/** 兼客申请工作 */
- (void)candidateApplyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime isFromQrCodeScan:(NSNumber *)isFromQrCodeScan block:(MKBlock)block;
{
    NSString *workTimeStr = @"";
    if (workTime && workTime.count) {
        workTimeStr = [NSString stringWithFormat:@", stu_work_time:[%@]", [workTime componentsJoinedByString:@","]];
    }
    
    NSString *content = [NSString stringWithFormat:@"job_id:\"%@\"%@, from_qrcode_scan:\"%@\"", jobId, workTimeStr, isFromQrCodeScan.stringValue];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_candidateApplyJob" andContent:content];
    request.isShowLoading = YES;
//    request.loadingMessage = @"请求中,请稍候";
    request.isShowErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response && response.success) {
            if (block) {
                block(response);
            }
        } else if (response && response.errCode.integerValue == 77) {
            [UIHelper showConfirmMsg:@"您已经用完免认证报名次数，实名认证可增加两次报名机会" title:@"权限不足" cancelButton:@"知道了" okButton:@"立即认证" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 跳转到认证页面
                    IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
                    UIViewController *nav = [MKUIHelper getTopViewController];
                    if (nav) {
                        [nav.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
            }];
        } else if (response && response.errCode.integerValue == 78) {
            [UIHelper showConfirmMsg:@"抱歉，您今天已经用完5次报名机会，请明天再报名" title:@"每日上限" cancelButton:@"知道了" completion:nil];
        } else if (response) {
            [UIHelper toast:[NSString stringWithFormat:@"%@", response.errMsg]];
            
        }
    }];
}




/** 查询专题列表 */
- (void)getJobTopicListWithBlock:(MKBlock)block{
    if (!_jobTopicListMD5 || [_jobTopicListMD5 isEqualToString:@""]) {
        // 从沙盒取数据
        _jobTopicListMD5 = [WDUserDefaults objectForKey:UserDefault_sjk_JobTopicListMD5Info];
        
        if (!_jobTopicListMD5) {
            _jobTopicListMD5 = @"";
        }
    }
    
    NSString* content = [NSString stringWithFormat:@"md5_hash:\"%@\"", _jobTopicListMD5];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobTopicList" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSString* md5_hash = [response.content objectForKey:@"md5_hash"];
            if (![md5_hash isEqualToString:_jobTopicListMD5]) { // 数据过期了..
                
                _jobTopicListMD5 = md5_hash;
                _jobTopicList = [JobTopicModel objectArrayWithKeyValuesArray:response.content[@"job_topic_list"]];
                // 存储数据到沙盒
                [WDUserDefaults setObject:_jobTopicListMD5 forKey:UserDefault_sjk_JobTopicListMD5Info];
                [WDUserDefaults synchronize];
                [WDCache saveWithNSKeyedUnarchiver:_jobTopicList fileName:UserDefault_sjk_JobTopicListInfo];
            } else { // 数据未过期,直接从沙盒取
                if (!_jobTopicList) {
                    _jobTopicList = [WDCache getWithNSKeyedUnarchiver:UserDefault_sjk_JobTopicListInfo withClass:[NSArray class]];
                }
            }
            block(_jobTopicList);
        }
    }];
}


/** 获取分享信息 */
- (void)getAppShareInfoWithBlock:(MKBlock)block{
    RequestInfo *info = [[RequestInfo alloc] initWithService:@"shijianke_getAppShareInfoAll" andContent:@""];
    info.isShowLoading = NO;
    [info sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}


/** 雇主发起打卡请求 */
- (void)entIssuePunchRequestWithJobId:(NSString *)jobId time:(NSNumber *)time block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, punch_the_clock_time:%@", jobId, time];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entIssuePunchRequest" andContent:content];
    request.isShowErrorMsg = NO;
    
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}

/** 雇主导出岗位录用明细到邮箱 */
- (void)entExportJobApplyDetailToEmailWithJobId:(NSString *)jobId email:(NSString *)email block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, ent_email:\"%@\"", jobId, email];    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entExportJobApplyDetailToEmail" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}


/** 雇主查询人才库列表 */
- (void)entQueryTalentPoolWithContent:(NSString *)content block:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entQueryTalentPool" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}


/** 修改人才库状态 state 1：未删除；2：被删除*/
- (void)changeTalentResumeStatusWithTalentPoolId:(NSString *)talentPoolId talentPoolState:(NSNumber *)state block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"talent_pool_id:%@, talent_pool_status:%@", talentPoolId, state];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_changeTalentResumeStatus" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}


/** 分享岗位到人才库 */
- (void)entShareJobToTalentPoolWithJobId:(NSString *)jobId action:(NSNumber *)action block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@, action:%@", jobId, action];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entShareJobToTalentPool" andContent:content];
    request.isShowErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}
/** 分享到人才库 */
- (void)entShareJobToTalentPoolWithJobId:(NSString *)jobId{
    [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:jobId action:@(0) block:^(ResponseInfo *response) {
        if (response.success) {
            NSString *msg = response.content[@"success_msg"];
            [UIHelper showConfirmMsg:msg title:@"推送给人才库" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:jobId action:@(1) block:^(ResponseInfo *response) {
                        if (response.success) {
                            [UIHelper toast:@"发送人才邀请成功"];
                        } else {
                            if (response.errCode.integerValue == 72) {
                                [UIHelper showMsg:response.errMsg andTitle:@"目前支持您每天最多发 6 条岗位推送"];
                            }
                            if (response.errCode.integerValue == 73) {
                                [UIHelper showMsg:response.errMsg andTitle:@"人才库暂时没人"];
                            }
                        }
                    }];
                }
            }];
        } else {
            [UIHelper showMsg:response.errMsg andTitle:@"提示"];
        }
    }];
}



/** 兼客应答打卡请求 */
- (void)stuPunchTheClockWithJobId:(NSString *)jobId punchId:(NSString *)punchId punchTime:(NSString *)punchTime punchLat:(NSString *)punchLat punchLng:(NSString *)punchLng punchLocation:(NSString *)punchLocation block:(MKBlock)block{
    punchLat =  punchLat ? punchLat : @"0";
    punchLng = punchLng ? punchLng : @"0";
    punchLocation = punchLocation ? punchLocation : @"无法获取定位地址";
    
    NSString *content = [NSString stringWithFormat:@"app_job_id:%@, punch_the_clock_request_id:%@, punch_the_clock_time:%@, punch_the_clock_lat:%@, punch_the_clock_lng:%@, punch_the_clock_location:\"%@\"", jobId, punchId, punchTime, punchLat, punchLng, punchLocation];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuPunchTheClock" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}


/** 生成/刷新岗位二维码 */
- (void)entRefreshJobQrCodeWithJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@", jobId];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entRefreshJobQrCode" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if ([response success]) {
            MKBlockExec(block, response);
        } else {
            MKBlockExec(block, nil);
        }
    }];
}

- (void)creatMakeupUrlWithJobId:(NSString *)jobId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@", jobId];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_createMakeupUrl" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if ([response success]) {
            MKBlockExec(block, response);
        } else {
            MKBlockExec(block, nil);
        }
    }];
    
}

/** 扫描岗位二维码 */
- (void)stuScanJobQrCodeWith:(NSString *)qrCode block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"qr_code:\"%@\"", qrCode];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuScanJobQrCode" andContent:content];
    request.isShowErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            MKBlockExec(block, response);
        }
    }];
}

/** 账户流水明细查询(v3) */
- (void)queryAcctDetailItemWithQueryParam:(QueryParamModel *)queryParam detailListId:(NSString *)detailListId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"detail_list_id\":\"%@\",%@",detailListId,[queryParam getContent]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctDetailItem_v3" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block, response);
        }else{
            MKBlockExec(block, nil);
        }
        
    }];
}

/** 查询人脉王奖金 */
- (void)queryAcctSocialActivistBonusWithQueryParam:(QueryParamModel *)queryParam jobId:(NSString *)jobId detailID:(NSString *)detailID block:(MKBlock)block{
    NSString *jobIdContent;
    if (jobId) {
        jobIdContent = [NSString stringWithFormat:@"job_id:%@", jobId];
    }
    
    NSString *tempDetailID = [NSString stringWithFormat:@"account_money_detail_id:%@",detailID];

    NSString *content;
    if (jobIdContent) {
        content = [NSString stringWithFormat:@"%@,%@,%@",jobIdContent,tempDetailID,queryParam.getContent];
    }else{
        content = [NSString stringWithFormat:@"%@,%@",tempDetailID,queryParam.getContent];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctSocialActivistReward" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}



/** 调整兼客上岗日期 */
- (void)entChangeStuOnBoardDateWithApplyJobId:(NSNumber *)applyJobId dayArray:(NSArray *)dayArray block:(MKBlock)block{
    NSString *dateStr = [dayArray componentsJoinedByString:@","];
    NSString *content = [NSString stringWithFormat:@"apply_job_id:%@, on_board_date:[%@]", applyJobId.stringValue, dateStr];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entChangeStuOnBoardDate" andContent:content];
    
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block, response);
        }
    }];
}

/** 查询岗位可报名的日期 */
- (void)queryJobCanApplyDateWithJobId:(NSNumber *)jobId resumeId:(NSNumber *)resumeId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"job_id:%@", jobId.stringValue];
    if (resumeId) {
        content = [NSString stringWithFormat:@"%@, resume_id:%@", content, resumeId.stringValue];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobCanApplyDate" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block, response);
        }
    }];
}



/** 7.1.6	企业阅读兼客简历 */
- (void)entReadApplyJobResumeWithApplyJobId:(NSString *)applyJobId block:(MKBlock)block{
    
    NSString *content = [NSString stringWithFormat:@"apply_job_id:%@", applyJobId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entReadApplyJobResume" andContent:content];
    request.isShowLoading = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            MKBlockExec(block, response);
        }
    }];
}



/** 2.5	查询指定城市特色入口 */
- (void)getSpecialEntryListWithCityId:(NSNumber *)cityId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"city_id:%@", cityId.stringValue];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getSpecialEntryList" andContent:content];
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        MKBlockExec(block, response);
    }];
}


/** 查询当前城市特色入口 */
- (void)getCurrentCitySpecialEntryListWithBlock:(MKBlock)block{
    CityModel *city = [self city];
    if (city) {
        [self getSpecialEntryListWithCityId:city.id block:block];
    }
}

/** 2.5.2	根据特色入口id查询岗位列表 */
- (void)querySpecialEntryJobListWithSpecialEntryId:(NSNumber *)specialEntryId cityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block
{
    NSString *queryStr = queryParam? [queryParam getContent] : nil;
    
    NSString *content = [NSString stringWithFormat:@"special_entry_id:%@, city_id:%@", specialEntryId.stringValue, cityId.stringValue];
    
    if (queryStr) {
        content = [NSString stringWithFormat:@"%@, %@", content, queryStr];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_querySpecialEntryJobList" andContent:content];
    
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response.success) {
            
            if (block) {
                block(response);
            }
        }
    }];
}

/** 根据特色入口id查询当前城市的岗位列表 */
- (void)querySpecialEntryJobListWithSpecialEntryId:(NSNumber *)specialEntryId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block
{
    CityModel *city = [self city];
    
    [self querySpecialEntryJobListWithSpecialEntryId:specialEntryId cityId:city.id queryParam:queryParam block:block];
}


- (void)getEqrMsgModelWithBlock:(MKBlock)block{
    if (_eqrMsgModel) {
        if (block) {
            block(_eqrMsgModel);
        }
    }else{
        GetQuickReplyMsgModel* requestModel = [[GetQuickReplyMsgModel alloc] init];
        requestModel.custom_info_type = @"1";
        requestModel.data_md5 = @"0";
        NSString* content = [requestModel getContent];
        
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getClientCustomInfo" andContent:content];
        request.isShowLoading = NO;
        WEAKSELF
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {
                NSString* contentStr = [response.content objectForKey:@"data_content"];
                if (contentStr) {
                    NSData* dataContent = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSError* error;
                    NSDictionary* dicContent = [NSJSONSerialization JSONObjectWithData:dataContent options:NSJSONReadingMutableLeaves error:&error];
                    if (error) {
                        ELog(@"========解析json返还错误信息：%@，原字符串是:%@", error, contentStr);
                    }else{
                        EQRMsgModel* model = [EQRMsgModel objectWithKeyValues:dicContent];
                        if (model) {
                            _eqrMsgModel = model;
                        }
                    }
                }
                if (!contentStr || !_eqrMsgModel) {
                    EQRMsgModel* eqrmodel = [[EQRMsgModel alloc] init];
                    NSArray* jkMsgArray = [[NSArray alloc] initWithObjects: @"你好，请问具体怎么做？", @"还招人么？",@"需要做多久？",nil];
                    NSArray* epMsgArray = [[NSArray alloc] initWithObjects: @"你好，请留下你的姓名、学校、联系电话，稍后我们会与你联系.", @"对不起，我们人员招满了，请留下你的姓名、学校、联系电话，方便下次与你联系.", @"请仔细查看岗位描述哦，里面有描述.",nil];
                    eqrmodel.student_quick_reply = jkMsgArray;
                    eqrmodel.ent_quick_reply = epMsgArray;
                    
                    [weakSelf postClientCustomInfoWithEQRModel:eqrmodel isShowLoding:NO block:^(ResponseInfo* response) {
                        if (response && [response success]) {
                            _eqrMsgModel = eqrmodel;
                        }else{
                            _eqrMsgModel = [[EQRMsgModel alloc] init];
                        }
                        if (block) {
                            block(_eqrMsgModel);
                        }
                    }];
                }else{
                    if (block) {
                        block(_eqrMsgModel);
                    }
                }
            }
        }];
    }
}

- (void)setEqrMsgModel:(EQRMsgModel*)model{
    _eqrMsgModel = model;
}

- (void)postClientCustomInfoWithEQRModel:(EQRMsgModel*)model isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString* msgStr = [model simpleJsonString];
    EQRSendMsgModel* sendModel = [[EQRSendMsgModel alloc] init];
    sendModel.data_content = msgStr;
    sendModel.custom_info_type = @"1";
    NSString* content = [sendModel getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_postClientCustomInfo" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (block) {
            block(response);
        }
    }];
}


/** 兼客头条 */
- (void)getHeadlineNewsWithBlock:(MKBlock)block
{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getHeadlineNews" andContent:@""];
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
       
        if (response && response.success) {
            
            if (block) {
                block(response);
            }
        }
    }];
}


/** 雇主头条 */
- (void)getEpHeadlineNewsWithBlock:(MKBlock)block
{
    // 2.6TODO
    // 参数确定
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getHeadlineNews" andContent:@""];
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response && response.success) {
            
            if (block) {
                block(response);
            }
        }
    }];
}



/** 获取岗位福利标签列表 */
- (void)getJobTagListWithBlock:(MKBlock)block{
    if (s_jobTagList) {
        MKBlockExec(block ,s_jobTagList)
        return;
    }
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getJobTagList" andContent:@""];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *jobTagList = [WelfareModel objectArrayWithKeyValuesArray:response.content[@"job_tag_list"]];
            // 排序
            s_jobTagList = [jobTagList sortedArrayUsingComparator:^NSComparisonResult(WelfareModel *obj1, WelfareModel *obj2) {
                return [obj1.tag_rank compare:obj2.tag_rank];
            }];
            MKBlockExec(block ,s_jobTagList)
        }else{
            MKBlockExec(block ,nil);
        }
    }];
}


/** 人脉王获取兼客列表 */
- (void)getSocialActivistApplyJobResumeListWithJobId:(NSString *)jobId listType:(NSNumber *)listType queryParam:(QueryParamModel *)queryParam block:(MKBlock)block
{
    NSString *queryStr = queryParam ? [NSString stringWithFormat:@", %@", [queryParam getContent]] : @"";
    
    NSString *content = [NSString stringWithFormat:@"job_id:%@, list_type:%@%@", jobId, listType, queryStr];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getSocialActivistApplyJobResumeList" andContent:content];
    
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (block) {
            block(response);
        }
    }];
}






#pragma mark - IM相关接口
/** 4.5.1	获取群组资料 */
- (void)imGetGroupInfoWithGroupId:(NSString *)GroupId block:(MKBlock)block{
    [self imGetGroupInfoWithGroupId:GroupId isSimple:NO block:block];
}

- (void)imGetGroupInfoWithGroupId:(NSString *)GroupId isSimple:(BOOL)isSimple block:(MKBlock)block{
    NSString* serviceStr;
    if (isSimple) {
        serviceStr = @"shijianke_im_getGroupAbstractInfo";
    }else{
        serviceStr = @"shijianke_im_getGroupInfo";
    }

    GetImGroupInfoModel* getModel = [[GetImGroupInfoModel alloc] init];
    getModel.md5_hash = @"0";
    getModel.groupId = GroupId;
    NSString* content = [getModel getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:serviceStr andContent:content];
    request.isShowLoading = NO;
    [request sendRequestToImServer:^(ResponseInfo *response) {
        if (response.success) {
            IMGroupDetailModel *groupDetail = [IMGroupDetailModel objectWithKeyValues:response.content[@"group"]];
            if (block) {
                block(groupDetail);
            }
        }
    }];
}

/** 4.5.2	获取企业群组列表 */
- (void)imGetMgrGroupsWithBlock:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_im_getMgrGroups" andContent:@""];
    
    [request sendRequestToImServer:^(ResponseInfo *response) {
        if (response.success) {
            NSArray *imGroups = [IMGroupModel objectArrayWithKeyValuesArray:response.content[@"groups"]];
            if (block) {
                block(imGroups);
            }
        }
    }];
}



/** 4.5.3	退出群组 */
- (void)imQuitGroupWithGroupId:(NSString *)groupId block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"groupId\":\"%@\"", groupId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_im_quitGroup" andContent:content];
    
    [request sendRequestToImServer:^(ResponseInfo *response) {
        
        if (response.success) {
            if (block) {
                block(response);
            }
        }
    }];
}

//强制升级接口
- (void)getClientVersionWithVersion:(int)version block:(MKBlock)block{
    NSString* content = [NSString stringWithFormat:@"query_condition:{\"product_type\":\"%@\",\"version\":\"%d\"}",[XSJUserInfoData getClientType], version];

    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getClientVersion" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            ClientVersionModel* model = [ClientVersionModel objectWithKeyValues:response.content];
            if (block) {
                block(model);
            }
        }
    }];
}


#pragma mark - 查询手机号对应账号信息接口
- (void)queryAccountInfo:(NSString *)telPhone block:(MKBlock)block{
    NSString *content = [NSString stringWithFormat:@"\"telphone\":\"%@\"", telPhone];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountInfo" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            JKModel *jkModel = [JKModel objectWithKeyValues:response.content];            
            if (block) {
                block(jkModel);
            }
        }
    }];
    
}

#pragma mark - 雇主手动补录人员接口
- (void)entMakeupStuBySelfWithJobId:(NSString *)job_id resumeList:(NSArray *)resume_list block:(MKBlock)block{
    EntMakeupRequest *makeupRequest = [[EntMakeupRequest alloc] init];
    makeupRequest.job_id = job_id;
    makeupRequest.resume_list = resume_list;
    NSString *content = [makeupRequest getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_entMakeupStuBySelf" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response.success) {
            if (block) {
                block(response);
            }
        }
    }];
    
}
#pragma mark -V326
- (void)refreshResumeWithblock:(MKBlock)block{
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_refreshResume" andContent:nil];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) {
            if(block){
                block(response);
            }
        }
    }];
}
- (void)queryLookMeWithParam:(QueryParamModel *)param isShowLoding:(BOOL)isShowLoding block:(MKBlock)block{
    NSString *content = [param getContent];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuQueryEntViewList" andContent:content];
    request.isShowLoading = isShowLoding;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            MKBlockExec(block,response.content);
        }
    }];
    
}
- (void)saveHomeADListWithArray:(NSArray*)list{
    NSArray* dicAry = [AdModel keyValuesArrayWithObjectArray:list];
    NSString* path = [WDCache getFullNameByFileName:@"home_ad_list" isPlist:NO];
    [dicAry writeToFile:path atomically:YES];
}
- (void)saveHomeQuickEntryListWithArray:(NSArray*)list{
    NSArray* dicAry = [MenuBtnModel keyValuesArrayWithObjectArray:list];
    NSString* path = [WDCache getFullNameByFileName:@"home_quick_entry_list" isPlist:NO];
    [dicAry writeToFile:path atomically:YES];
}
- (void)saveHomeJobListWithArray:(NSArray*)list{
    NSArray* dicAry = [JobModel keyValuesArrayWithObjectArray:list];
    NSString* path = [WDCache getFullNameByFileName:@"home_job_list" isPlist:NO];
    [dicAry writeToFile:path atomically:YES];
}

- (NSArray*)getHomeADList{
    NSString* path = [WDCache getFullNameByFileName:@"home_ad_list" isPlist:NO];
    NSArray* dicAry = [[NSArray alloc] initWithContentsOfFile:path];
    if (dicAry && dicAry.count) {
        return [AdModel objectArrayWithKeyValuesArray:dicAry];
    }
    return nil;
}
- (NSArray*)getHomeQuickEntryList{
    NSString* path = [WDCache getFullNameByFileName:@"home_quick_entry_list" isPlist:NO];
    NSArray* dicAry = [[NSArray alloc] initWithContentsOfFile:path];
    if (dicAry && dicAry.count) {
        return [MenuBtnModel objectArrayWithKeyValuesArray:dicAry];
    }
    return nil;
}
- (NSArray*)getHomeJobList{
    NSString* path = [WDCache getFullNameByFileName:@"home_job_list" isPlist:NO];
    NSArray* dicAry = [[NSArray alloc] initWithContentsOfFile:path];
    if (dicAry && dicAry.count) {
        return [JobModel objectArrayWithKeyValuesArray:dicAry];
    }
    return nil;
}

- (void)saveSearchHistoryWithArray:(NSArray*)list{
    NSString* path = [WDCache getFullNameByFileName:@"search_histoty" isPlist:NO];
    [list writeToFile:path atomically:YES];
}

- (NSArray*)getSearchHistoty{
    NSString* path = [WDCache getFullNameByFileName:@"search_histoty" isPlist:NO];
    NSArray* ary = [[NSArray alloc] initWithContentsOfFile:path];
    if (ary && ary.count) {
        return ary;
    }
    return nil;
}

#pragma mark - 众包数据缓存
- (void)saveZBHomeListWithArray:(NSArray *)list{
    NSAssert(list, @"list不能为nil");
    NSArray *dicArr = [ZhaiTaskModel keyValuesArrayWithObjectArray:list];
    NSString *path = [WDCache getFullNameByFileName:@"zb_home_list" isPlist:NO];
    [dicArr writeToFile:path atomically:YES];
    
}

- (NSArray *)getZBHomeList{
    NSString *path = [WDCache getFullNameByFileName:@"zb_home_list" isPlist:NO];
    NSArray *dicArr = [[NSArray alloc] initWithContentsOfFile:path];
    if (dicArr && dicArr.count) {
        return [ZhaiTaskModel objectArrayWithKeyValuesArray:dicArr];
    }
    return [[NSArray alloc] init];
}

//无法打印log时  可以用  此方法将log写到沙盒 查看
+ (void)debugWriteToCache:(NSString *)logStr{
//    return; //有需要的时候开启就好了
#if DEBUG
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    //用[NSDate date]可以获取系统当前时间
    NSString* currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27
    NSString* fileName = [NSString stringWithFormat:@"%@-netError.log", currentDateStr];
    
    NSString* recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"%@/debugLog/%@", recorderPath, fileName];
    
//    ELog(@"===========错误日志位置 %@ ==========", fileName);
    NSString* str = [NSString stringWithFormat:@"%@\n\r",logStr];
    [str writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
#endif
}

//=================全局变量链接处理
- (void)handleGlobalRMUrlWithType:(GlobalRMUrlType)type block:(MKBlock)block{
    ClientGlobalInfoRM *globalRM = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (!globalRM) {
        return;
    }
    switch (type) {
        case GlobalRMUrlType_findServiceEntry:{
            if (!globalRM.wap_url_list || !globalRM.wap_url_list.service_personal_entry_url.length) {
                return;
            }
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = globalRM.wap_url_list.service_personal_entry_url;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, viewCtrl);
        }
            break;
        case GlobalRMUrlType_queryMyPersonalApplyJobList:{
            if (!globalRM.wap_url_list || !globalRM.wap_url_list.query_service_personal_apply_job_list_url.length) {
                return;
            }
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = globalRM.wap_url_list.query_service_personal_apply_job_list_url;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, viewCtrl);
        }
            break;
        case GlobalRMUrlType_servicePersonalCenterEntryUrl:{
            if (!globalRM.wap_url_list || !globalRM.wap_url_list.service_personal_personal_center_entry_url.length) {
                return;
            }
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = globalRM.wap_url_list.service_personal_personal_center_entry_url;
            viewCtrl.hidesBottomBarWhenPushed = YES;
            MKBlockExec(block, viewCtrl);
        }
            break;
        default:
            break;
    }
    
}

@end
