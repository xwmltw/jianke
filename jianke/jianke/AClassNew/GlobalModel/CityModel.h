//
//  CityModel.h
//  jianke
//
//  Created by xiaomk on 16/5/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"

@interface CityModel : MKBaseModel
@property (nonatomic, copy) NSNumber *id;                /*!< 城市id */
@property (nonatomic, copy) NSNumber *areaCode;          /*!< 区号 */
@property (nonatomic, copy) NSString *name;              /*!< 城市名 */
@property (nonatomic, copy) NSNumber *areaId;            /*!< 区域ID */
@property (nonatomic, copy) NSNumber *type;              /*!< 类型: 1市, 2区 */
@property (nonatomic, copy) NSNumber *hotCities;         /*!< 是否热门城市: 0/1 */
@property (nonatomic, copy) NSString *pinyinFirstLetter; /*!< 拼音首字母 */
@property (nonatomic, copy) NSString *spelling;          /*!< 拼音全拼 */
@property (nonatomic, copy) NSString *jianPin;           /*!< 简拼 */
@property (nonatomic, copy) NSNumber *status;            /*!< 状态 */
@property (nonatomic, copy) NSNumber *sortPriority;      /*!< 排序优先级 */
@property (nonatomic, copy) NSString *secondLevelDomain; /*!< 二级域名 */
@property (nonatomic, copy) NSString *cityDomainPrefix;  /*!< 城市二级域名主机头 */
@property (nonatomic, copy) NSArray *child_area;         /*!< 子区域 CityModel*/

@property (nonatomic, copy) NSNumber *isGrabSingle;             /*!< <int>，是否为开启抢单的城市，1表示开启，0表示不开启 */
@property (nonatomic, copy) NSNumber *socialActivistPortal;     /*!< <int>,是否开启人脉王，1 表示开启，0 表示不开启 */
@property (nonatomic, copy) NSNumber *enableRecruitmentService; /*!< <int>,是否开启委托招聘，1 表示开启，0 表示不开启 */
@property (nonatomic, copy) NSString *contactQQ;                /*!< 城市客服经理 */

@property (nonatomic, copy) NSNumber *enablePartnerService;     /*!< 开通兼客合伙人服务：1已开通 0未开通 */
@property (nonatomic, copy) NSNumber *partnerServiceFeeType;     /*!< 合伙人佣金计算方式： 1比例 2绝对值 */
@property (nonatomic, copy) NSNumber *partnerServiceFee;     /*!< 合伙人佣金, 比例方式为百分比值，绝对值方式为数值 */

@property (nonatomic, copy) NSNumber *enablePersonalService;    /*!< 个人服务   0：关闭 1：开启 */
@property (nonatomic, copy) NSNumber *enableTeamService;    /*!< 服务商服务   0：关闭 1：开启 */

@property (nonatomic, copy) NSNumber *enableVipService; /*!< vip服务  0：关闭 1：开启 */
@property (nonatomic, copy) NSNumber *enableThroughService; /*!< vip直通车服务  0：关闭 1：开启 */
@property (nonatomic, copy) NSNumber *level;    /*!< 城市级别   1：一级城市 2：二级城市 */

//@property (nonatomic, copy) NSNumber *leaderId;
//@property (nonatomic, copy) NSNumber *createTime;
//@property (nonatomic, copy) NSNumber *adminCode;
//@property (nonatomic, copy) NSNumber *isOpen;

//自定义
@property (nonatomic, copy) NSNumber *parent_id;        /*!< 父区域id */
@property (nonatomic, copy) NSString *parent_name;      /*!< 父区域名称 */
@property (nonatomic, assign) BOOL isSelect;            /*!< 是否选中 */
@property (nonatomic, assign) BOOL isParentCity;    /*!< 是否为城市 */

- (void)setDiselect;
- (BOOL)isEnableTeamService;
- (BOOL)isEnablePersonalService;

@end

/**
 service: shijianke_getCityList 获取城市列表
 content = {
	cities = [
 {
	id = 219,
	cityDomainPrefix = bj,
	areaId = 0,
	name = 北京,
	hotCities = 1,
	sortPriority = 0,
	pinyinFirstLetter = b,
	type = 1,
	spelling = beijing,
	isOpen = 0,
	jianPin = bj,
	secondLevelDomain = bj.shijianke.com,
	status = 1,
	areaCode = 010
 },
 */


/**
 service: shijianke_getCityInfo 获取城市信息
 content = {
	city_info = {
	id = 219,
	cityDomainPrefix = bj,
	areaId = 0,
	status = 1,
	hotCities = 1,
	sortPriority = 0,
	pinyinFirstLetter = b,
	type = 1,
	spelling = beijing,
	isOpen = 0,
	jianPin = bj,
	secondLevelDomain = bj.shijianke.com,
	areaCode = 010,
	name = 北京
 },
	child_area = [
 {
	id = 301,
	status = 1,
	areaId = 219,
	hotCities = 0,
	sortPriority = 0,
	pinyinFirstLetter = d,
	type = 2,
	spelling = dongchengqu,
	isOpen = 0,
	jianPin = dcq,
	areaCode = ,
	name = 东城区
 },
 
 */
