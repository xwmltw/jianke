//
//  ParamModel.m
//  jianke
//
//  Created by xiaomk on 15/9/20.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ParamModel.h"
#import "WDConst.h"
#import "LocalModel.h"

@implementation ParamModel
- (instancetype)init{
    self = [super init];
    if (self) {
//        ELog(@"======ParamModel init()");
    }
    return self;
}
- (NSString*)getContent{
    if (self) {
        NSDictionary* dic = [self keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
//        if (self.isNeedBracket) {
//            return str;
//        }
        NSUInteger strLength = [str length];
        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return param;
    }
    return nil;
}
@end

@implementation BaseInfoPM
- (instancetype)init{
    self = [super init];
    if (self) {
        ELog(@"======BaseInfoPM init()");
        self.client_type = [XSJUserInfoData getClientType];
        self.client_version = [MKDeviceHelper getAppBundleShortVersion];
        self.uid = [UIDeviceHardware getUUID];
        
        LocalModel* localModel = [[UserData sharedInstance] local];
        self.lat = localModel.latitude ? localModel.latitude : @"0";
        self.lng = localModel.longitude ? localModel.longitude : @"0";
        
        CityModel* localCity = [[UserData sharedInstance] localCity];
        self.pos_city_id = localCity.id ? localCity.id : @(0);
        
        CityModel* cityModel = [[UserData sharedInstance] city];
        self.city_id = cityModel.id ? cityModel.id : (localCity.id ? localCity.id : @(211));
    }
    return self;
}
@end

@implementation QueryParamModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.page_num = @1;     //默认为1
        self.page_size = @30;   //默认30条数据
    }
    return self;
}

- (instancetype)initWithPageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum{
    if (self = [super init]) {
        self.page_size = pageSize;
        self.page_num = pageNum;
    }
    return self;
}
MJCodingImplementation;
- (NSString*)getContent{
    if (self) {
        NSDictionary* dic = [self keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
        NSString* param = [NSString stringWithFormat:@"\"query_param\":%@",str];
        return param;
    }
    return nil;
}
@end

@implementation UserLoginPM
@end

@implementation PostPerfectUserInfoPM
@end

@implementation PostOathUserInfoPM
@end

@implementation RegistUserByPhoneNumPM
@end

@implementation ResetPasswordByPhoneNumPM
@end

@implementation GetSmsAuthenticationCodePM
@end

@implementation SubmitFeedbackV2
@end

@implementation WechatParmentRequest
@end

@implementation AlipayPM
@end

@implementation PostResumeInfoPM
@end

@implementation PostIdcardAuthInfoPM
@end

@implementation EmployApplyJobPM
@end

@implementation EntPayForStuPM
- (NSDictionary *)objectClassInArray{
    return @{@"payment_list" : [PaymentPM class]};
}

@end

@implementation PaymentPM
- (NSString*)getContent{
    if (self) {
        NSDictionary* dic = [self keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
//        NSUInteger strLength = [str length];
//        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return str;
    }
    return nil;
}
@end

@implementation SchoolPM
@end

@implementation ActivateDeviceModel
@end

@implementation SendGroupMsgPM
@end

@implementation GetADModel
@end
@implementation StuUploadPhotoPM
@end

@implementation UpdateJobBillModel
@end

@implementation UpdateStuJobBillPM
@end

@implementation GetQuickReplyMsgModel
@end

@implementation GetImGroupInfoModel
@end



@implementation QueryJobListConditionModel
@end

@implementation QueryJobListModel
@end

@implementation RemoveGroupModel
@end

@implementation PostEPInfo
@end

@implementation GetTopicDetailPM
@end

@implementation GetClientGlobalPM
@end


@implementation GetEnterpriscJobModel
@end

@implementation GetQueryApplyJobModel
@end

@implementation MakeupInfo
@end

@implementation EntMakeupRequest
- (NSDictionary *)objectClassInArray{
    return @{@"resume_list" : [JKModel class]};
}
@end

@implementation EntQueryPunch

- (instancetype)initWithJob:(NSString *)job andListType:(NSNumber *)listType andParam:(QueryParamModel *)param{
    self = [super init];
    if (self) {
        self.job_id = job;
        self.list_type = listType;
        self.query_param = param;
    }
    return self;
}

@end

@implementation EntQueryStuPunch

- (instancetype)initWithQueryParam:(QueryParamModel *)queryParam withRequestId:(NSString *)requestId{
    self = [super init];
    if (self) {
        self.query_param = queryParam;
        self.punch_the_clock_request_id = requestId;
    }
    return self;
}
@end

@implementation EntChangeOnBoardDateStuPM
@end

@implementation GetJobLikeParam

- (instancetype)initWithjobId:(NSString *)jobId andCityId:(NSNumber *)cityId andCityModel:(LocalModel *)localModel{
    self = [super init];
    if (self) {
        self.job_id = jobId;
        self.city_id = cityId ? cityId :@(211);
        self.lat = localModel.latitude ? localModel.latitude : @"0";
        self.lng = localModel.longitude ? localModel.longitude : @"0";
    }
    return self;
}

@end

@implementation QueryJobQAParam
@end

@implementation RechargeAmountParam
@end

@implementation DetailItmeParam
@end

@implementation FeedbackParam

- (instancetype)init{
    self = [super init];
    if (self) {
        self.id = @5;
        self.name = @"其他问题";
    }
    return self;
}

@end

@implementation FreeCallPM
MJCodingImplementation
@end
