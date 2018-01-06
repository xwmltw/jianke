//
//  CityTool.h
//  jianke
//
//  Created by fire on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface CityTool : NSObject

+ (void)getAllCityWithBlock:(MKBlock)block; /*!< 所有城市 */
+ (void)getHotCityWithBlock:(MKBlock)block; /*!< 热门城市 */
+ (void)getCurrentCityWithBlock:(MKBlock)block; /*!< 当前城市 */
+ (void)getAllSortCityWithBlock:(MKBlock)block; /*!< 按首字母排序好的所有城市 */
+ (void)getCityFirstLetterArrayWithBlock:(MKBlock)block; /*!< 城市首字母数组 */

+ (void)getAreasWithCityId:(NSNumber *)cityId block:(MKBlock)block; /** 获取cityId所在城市的所有区域 */
+ (void)getAreasOfCurrentCityWithBlock:(MKBlock)block; /** 获取当前城市的所有区域 */
+ (void)getLocalWithBlock:(MKBlock)block; /*!< 获取当前定位信息 */
+ (void)getLocalisShowLoading:(BOOL)isShowLoading block:(MKBlock)block;

+ (void)getCityModelWithCityId:(NSNumber *)cityId block:(MKBlock)block; /** 获取cityId的城市模型 */

@end
