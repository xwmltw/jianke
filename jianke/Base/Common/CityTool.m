//
//  CityTool.m
//  jianke
//
//  Created by fire on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "CityTool.h"
#import "WDConst.h"
#import <CoreLocation/CoreLocation.h>
#import "LocateManager.h"

typedef NS_ENUM(NSInteger, CityType) {
    
    CityTypeAllCity = 1,
    CityTypeHotCity,
};


@implementation CityTool

static NSArray *s_allCitys = nil; /*!< 所有城市 */
static NSArray *s_hotCitys = nil; /*!< 热门城市 */
static CityModel *s_currentCity = nil; /*!< 当前城市 */
static NSArray *s_allSortCitys = nil; /*!< 排序好的所有城市 */
static NSArray *s_cityFirstLetters = nil; /*!< 城市首字母数组 */
static LocalModel *s_currentLocal = nil; /** 当前定位信息 */
static NSArray *s_areasOfCurrentCity = nil; /** 当前城市的所有区域 */
static NSArray *s_areasOfCity = nil; /** 某个城市的所有区域 */

/** 获取所有城市列表 */
+ (void)getAllCityWithBlock:(MKBlock)block{
    [self getCityDataWithType:CityTypeAllCity block:block];
}

/** 获取所有热门城市列表 */
+ (void)getHotCityWithBlock:(MKBlock)block{
//    if (s_hotCitys == nil) {
        [self getCityDataWithType:CityTypeHotCity block:block];
//    } else {
//        MKBlockExec(block, s_hotCitys);
//    }
}

/** 获取指定cityId所在城市的所有区域 */
+ (void)getAreasWithCityId:(NSNumber *)cityId block:(MKBlock)block{
    cityId = cityId ? cityId : @(211);
    NSString *content = [NSString stringWithFormat:@"id:%@", cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCityInfo" andContent:content];
    request.isShowLoading = NO;
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response && response.success) {
            
            CityModel *city = [CityModel objectWithKeyValues:response.content[@"city_info"]];
            s_areasOfCity = [CityModel objectArrayWithKeyValuesArray:response.content[@"child_area"]];
            
            // 设置区域的 parent_id && parent_name
            [s_areasOfCity enumerateObjectsUsingBlock:^(CityModel *obj, NSUInteger idx, BOOL *stop) {
                obj.parent_id = city.id;
                obj.parent_name = city.name;
            }];
            
            // 如果是当前城市区域,就保存到当前城市区域
            CityModel *currentCity = [[UserData sharedInstance] city];
            if (currentCity.id.integerValue == cityId.integerValue) {
                s_areasOfCurrentCity = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:s_areasOfCity]];
            }
        }
        MKBlockExec(block, s_areasOfCity);
    }];
}

/** 获取当前城市的所有区域 */
+ (void)getAreasOfCurrentCityWithBlock:(MKBlock)block{
    // 若存在当前城市子区域,则判断当前选择城市是否与子区域对应
    CityModel *currentCity = [[UserData sharedInstance] city];
    if (s_areasOfCurrentCity && currentCity) {
        if ([s_areasOfCurrentCity[0] id].integerValue == currentCity.id.integerValue) {
            MKBlockExec(block, s_areasOfCurrentCity);
        }
    }
    
    WEAKSELF
    if (!s_currentCity) { // 还未获取当前城市
        s_currentCity = [[UserData sharedInstance] city];
        if (!s_currentCity) { // 若之前没保存,则自己定位
            [weakSelf getCurrentCityWithBlock:^(CityModel *currentCity) {
                if (currentCity && currentCity.id != nil) {
                    [weakSelf getAreasWithCityId:currentCity.id block:block];
                }
            }];
        } else {
            [weakSelf getAreasWithCityId:s_currentCity.id block:block];
        }
    } else { // 已经获取当前城市
        [weakSelf getAreasWithCityId:s_currentCity.id block:block];
    }
}


/** 向服务器请求数据 */
+ (void)getCityDataWithType:(CityType)type block:(MKBlock)block
{
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCityList" andContent:@""];
//    request.isShowLoading = NO;
//    request.loadingMessage = @"请求中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            // 所有城市
            s_allCitys = [CityModel objectArrayWithKeyValuesArray:response.content[@"cities"]];
            if (s_allCitys) {
                // 热门城市
                s_hotCitys = [s_allCitys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hotCities == 1"]];
            }
        }
        
        if (type == CityTypeAllCity) {
            MKBlockExec(block, s_allCitys);
        } else if (type == CityTypeHotCity) {
            MKBlockExec(block, s_hotCitys);
        }
    }];
}


/** 返回当前定位的城市 */
+ (void)getCurrentCityWithBlock:(MKBlock)block{
    [self locateWithBlock:block];
}

static LocateManager *s_manager = nil;

/** 定位当前城市 */
+ (void)locateWithBlock:(MKBlock)block{
    WEAKSELF
    [[LocateManager sharedInstance] locateWithBlock:^(LocalModel *local) {
        if (local) { // 定位,获取当前位置成功
            if (s_allCitys == nil) { // 没有城市列表
                [weakSelf getAllCityWithBlock:^(NSArray *allCitys) {
                    if (allCitys == nil) { // 获取城市数据失败
                        [UIHelper toast:@"定位成功,但获取城市数据失败"];
                    } else { // 获取城市数据成功
                        s_currentCity = [weakSelf getCityModelWithLocal:local];
//                        // 保存当前城市
//                        if (s_currentCity) {
//                            [[UserData sharedInstance] setCity:s_currentCity];
//                        }
                        MKBlockExec(block, s_currentCity);
                    }
                }];
            } else { // 已经有城市列表了
                s_currentCity = [weakSelf getCityModelWithLocal:local];
//                // 保存当前城市
                if (s_currentCity) {
                    [[UserData sharedInstance] setLocalCity:s_currentCity];
                }
                MKBlockExec(block, s_currentCity);
            }
        } else {
            MKBlockExec(block, nil);
        }
    }];
}

/** 获取定位信息 */
+ (void)getLocalWithBlock:(MKBlock)block{
    [self getLocalisShowLoading:NO block:block];
}

+ (void)getLocalisShowLoading:(BOOL)isShowLoading block:(MKBlock)block{
    [[LocateManager sharedInstance] locateIsShowLoading:isShowLoading block:^(LocalModel *local){
        if (local) {
            s_currentLocal = local;
        }else{
            if (s_currentLocal) {
                DLog(@"====定位失败，使用之前定位信息");
            }else{
                [UIHelper toast:@"定位失败"];
            }
        }
        MKBlockExec(block, s_currentLocal);
    }];
}



/** 通过定位获取城市模型 */
+ (CityModel *)getCityModelWithLocal:(LocalModel *)local{
    for (CityModel* city in s_allCitys) {
        NSRange range = [local.locality rangeOfString:city.name];
        if (range.length > 0) {
            return city;
        }
    }
    return nil;
}

/** 城市首字母数组 */
+ (void)getCityFirstLetterArrayWithBlock:(MKBlock)block{
//    if (s_cityFirstLetters) {
//        MKBlockExec(block, s_cityFirstLetters);
//        return; //    }
    
    [self getAllCityWithBlock:^(NSArray *allCity) {
        // 获取字母数组
        NSArray *tmpArray = [allCity valueForKeyPath:@"pinyinFirstLetter"];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        
        // 去重
        for (NSString *letter in tmpArray) {
            [tmpDic setObject:letter forKey:letter];
        }
        
        // 排序
        NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        NSArray *descArray = [NSArray arrayWithObject:desc];
        NSArray *sortArray = [tmpDic.allValues sortedArrayUsingDescriptors:descArray];
        
        // 拼音首字母转换为大写
        NSMutableArray *upLetterArray = [NSMutableArray array];
        for (NSString *letter in sortArray) {
            NSString *tmpLetter = [NSString stringWithString:letter.uppercaseString];
            [upLetterArray addObject:tmpLetter];
        }
        
        s_cityFirstLetters = upLetterArray;
        MKBlockExec(block, s_cityFirstLetters);

    }];
}


/** 按首字母排序好的所有城市 */
+ (void)getAllSortCityWithBlock:(MKBlock)block{
//    if (s_allSortCitys) {
//        MKBlockExec(block, s_allSortCitys);
//        return;
//    }
    
    NSMutableArray *sortAllCity = [NSMutableArray array];
    [self getCityFirstLetterArrayWithBlock:^(NSArray *letterArray) {
        for (NSString *letter in letterArray) {
            NSArray *tmpArray = [s_allCitys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pinyinFirstLetter like[cd] %@", letter]];
            [sortAllCity addObject:tmpArray];
        }

        s_allSortCitys = sortAllCity;
        MKBlockExec(block, s_allSortCitys);
        return ;
    }];
}


/** 获取cityId的城市模型 */
+ (void)getCityModelWithCityId:(NSNumber *)cityId block:(MKBlock)block{
    cityId = cityId ? cityId : @(211);
    NSString *content = [NSString stringWithFormat:@"id:%@", cityId];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getCityInfo" andContent:content];
    request.isShowNetworkErrorMsg = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        CityModel *city = nil;
        if (response && response.success) {
            city = [CityModel objectWithKeyValues:response.content[@"city_info"]];
        }
        MKBlockExec(block,city);
    }];
}


@end
