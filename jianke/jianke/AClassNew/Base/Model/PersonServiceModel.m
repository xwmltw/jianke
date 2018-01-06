//
//  PersonServiceModel.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceModel.h"

@implementation PersonServiceModel

- (NSString *)getServiceTypeStr{
    switch (self.service_type.integerValue) {
        case 1:
            return @"模特人员";
        case 2:
            return @"礼仪人员";
        case 3:
            return @"主持人员";
        case 4:
            return @"商务演出";
        case 5:
            return @"家庭教师";
        case 6:
            return @"校园代理";
        default:
            return @"";
    }
}

//@property (nonatomic, copy) NSNumber *service_personal_job_id;  // 个人服务需求id
//@property (nonatomic, copy) NSString *service_title;    // 服务名称
//@property (nonatomic, copy) NSNumber *service_type; // 服务类型  1：模特 2：礼仪3：主持  4：商演 5：家教 6：校园代理
//@property (nonatomic, copy) NSString *working_place;    // 工作地点
//@property (nonatomic, copy) NSNumber *working_time_start_date;  //<long>工作时间的开始日期，1970年1月1日至今的毫秒数
//@property (nonatomic, copy) NSNumber *working_time_end_date;    //<long>工作结束的日期，1970年1月1日至今的毫秒数，
//@property (nonatomic, copy) NSString *service_desc; // 服务描述
//@property (nonatomic, copy) NSNumber *city_id;  // 城市ID, 整形数字
//@property (nonatomic, copy) NSNumber *address_area_id;  // 区域ID , 整形数字
//@property (nonatomic, copy) NSNumber *area_code;    //城市区号
//@property (nonatomic, copy) NSNumber *admin_code;  //区域行政区号
//@property (nonatomic, copy) NSNumber *status;   // 状态  1：已发布 2：已结束
//@property (nonatomic, strong) WorkTimePeriodModel *working_time_period; /*!< 工作时间段 */
//@property (nonatomic, strong) SalaryModel* salary;                  /*!< 薪水 */
//@property (nonatomic, copy) NSNumber *create_time;  // 发布时间 1970年1月1日至今的毫秒数
//@property (nonatomic, copy) NSNumber *invite_num;   // 邀约数
//@property (nonatomic, copy) NSNumber *accept_invite_num;    // 接单数
//@property (nonatomic, copy) NSNumber *platform_invite_accept_num;   // 平台邀约数
//@property (nonatomic, copy) NSNumber *apply_status; //邀约状态 1:待回复 2:已报名 3:已拒绝

- (void)convertFromDic:(NSDictionary *)dic{
    self.service_title = [dic objectForKey:@"service_title"];
    self.service_personal_job_id = [dic objectForKey:@"service_personal_job_id"];
    self.service_type = [dic objectForKey:@"service_type"];
    self.working_place = [dic objectForKey:@"working_place"];
    self.working_time_start_date = [dic objectForKey:@"working_time_start_date"];
    self.working_time_end_date = [dic objectForKey:@"working_time_end_date"];
    self.service_desc = [dic objectForKey:@"service_desc"];
    self.city_id = [dic objectForKey:@"city_id"];
    self.address_area_id = [dic objectForKey:@"address_area_id"];
    self.create_time = [dic objectForKey:@"create_time"];
    self.admin_code = [dic objectForKey:@"admin_code"];
    self.apply_status = [dic objectForKey:@"apply_status"];    
}

@end
