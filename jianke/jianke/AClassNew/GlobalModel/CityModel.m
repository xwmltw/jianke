//
//  CityModel.m
//  jianke
//
//  Created by xiaomk on 16/5/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
MJCodingImplementation

- (void)setDiselect{
    _isSelect = NO;
}

- (BOOL)isEnablePersonalService{
    return self.enablePersonalService.integerValue == 1;
}

- (BOOL)isEnableTeamService{
    return self.enableTeamService.integerValue == 1;
}

@end
