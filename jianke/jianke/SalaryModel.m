//
//  SalaryModel.m
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "SalaryModel.h"
#import "MJExtension.h"

@implementation SalaryModel

MJCodingImplementation

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - ***** 薪资单位 ******
- (NSString*)getTypeDesc{
    switch (self.unit.intValue) {
        case 1:
            return @"/天";
        case 2:
            return @"/时";
        case 3:
            return @"/月";
        case 4:
            return @"/次";
        default:
            return @"/天";
    }
}



#pragma mark - ***** 结算 ******
- (NSString*)getSettlementDesc{
    switch (self.settlement.intValue) {
        case 1:
            return @"当天结算";
        case 2:
            return @"周末结算";
        case 3:
            return @"月末结算";
        case 4:
            return @"完工结算";
        default:
            return @"不限";
    }
}





@end
