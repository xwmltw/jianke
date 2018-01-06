//
//  ImUserInfo.m
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ImUserInfo.h"

@implementation ImUserInfo

- (void)updateVersion{
}

- (NSString*)getShowName{
    if (self.accountName) {
        return self.accountName;
    }
//    if (self.remarkName) {
//        return self.remarkName;
//    }
//    
//    if (self.nickname) {
//        return self.nickname;
//    }
    
    if (self.userPublicInfo) {
        return self.userPublicInfo.nickname;
    }
    return @"无名";
}

- (NSString*)getHead{
    if (self.headUrl) {
        return self.headUrl;
    }
    if (self.userPublicInfo) {
        return self.userPublicInfo.headUrl;
    }
    return nil;
}

@end

@implementation OpenImFunModel
@end

@implementation ImAccountInfo
@end

@implementation EmployerInfo
- (NSString*)getShowName{
    if (self.entName) {
        return self.entName;
    }
    
    if (self.name) {
        return self.name;
    }
    return [super getShowName];
}
@end


//@implementation SearchEmployer : NSObject
//
//@end

@implementation GlobalFeatureInfo : ImUserInfo
MJCodingImplementation
- (NSString*)getShowName{
    if (self.funName && self.funName.length > 0) {
        return self.funName;
    }
    if (self.accountName && self.accountName.length > 0) {
        return self.accountName;
    }
    //    if (self.remarkName) {
    //        return self.remarkName;
    //    }
    //
    //    if (self.nickname) {
    //        return self.nickname;
    //    }
    
    if (self.userPublicInfo) {
        return self.userPublicInfo.nickname;
    }
    return @"无名";
}
@end

//@implementation FeatureInfo : ImUserInfo
//@end

@implementation MenuJsonModel
MJCodingImplementation
@end