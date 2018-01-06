//
//  TLV.h
//  CashBox
//
//  Created by ZKF on 13-11-18.
//  Copyright (c) 2013年 ZKF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLV : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSString *value;


@end
