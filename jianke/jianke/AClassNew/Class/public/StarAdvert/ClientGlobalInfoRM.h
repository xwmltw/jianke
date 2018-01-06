//
//  ClientGlobalInfoRM.h
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"
#import "ShareInfoModel.h"
#import "ClientVersionModel.h"
#import "JKHomeModel.h"

@class ShareModel, AdOnOffModel, WapUrlList;

@interface ClientGlobalInfoRM : MKBaseModel
@property (nonatomic, copy) NSNumber *current_time_millis;          /*!< 时间毫秒<整形数字> */

@property (nonatomic, strong) ClientVersionModel *version_info;     /*!< 版本更新信息 */
@property (nonatomic, strong) ShareModel *share_info;

@property (nonatomic, copy) NSNumber *is_not_support_zhong_bao; /*!< 是否支持众包 */

@property (nonatomic, copy) NSNumber *is_use_third_party_open_screen_ad;    /*!< 是否使用第三方启动广告 */
@property (nonatomic, copy) NSArray *start_front_ad_list;           /*!< 客户端启动前景广告 */

@property (nonatomic, copy) NSArray *special_entry_list;            /*!< 特色入口信息 */
@property (nonatomic, copy) NSArray *banner_ad_list;                /*!< 客户端banner广告 */

@property (nonatomic, copy) NSArray *stu_head_line_ad_list;         /*!< 兼客头条 */
@property (nonatomic, copy) NSArray *ent_head_line_ad_list;         /*!< 雇主头条 */
@property (nonatomic, copy) NSArray *ent_pop_up_ad_list;            /*!< 雇主首页 scrollView 广告 */


@property (nonatomic, copy) NSNumber *advance_salary_entry_enable;  /*!< 预付款入口，1开启，0不开启 */

@property (nonatomic, copy) NSNumber *alipay_sigle_withdraw_min_limit;  /*!< 支付宝取出最低限额 */
@property (nonatomic, copy) NSString *alipay_withdraw_desc;         /*!< 支付宝取现须知 */
@property (nonatomic, copy) NSString *alipay_withdraw_desc_v3;      /*!< 提现须知 弹窗*/
@property (nonatomic, copy) NSString *withdraw_desc;                /*!< 取现须知 */

//@property (nonatomic, copy) NSNumber *apply_job_limit_status;     /*!< 岗位投递限制开关，1开启，0不开启 */
@property (nonatomic, copy) NSNumber *apply_job_limit_enable;       /*!< 岗位投递限制开关，1开启，0不开启 */

@property (nonatomic, copy) NSString *borrowday_advance_salary_url; /*!< 菠萝代 预领工资URL */
@property (nonatomic, copy) NSString *zhai_task_wap_index_url;      /*!< m端宅任务首页链接地址 */
@property (nonatomic, copy) NSArray *feedback_classify_list;        /*!< 意见反馈类型 */

@property (nonatomic, strong) AdOnOffModel *ad_on_off;

@property (nonatomic, copy) NSString *service_personal_url; /*!< 个人服务url */
@property (nonatomic, copy) NSString *service_personal_apply_url; /*!< 个人服务案例申请url */

// add by kizy 3.1.2
@property (nonatomic, strong) WapUrlList *wap_url_list; /*!< 链接 */

//add by kizy 3.1.3
@property (nonatomic, copy) NSArray *service_type_stu_banner_ad_list;   /*!< 觅探分类列表banenr广告列表字段 */
@property (nonatomic, copy) NSNumber *is_show_adviser;  /*!< 是否显示兼客觅探顾问相关内容 */
@property (nonatomic, copy) NSString *adviser_telephone;    /*!< 兼客觅探顾问手机号码 */
@property (nonatomic, copy) NSNumber *wechat_sigle_withdraw_min_limit;  /*!< 微信取现限额字段 单位为元 */
@property (nonatomic, copy) NSArray *zhai_app_special_entry_list;   /*!< 众包任务APP特色入口 */

//added by kizy 3.1.6
@property (nonatomic, strong) AdModel *bottom_job_detail_ad;   /*!< 客户端岗位详情页底部广告 */
@property (nonatomic, strong) AdModel *bottom_apply_success_ad;    /*!< 客户端报名成功底部广告 */

//add V327
@property (nonatomic, strong) AdModel *job_list_ad_1;/*!< 岗位列表广告1 */
@property (nonatomic, strong) AdModel *job_list_ad_2;/*!< 岗位列表广告2 */
@property (nonatomic, strong) AdModel *job_list_ad_3;/*!< 岗位列表广告3 */
@property (nonatomic, copy) NSNumber *is_need_hide_limit_job;/*!< 是否隐藏限制岗位 */

@end

@interface ShareModel : MKBaseModel
@property (nonatomic, strong) ShareInfoModel *share_info;
@property (nonatomic, copy) NSString *sms_share_info;
@end

@interface AdOnOffModel : MKBaseModel
@property (nonatomic, copy) NSNumber *job_list_third_party_ad_open;             /*!< 岗位列表广告是否开启  1：开启 0：关闭 */
@property (nonatomic, copy) NSNumber *job_detail_third_party_ad_open;           /*!< 岗位详情第三方广告是否开始 1：开启 0：关闭 */
@property (nonatomic, copy) NSNumber *job_apply_success_third_party_ad_open;    /*!< 岗位报名成功页面第三方广告是否开启  1：开启 0：关闭 */

@end

@interface WapUrlList : MKBaseModel

@property (nonatomic, copy) NSString *fenqile_advance_salary_url;   /*!< 分期乐预支工资入口链接地址 */
@property (nonatomic, copy) NSString *jianke_welfare_salary_url;   /*!< 兼客福利入口链接地址 */
@property (nonatomic, copy) NSString *guide_youpin_intro_download_url;   /*!< 兼客优聘下载链接地址 */
@property (nonatomic, copy) NSString *jianke_task_applying_list_url;    /*!< 兼客正在进行中的任务列表页面地址 */
@property (nonatomic, copy) NSString *jianke_task_salary_list_url;  /*!< 兼客任务收入列表页面地址 */
@property (nonatomic, copy) NSString *service_personal_apply_preview_url;   /*!< 档案卡详情预览页面url */
@property (nonatomic, copy) NSString *service_personal_entry_url;   /*!< 跳转通告入口 */
@property (nonatomic, copy) NSString *query_service_personal_apply_job_list_url;    /*!< 我的通告入口 */
@property (nonatomic, copy) NSString *service_personal_personal_center_entry_url;   /*!< 通告个人中心入口 */


@end


//“current_time_millis”: xxx //时间毫秒<整形数字>
//“advance_salary_entry_enable”: xxx//预付款入口，1开启，0不开启
//“apply_job_limit_status”: xxx //岗位投递限制开关，1开启，0不开启
//“stu_head_line_ad_list”:[] 兼客头条
//“ent_head_line_ad_list”: [] 雇主头条
//“special_entry_list” : [] 特色入口信息
//“is_use_third_party_open_screen_ad” : xxx // 是否使用第三方启动广告
//“start_front_ad_list” : [] // 客户端启动前景广告
//“banner_ad_list” : [] // 客户端banner广告
//“alipay_withdraw_desc” : xxx // 支付宝取现须知
//“zhai_task_wap_index_url”:xxx // m端宅任务首页链接地址
//点击广告数据结构



//content = {
//    advance_salary_entry_enable = 1,
//    alipay_sigle_withdraw_min_limit = 1,
//    current_time_millis = 1463380265106,
//    share_info = {
//        share_info = {
//            share_img_url = http://wodan-idc.oss-cn-hangzhou.aliyuncs.com/develop/Upload/shijianke-mgr/share/2015-06-16/c981e6a463ce4adb9c38b1fd3eb478c0.shareImg,
//            share_url = http://localhost:8080/shijianke-server/shorturl/app/STUDENT/,
//            share_title = 找兼职上兼客 想干就干,
//            share_content = 想找份兼职赚点零花钱？兼客，一个专门找兼职的APP，赶紧试试吧！
//        },
//        sms_share_info = 想找份兼职赚点零花钱？兼客，一个专门找兼职的APP，赶紧试试吧！http://localhost:8080/shijianke-server/shorturl/app/STUDENT/
//    },
//    zhai_task_wap_index_url = http://zhongbao.shijianke.com,
//    version_info = {
//    },
//    alipay_withdraw_desc = 提现须知,
//    is_use_third_party_open_screen_ad = 1,
//    apply_job_limit_enable = 1
//},

    
