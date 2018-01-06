//
//  RequestParamWrapper.h
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamModel.h"

@interface RequestParamWrapper : NSObject

@property (nonatomic, copy) NSString* serviceName;
@property (nonatomic, copy, getter=getContent) NSString* content;
@property (nonatomic, strong) QueryParamModel* queryParam;
@property (nonatomic, assign) Class typeClass;
@property (nonatomic, copy) NSString* arrayName;

@end
