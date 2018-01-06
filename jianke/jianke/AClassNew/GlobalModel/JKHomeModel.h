//
//  JKHomeModel.h
//  jianke
//
//  Created by fire on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MenuBtnModel : NSObject

@property (nonatomic, copy) NSNumber *special_entry_id;         /*!< <long>特色入口id */
@property (nonatomic, copy) NSString *special_entry_title;      /*!< <string> 特色入口标题 */
@property (nonatomic, copy) NSNumber *special_entry_type;       /*!< <int>特色入口类型，1：应用内打开链接 2：应用外打开链接 3：岗位列表 4: 抢单列表*/
@property (nonatomic, copy) NSNumber *special_entry_type_new;   /*!< <int>特色入口类型，1：应用内打开链接 2：应用外打开链接 3：岗位列表 4: 抢单列表 5:专题列表*/
@property (nonatomic, copy) NSString *special_entry_url;        /*!< <string>特色入口url */
@property (nonatomic, copy) NSString *special_entry_icon;       /*!< <string>特色入口图标url */
@property (nonatomic, copy) NSString *job_topic_id;             /*!<专题ID */
@end


@interface AdModel : NSObject
@property (nonatomic, copy) NSNumber* ad_order_num;     /*!< 广告排序,<整形数字>  */
@property (nonatomic, copy) NSNumber* ad_id;            /*!< 广告id */
@property (nonatomic, copy) NSString* ad_name;          /*!< 广告名称 */
@property (nonatomic, copy) NSString* ad_content;
@property (nonatomic, copy) NSString* ad_status;
@property (nonatomic, copy) NSNumber* ad_site_id;       /*!< 广告位ID, <整形数字> */
@property (nonatomic, copy) NSNumber* ad_detail_id;     /*!< 如果为岗位广告，则为岗位id，如果是专题广告，则是专题id，文章广告的话为空 */
@property (nonatomic, copy) NSNumber* ad_type;          /*!< 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型 */
@property (nonatomic, copy) NSString* ad_detail_url;    /*!< 如果是岗位广告或者专题广告则为空，链接(包括文章)广告则为具体广告详情链接 */
@property (nonatomic, copy) NSString* img_url;
@property (nonatomic, copy) NSNumber* create_time;      /*!< 广告创建时间,<整形数字>, 值为1970年1月1日起的毫秒数. */
@property (nonatomic, copy) NSNumber* city_id;          /*!< 广告定位的城市ID */

@end


//
//“ad_id”: xxx, // 广告id
//“img_url”: xxx, // 广告图片
//“ad_detail_id”: xxx, // 如果为岗位广告，则为岗位id，如果是专题广告，则是专题id，文章广告的话为空
//“ad_name”:xxx,// 广告名称
//“ad_type”:xxx,// 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型
//“ad_detail_url”:xxx,// 如果是岗位广告或者专题广告则为空，链接(包括文章)广告则为具体广告详情链接
//“ad_site_id” : 广告位ID, <整形数字> ,
//“create_time” : 广告创建时间,<整形数字>, 值为1970年1月1日起的毫秒数.
//“city_id” : 城市ID, <整形数字> , 广告定位的城市ID.
//“ad_order_num” : 广告排序,<整形数字> ,\

//ad_status
//is_site_default
