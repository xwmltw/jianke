//
//  DetailTopicInfoModel.h
//  jianke
//
//  Created by xiaomk on 16/3/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailTopicInfoModel : NSObject
@property (nonatomic, copy) NSString* topic_name;
@property (nonatomic, copy) NSString* topic_desc;
@property (nonatomic, copy) NSString* web_detail_url;
@property (nonatomic, copy) NSString* topic_desc_url;
@property (nonatomic, copy) NSString* topic_id;

//topic_detail = {
//    topic_name = 兼客暑期嘉年华,
//    topic_desc = 暑期工专场活动1,
//    web_detail_url = http://wap.shijianke.com/,
//    topic_desc_url = http://wodan-idc.oss-cn-hangzhou.aliyuncs.com/shijianke-mgr/jobClassify/2015-05-19/E36746F049CE685FA5B47D215DF1F7D7.png,
//    topic_id = 3
//}
@end
