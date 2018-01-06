//
//  LocalModel.h
//  jianke
//
//  Created by fire on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  位置模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface LocalModel : NSObject
@property(nonatomic, copy) NSString* latitude;          /*!< 纬度 */
@property(nonatomic, copy) NSString* longitude;         /*!< 经度 */
@property(nonatomic, copy) NSString* country;           /*!< 国家: 中国 */
@property(nonatomic, copy) NSString* administrativeArea;    /*!< 省份: 福建省 */
@property(nonatomic, copy) NSString* subAdministrativeArea;
@property(nonatomic, copy) NSString* locality;          /*!< 城市: 福州市 */
@property(nonatomic, copy) NSString* subLocality;       /*!< 区域: 仓山区 */
@property(nonatomic, copy) NSString* thoroughfare;      /*!< 路*/
@property(nonatomic, copy) NSString* subThoroughfare;   /*!< 门牌号 */
@property(nonatomic, copy) NSString* postalCode;        /*!< 邮编 */
@property(nonatomic, copy) NSString* address;           /*!< 详细地址: 中国福建省福州市仓山区建新镇*/
@property(nonatomic, copy) NSString* subAddress;        /*!< 子区域: 仓山区建新镇*/

@end

//Latitude = 26.068226
//Longitude = 119.248477
//Country = 中国
//administrativeArea = 福建省
//Locality = 福州市
//subLocality = 仓山区
//address = 中国福建省福州市仓山区建新镇
