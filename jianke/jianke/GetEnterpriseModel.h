//
//  GetEnterpriseModel.h
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"
#import "WDConst.h"

@class EntNameModel;

@interface GetEnterpriseModel : MKBaseModel

@property (nonatomic, strong) QueryParamModel* query_param;
@property (nonatomic, strong) EntNameModel* query_condition;
@end

@interface EntNameModel : MKBaseModel
@property (nonatomic, copy) NSString* enterprise_name;
@property (nonatomic, copy) NSNumber *city_id;
@end

@interface EntInfoModel : MKBaseModel
@property (nonatomic, copy) NSString* enterprise_id;
@property (nonatomic, copy) NSString* enterprise_name;
@property (nonatomic, copy) NSString *profile_url;
@end

//@interface EnterpriseRM : MKBaseModel
//@property (nonatomic, strong) NSArray* ent_list;
//@property (nonatomic, copy) NSString* ent_count;
//@property (nonatomic, strong) QueryParamModel* query_param;
//@end
