//
//  ResponseInfo.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ResponseInfo.h"
#import "PayDetailModel.h"
#import "CityModel.h"
#import "SociaAcitvistModel.h"

@implementation ResponseInfo

- (BOOL)success{
    return self.errCode.intValue == 0;
}

@end

@implementation GetPublicKeyModel
@end

@implementation ShockHand2Model
@end

@implementation CreatSessionModel
@end

@implementation PunchResponseModel
@end

@implementation PunchClockModel
- (NSDictionary *)objectClassInArray{
    return @{@"punch_request_list" : [PunchResponseModel class]};
}
@end



@implementation AcctVirtualModel
@end

@implementation AcctVirtualResponseModel

- (NSDictionary *)objectClassInArray{
    return @{@"detail_list" : [AcctVirtualModel class]};
}

@end

@implementation DetailItemResponseMolde

- (NSDictionary *)objectClassInArray{
    return @{@"detail_list" : [PayDetailModel class]};
}

@end

@implementation ToadyPublishedJobNumRM

@end

@implementation StuSubscribeModel

- (NSDictionary *)objectClassInArray{
    return @{@"child_area" : [CityModel class] , @"job_classifier_list" : [JobClassifyInfoModel class]};
}

@end

@implementation UpdateStuSubscribeModel

@end

@implementation SocialActivistTaskListModel

- (NSDictionary *)objectClassInArray{
    return @{@"task_list" : [SociaAcitvistModel class]};
}

@end

@implementation JobVasModel
@end

@implementation JobVasResponse
@end

@implementation ServiceTeamApplyModel
@end

@implementation ServicePersonalStuModel
@end

@implementation ResumeExperienceModel
@end
