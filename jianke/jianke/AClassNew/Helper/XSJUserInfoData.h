//
//  XSJUserInfoData.h
//  jianke
//
//  Created by xiaomk on 16/5/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBaseModel.h"


/** 启动转场 类型 直接跳转到指定界面 */
typedef NS_ENUM(NSInteger, AppActivateJumpType) {
    AppActivateJumpType_InsterJob = 1,  //意向岗位
};

@class CityModel,UserInfoModel;
@interface XSJUserInfoData : NSObject

@property (nonatomic, assign) AppActivateJumpType activateJumpType;

+ (instancetype)sharedInstance;
@property (nonatomic, assign) BOOL isShowMoneyBadRedPoint;      /*!< 是否显示钱袋子小红点 */
@property (nonatomic, assign) BOOL isShowEpBaozhaoCheckRedPoint;/*!< 是否显示雇主包招账单小红点 */
@property (nonatomic, assign) BOOL isShowPersonalServiceRedPoint;   /*!< 是否显示服务订单小红点 */
@property (nonatomic, assign) BOOL isShowMyApplyRedPoint;   /*!< 是否显示我的报名 其实不显示小红点 用于在代办tabbar显示的 */

@property (nonatomic, assign) BOOL MyWaitToDoOpen;  /*!< tabbarVC切换时是否显示我的代办 */

@property (nonatomic, assign, getter=isDidEnterBackground) BOOL didEnterBackground;          /*!< 是否在后台 */
@property (nonatomic, assign) NSTimeInterval openStamp;; /*!< app直接开启的时间戳 */
//@property (nonatomic, copy) NSString *appData;

//@property (nonatomic, assign) BOOL isLogoutActive; /** 是否主动退出 */
//
//@property (nonatomic, assign) BOOL isUpdateWithEPHome;  /** 控制返回雇主首页是否刷新 */
//@property (nonatomic, assign) BOOL isWXBinding;  /** 微信是否绑定 */
//@property (nonatomic, strong) CityModel* localCity; /*!< 当前定位的城市 */  //与用户主动选择的城市可能不同， 不要用错
//
//@property (nonatomic, copy) NSString *jobUuid; /*!< 用于app唤醒时跳转的jobUuid */

#pragma mark - ***** 重置静态变量 *****
- (void)clearStaticObj;

#pragma mark - ***** 启动跳转 ******
- (void)clearActivateJumpType;

#pragma mark - ***** 版本数据调整 ******
- (void)versionUserDataCompensate;

#pragma mark - ***** 存取 账号密码 ******
- (void)savePhone:(NSString *)userPhone password:(NSString*)password;
- (void)savePhone:(NSString *)userPhone password:(NSString*)password dynamicPassword:(NSString *)dynamicPassword;
- (void)setUserPhone:(NSString *)userPhone;
- (void)setPassword:(NSString *)password;
- (UserInfoModel *)getUserInfo;

#pragma mark - ***** 是否已经打开过APP ******
- (BOOL)getIsOpenAppYet;
- (void)setIsOpenAppYet:(BOOL)bYet;
- (void)updateAppOpenTime;

#pragma mark - ***** 获取是否显示“我”的小红点 ******
- (BOOL)getIsShowMyInfoTabBarSmallRedPoint;

//代办小红点
- (BOOL)getIsShowMyWaitTabBarSmallRedPoint;

#pragma mark - ***** 通用类方法 ******
/** 首次启动 激活设备 */
+ (BOOL)isActivateDevice;
+ (void)setActivateDevice;
+ (void)activateDevice;

/** 是否已经导入IM历史消息 */
+ (BOOL)getisHaveIMHistoryWithUserId:(NSString *)userId;
+ (void)setisHaveIMHistortWithUserId:(NSString *)userId;

//2是 IOS
+ (NSString *)getClientType;
//2是 IOS
+ (NSString *)getProductType;
+ (NSString *)createRandom32UppStr;

//检查账号是否是提供给apple审核的测试账号
+ (BOOL)isReviewAccount;

/** 版本更新 */
//+ (void)checkVersion;

@end




