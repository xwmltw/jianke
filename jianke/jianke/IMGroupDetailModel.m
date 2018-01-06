//
//  IMGroupDetailModel.m
//  jianke
//
//  Created by fire on 16/1/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//  群组资料模型

#import "IMGroupDetailModel.h"

@implementation IMGroupDetailModel
- (NSDictionary *)objectClassInArray
{
    return @{@"groupMembers" : [IMGroupMemberModel class]};
}
@end




@implementation IMGroupMemberModel
@end    