//
//  LocalModel.m
//  jianke
//
//  Created by fire on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  位置模型

#import "LocalModel.h"

@implementation LocalModel
MJCodingImplementation

- (void)setAddress:(NSString *)address{
    _address = address;
    if (address.length > 0) {
        _subAddress = address;
        if (self.country.length) {
            _subAddress = [_subAddress stringByReplacingOccurrencesOfString:self.country withString:@""];
        }
        if (self.administrativeArea.length) {
            _subAddress = [_subAddress stringByReplacingOccurrencesOfString:self.administrativeArea withString:@""];
        }
        if (self.locality.length) {
            _subAddress = [_subAddress stringByReplacingOccurrencesOfString:self.locality withString:@""];
        }
    }

    ELog(@"====address:%@, _subAddress:%@", _address, _subAddress);
}
@end
