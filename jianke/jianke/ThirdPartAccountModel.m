//
//  ThirdPartAccountModel.m
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ThirdPartAccountModel.h"
#import "WDConst.h"

@interface ThirdPartAccountModel()


@end

@implementation ThirdPartAccountModel

MJCodingImplementation

+ (void)saveThirdPartAccountWithAccount:(ThirdPartAccountModel *)account accountType:(ThirdPartAccountType)type{
    switch (type) {
        case ThirdPartAccountTypeQQ:
        {
            NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
            [WDUserDefaults setObject:accountData forKey:QQAccountKey];
            [WDUserDefaults synchronize];
        }
            break;
        case ThirdPartAccountTypeWechat:
        {
            NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
            [WDUserDefaults setObject:accountData forKey:WechatAccountKey];
            [WDUserDefaults synchronize];
        }
            break;
        case ThirdPartAccountTypeWeibo:
        {
            NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
            [WDUserDefaults setObject:accountData forKey:WeiboAccountKey];
            [WDUserDefaults synchronize];
        }
            break;
        case ThirdPartAccountTypeWechatApp:
        {
            NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
            [WDUserDefaults setObject:accountData forKey:WechatAppAccountKey];
            [WDUserDefaults synchronize];
        }
            break;
        default:
            break;
    }
}

+ (instancetype)qqAccount{
    NSData *qqAccountData = [WDUserDefaults objectForKey:QQAccountKey];
    ThirdPartAccountModel *qqAccount = [NSKeyedUnarchiver unarchiveObjectWithData:qqAccountData];
    return qqAccount;
}

+ (instancetype)wechatAccount{
    NSData *wechatAccountData = [WDUserDefaults objectForKey:WechatAccountKey];
    ThirdPartAccountModel *wechatAccount = [NSKeyedUnarchiver unarchiveObjectWithData:wechatAccountData];
    return wechatAccount;
}

+ (instancetype)weiboAccount{
    NSData *weiboAccountData = [WDUserDefaults objectForKey:WeiboAccountKey];
    ThirdPartAccountModel *weiboAccount = [NSKeyedUnarchiver unarchiveObjectWithData:weiboAccountData];
    return weiboAccount;
}

+ (instancetype)wechatAppAccount{
    NSData *wechatAppAcountData = [WDUserDefaults objectForKey:WechatAppAccountKey];
    ThirdPartAccountModel *wechatAppAcount = [NSKeyedUnarchiver unarchiveObjectWithData:wechatAppAcountData];
    return wechatAppAcount;
}

/** 保存第三放账号信息 */
+ (void)saveThirdpartAccountsWithArray:(NSArray *)array{
    [array enumerateObjectsUsingBlock:^(ThirdPartAccountModel *obj, NSUInteger idx, BOOL *stop) {
        
        switch (obj.id.integerValue) {
            case 1: // QQ
                [self saveThirdPartAccountWithAccount:obj accountType:ThirdPartAccountTypeQQ];
                break;
            case 2: // Wechat
                [self saveThirdPartAccountWithAccount:obj accountType:ThirdPartAccountTypeWechat];
                break;
            case 3: // Weibo
                [self saveThirdPartAccountWithAccount:obj accountType:ThirdPartAccountTypeWeibo];
                break;
            case 4: // WechatApp
                [self saveThirdPartAccountWithAccount:obj accountType:ThirdPartAccountTypeWechatApp];
                break;
        }
    }];
}

@end
