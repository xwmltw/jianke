//
//  XSJUserInfoData.m
//  jianke
//
//  Created by xiaomk on 16/5/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJUserInfoData.h"
#import "CityModel.h"
#import "XSJConst.h"
#import "MKCacheHelper.h"
#import "DataBaseTool.h"
#import "XSJLocalNotificationMgr.h"


static NSString * const KU_UserInfo = @"KU_UserInfo";
//第一次登录（提示切换雇主）
static NSString * const XSJUserDefault_isOpenAppYet = @"XSJUserDefault_isOpenAppYet";

//static BOOL isFirstOpenApp = YES;

@interface XSJUserInfoData(){

}


@end

static UserInfoModel *s_userInfoModel = nil;   /*!< 用户信息 */

@implementation XSJUserInfoData
Impl_SharedInstance(XSJUserInfoData);


- (instancetype)init{
    if (self = [super init]) {
        s_userInfoModel = [MKCacheHelper getByNSKeyedUnarchiver:KU_UserInfo withClass:[UserInfoModel class] isCanClear:NO];
        if (!s_userInfoModel) {
            s_userInfoModel = [[UserInfoModel alloc] init];
        }
        self.isShowMoneyBadRedPoint = NO;
        DLog(@"XSJUserInfoData init");
    }
    return self;
}

- (void)clearActivateJumpType{
    _activateJumpType = 0;
}


#pragma mark - ***** 版本数据调整 ******
- (void)versionUserDataCompensate{
    //3.0.0
    NSString* userPhone = [WDUserDefaults stringForKey:WDUserDefault_UserPhone];
    NSString* password = [WDUserDefaults stringForKey:WDUserDefaults_Password];
    if (userPhone && ![userPhone isEqualToString:@"***********"]) {
        [self savePhone:userPhone password:password];
        [WDUserDefaults setObject:@"***********" forKey:WDUserDefault_UserPhone];
        [WDUserDefaults setObject:@"******" forKey:WDUserDefaults_Password];
        [WDUserDefaults synchronize];
    }
    
    [self updateAppOpenTime];
    
    // >=2.4版本的数据补偿
    [DataBaseTool fixImDataBaseConversationTableData];
    
}

#pragma mark - ***** 存取 账号密码 ******
- (void)savePhone:(NSString *)userPhone password:(NSString*)password{
    [self savePhone:userPhone password:password dynamicPassword:nil];
}

- (void)savePhone:(NSString *)userPhone password:(NSString*)password dynamicPassword:(NSString *)dynamicPassword{
    if (!s_userInfoModel)  NSAssert(NO, @"s_userInfoModel is nil");
    if (userPhone && userPhone.length > 0) {
        s_userInfoModel.userPhone = userPhone;
    }
    if (password && password.length > 0) {
        s_userInfoModel.password = password;
    }
    if (dynamicPassword && dynamicPassword.length > 0) {
        s_userInfoModel.dynamicPassword = dynamicPassword;
    }
    [MKCacheHelper saveByNSKeyedUnarchiverWith:s_userInfoModel fileName:KU_UserInfo isCanClear:NO];
}

- (void)setUserPhone:(NSString *)userPhone{
    if (!s_userInfoModel)  NSAssert(NO, @"s_userInfoModel is nil");
    s_userInfoModel.userPhone = userPhone;
    [MKCacheHelper saveByNSKeyedUnarchiverWith:s_userInfoModel fileName:KU_UserInfo isCanClear:NO];
}

- (void)setPassword:(NSString *)password{
    if (!s_userInfoModel)  NSAssert(NO, @"s_userInfoModel is nil");
    s_userInfoModel.password = password;
    [MKCacheHelper saveByNSKeyedUnarchiverWith:s_userInfoModel fileName:KU_UserInfo isCanClear:NO];
}

- (UserInfoModel *)getUserInfo{
    return s_userInfoModel;
}

#pragma mark - ***** 是否已经打开过APP ******
- (BOOL)getIsOpenAppYet{
    BOOL isFirstOpenApp = [WDUserDefaults boolForKey:XSJUserDefault_isOpenAppYet];
    return isFirstOpenApp;
}
/**  设置是否首次进入 (YES则选择雇主or兼客) */
- (void)setIsOpenAppYet:(BOOL)bYet{
    [WDUserDefaults setBool:bYet forKey:XSJUserDefault_isOpenAppYet];
    [WDUserDefaults synchronize];
}

/** 更新app 打开次数 */
- (void)updateAppOpenTime{
    NSString* lastVersion = [WDUserDefaults stringForKey:WDUserDefault_evaluateVersion];
    NSString* currentVersion = [MKDeviceHelper getAppBundleVersion];
    if (![lastVersion isEqualToString:currentVersion]) {
        [WDUserDefaults setObject:currentVersion forKey:WDUserDefault_evaluateVersion];
        [WDUserDefaults setInteger:0 forKey:WDUserDefault_jobDetailTime];
        [WDUserDefaults setInteger:0 forKey:WDUserDefault_openAppTime];
        [WDUserDefaults synchronize];
    }
    NSInteger openTime = [WDUserDefaults integerForKey:WDUserDefault_openAppTime];
    if (openTime) {
        openTime += 1;
    }else{
        openTime = 1;
    }
    [WDUserDefaults setInteger:openTime forKey:WDUserDefault_openAppTime];
    [WDUserDefaults synchronize];
}

#pragma mark - ***** 获取是否显示“我”的小红点 ******
- (BOOL)getIsShowMyInfoTabBarSmallRedPoint{
    if (![UserData sharedInstance].isLogin) {
        return NO;
    }
    if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
        return self.isShowMoneyBadRedPoint || self.isShowMyApplyRedPoint || self.isShowPersonalServiceRedPoint;
    }else{
        if ([[UserData sharedInstance] getEpModelFromHave].is_bd_bind_account.integerValue == 1) {//bd
            return self.isShowMoneyBadRedPoint;
        }else{
            return self.isShowMoneyBadRedPoint || self.isShowEpBaozhaoCheckRedPoint;
        }
    }
}

//代办小红点
- (BOOL)getIsShowMyWaitTabBarSmallRedPoint{
    if (![UserData sharedInstance].isLogin) {
        return NO;
    }
    if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
        return self.isShowPersonalServiceRedPoint || self.isShowMyApplyRedPoint;
    }
    return NO;
}

#pragma mark - ***** 重置静态变量 *****
- (void)clearStaticObj{
    self.isShowPersonalServiceRedPoint = NO;
    self.isShowMyApplyRedPoint = NO;
    self.isShowMoneyBadRedPoint = NO;
}

#pragma mark - ***** 类方法 ******
//首次定位 激活设备
+ (BOOL)isActivateDevice{
    return [WDUserDefaults boolForKey:UserDefault_ActivateDevice];
}

+ (void)setActivateDevice{
    [WDUserDefaults setBool:YES forKey:UserDefault_ActivateDevice];
    [WDUserDefaults synchronize];
}

+ (void)activateDevice{
    ActivateDeviceModel* model = [[ActivateDeviceModel alloc] init];
    model.dev_name = [MKDeviceHelper getPlatformString];
    model.system = [MKDeviceHelper getSysVersionString];
    model.uid = [UIDeviceHardware getUUID];
    model.is_login = [[UserData sharedInstance] isLogin] ? @"1" : @"0";
    model.platform_type = [XSJUserInfoData getClientType];
    
    LocalModel* localModel = [[UserData sharedInstance] local];
    if (localModel) {
        if (![XSJUserInfoData isActivateDevice]) {
            model.lat = localModel.latitude;
            model.lng = localModel.longitude;
            model.city_name = localModel.locality;
            
            NSString* content = [model getContent];
            RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_getActiveDev" andContent:content];
            request.isShowLoading = NO;
            [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
                if (response && [response success]) {
                    [XSJUserInfoData setActivateDevice];
                }
            }];
        }
    }
}

/** 是否已经导入IM历史消息 */
+ (BOOL)getisHaveIMHistoryWithUserId:(NSString *)userId{
    NSString* str = [NSString stringWithFormat:@"%@_%@",WDUserDefault_firstLoginIm, userId];
    return [WDUserDefaults boolForKey:str];
}

+ (void)setisHaveIMHistortWithUserId:(NSString *)userId{
    NSString* str = [NSString stringWithFormat:@"%@_%@",WDUserDefault_firstLoginIm, userId];
    [WDUserDefaults setBool:YES forKey:str];
    [WDUserDefaults synchronize];
}


//2是 IOS
+ (NSString *)getClientType{
    return @"2";
}

//2是 IOS
+ (NSString *)getProductType{
    return @"2";
}
#pragma mark - ***** 查询是否是苹果审核账号 *****
+ (BOOL)isReviewAccount{
    
    if ([[[XSJUserInfoData sharedInstance] getUserInfo].userPhone isEqualToString:ReviewAccount] || ![[XSJUserInfoData sharedInstance] getUserInfo].userPhone.length) {
        return YES;
    }else{
    
        return NO;
    }
}

+ (NSString *)createRandom32UppStr{
    NSString* xStr = [NSString stringWithFormat:@"%d",arc4random()];
    return [[xStr MD5] uppercaseString];
}

@end
