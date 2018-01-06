//
//  ThirdPartAccountModel.h
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 第三方账号类型 */
typedef NS_ENUM(NSInteger, ThirdPartAccountType) {
    ThirdPartAccountTypeQQ = 0,
    ThirdPartAccountTypeWechat,
    ThirdPartAccountTypeWeibo,
    ThirdPartAccountTypeWechatApp
};

typedef void (^ResultBlock)();

@interface ThirdPartAccountModel : NSObject

@property (nonatomic, copy) NSString *getUserInfoURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *getCodeURL;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *refreshTokenURL;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *getAccessTokenURL;
@property (nonatomic, copy) NSNumber *createTime;
@property (nonatomic, copy) NSString *redirectURL;

/**
 *  保存第三方账号信息
 *  @param account 要保存的账号信息
 *  @param type    要保存的账号类型
 */
+ (void)saveThirdPartAccountWithAccount:(ThirdPartAccountModel *)account accountType:(ThirdPartAccountType)type;

+ (instancetype)qqAccount;
+ (instancetype)wechatAccount;
+ (instancetype)weiboAccount;
+ (instancetype)wechatAppAccount;

/** 保存第三放账号信息 */
+ (void)saveThirdpartAccountsWithArray:(NSArray *)array;

///** 绑定微信 */
//+ (void)bindWechatWithBlock:(ResultBlock)block;

@end
