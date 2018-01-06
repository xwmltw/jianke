//
//  MenuDelegate.m
//  jianke
//
//  Created by fire on 15/12/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MenuDataSource.h"
#import "CityModel.h"
#import "CityTool.h"    
#import "UserData.h"
#import "CollectionViewCellModel.h"
#import "TableViewCellModel.h"
#import "JobClassifierModel.h"

typedef NS_ENUM(NSInteger, kColumOfMenu) {
    
    kColumOfMenuPosition = 0,
    kColumOfMenuJobType,
    kColumOfMenuTime,
    kColumOfMenuUnit
};


@interface MenuDataSource ()

@property (nonatomic, assign) NSInteger positionIndex;
@property (nonatomic, assign) NSInteger jobTypeIndex;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, assign) NSInteger unitIndex;

@property (nonatomic, strong) NSMutableArray *positionArray;
@property (nonatomic, strong) NSMutableArray *jobTypeArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *unitArray;

@end

@implementation MenuDataSource


#pragma mark - LifeCircle
- (instancetype)init{
    if (self = [super init]) {
        self.positionIndex = 0;
        self.jobTypeIndex = 0;
        self.timeIndex = 0;
        self.unitIndex = 0;
    
        [self getData];
    }
    return self;
}


#pragma mark - Data
- (void)getData{
    [self getPositionData];
    [self getJobTypeData];
    [self getTimeData];
    [self getUniData];
}

- (void)resetData{
    self.positionIndex = 0;
    self.jobTypeIndex = 0;
    self.timeIndex = 0;
    self.unitIndex = 0;
}

- (void)getPositionData{
    WEAKSELF
    CityModel *city = [[UserData sharedInstance] city];
    [CityTool getAreasWithCityId:city.id block:^(NSArray *areaArray) {
        
        // 子区域
        weakSelf.positionArray = [CollectionViewCellModel cellArrayWithAreaArray:areaArray];
        
        // 全福州 && 附近
        CityModel *savedCuttentCity = [[UserData sharedInstance] city];
        LocalModel *savedlocal = [[UserData sharedInstance] local];
        if (savedCuttentCity) { // 有保存城市
            
            CollectionViewCellModel *parentArea = [[CollectionViewCellModel alloc] init];
            parentArea.model = savedCuttentCity;
            parentArea.name = [NSString stringWithFormat:@"全%@", savedCuttentCity.name];
            parentArea.type = CollectionViewCellModelTypeParentOption;
            parentArea.selected = YES;
            if (weakSelf.positionArray.count) {
                [weakSelf.positionArray insertObject:parentArea atIndex:0];
            }else{
                [weakSelf.positionArray addObject:parentArea];
            }
            
//            // 附近
//            CollectionViewCellModel *nearby = [[CollectionViewCellModel alloc] init];
//            nearby.type = CollectionViewCellModelTypeDefault;
//            nearby.selected = NO;
//            nearby.name = @"定位失败";
//            if (weakSelf.positionArray.count >= 2) {
//                [weakSelf.positionArray insertObject:nearby atIndex:1];
//            }else{
//                [weakSelf.positionArray addObject:nearby];
//            }
//
//            if (savedlocal) {
//                nearby.model = savedlocal;
//                nearby.name = @"离我最近";
//            } else if([CLLocationManager locationServicesEnabled]) {
//                [CityTool getLocalWithBlock:^(LocalModel *local) {
//                    if (local) {
//                        nearby.model = local;
//                        nearby.name = @"离我最近";
//                    }
//                }];
//            }
        } else { // 没保存城市, 也没定位信息
            [CityTool getCurrentCityWithBlock:^(CityModel *currentCity) {
                CollectionViewCellModel *parentArea = [[CollectionViewCellModel alloc] init];
                parentArea.model = currentCity;
                parentArea.name = [NSString stringWithFormat:@"全%@", currentCity.name];
                parentArea.type = CollectionViewCellModelTypeParentOption;
                parentArea.selected = YES;
                if (weakSelf.positionArray.count) {
                    [weakSelf.positionArray insertObject:parentArea atIndex:0];
                }else{
                    [weakSelf.positionArray addObject:parentArea];
                }
                
//                // 附近
//                [CityTool getLocalWithBlock:^(LocalModel *local) {
//                    CollectionViewCellModel *nearby = [[CollectionViewCellModel alloc] init];
//                    nearby.type = CollectionViewCellModelTypeDefault;
//                    nearby.selected = NO;
//                    nearby.name = @"定位失败";
//                    if (local) {
//                        nearby.model = local;
//                        nearby.name = @"离我最近";
//                    }
//                    if (weakSelf.positionArray.count >= 2) {
//                        [weakSelf.positionArray insertObject:nearby atIndex:1];
//                    }else{
//                        [weakSelf.positionArray addObject:nearby];
//                    }
//                }];
            }];
        }
    }];
}

- (void)getJobTypeData{
    WEAKSELF
    // 获取岗位分类
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobArray) {
        weakSelf.jobTypeArray = [CollectionViewCellModel cellArrayWithJobArray:jobArray];
        // 不限
        CollectionViewCellModel *all = [[CollectionViewCellModel alloc] init];
        all.model = nil;
        all.name = @"不限";
        all.type = CollectionViewCellModelTypeDefault;
        all.selected = YES;
        if (weakSelf.jobTypeArray.count) {
            [weakSelf.jobTypeArray insertObject:all atIndex:0];
        }else{
            [weakSelf.jobTypeArray addObject:all];
        }
    }];
}


- (void)getTimeData{
    self.timeArray = [NSMutableArray array];
    TableViewCellModel *data5 = [[TableViewCellModel alloc] init];
    data5.title = @"不限";
    data5.index = 0;
    [self.timeArray addObject:data5];
    
    TableViewCellModel *data2 = [[TableViewCellModel alloc] init];
    data2.title = @"当天结算";
    data2.index = 1;
    [self.timeArray addObject:data2];
    
    TableViewCellModel *data3 = [[TableViewCellModel alloc] init];
    data3.title = @"周末结算";
    data3.index = 2;
    [self.timeArray addObject:data3];
    
    TableViewCellModel *data1 = [[TableViewCellModel alloc] init];
    data1.title = @"月末结算";
    data1.index = 3;
    [self.timeArray addObject:data1];
    
    TableViewCellModel *data4 = [[TableViewCellModel alloc] init];
    data4.title = @"完工结算";
    data4.index = 4;
    [self.timeArray addObject:data4];
    
}

- (void)getUniData{
    self.self.unitArray = [NSMutableArray array];
    
    TableViewCellModel *data5 = [[TableViewCellModel alloc] init];
    data5.title = @"默认排序";
    data5.index = 1;
    [self.self.unitArray addObject:data5];
    
    TableViewCellModel *data4 = [[TableViewCellModel alloc] init];
    data4.title = @"离我最近";
//    data4.index = 2;
    [self.self.unitArray addObject:data4];
    
    TableViewCellModel *data2 = [[TableViewCellModel alloc] init];
    data2.title = @"最新发布";
    data2.index = 2;
    [self.self.unitArray addObject:data2];

    
    TableViewCellModel *data1 = [[TableViewCellModel alloc] init];
    data1.title = @"人气";
    data1.index = 3;
    [self.self.unitArray addObject:data1];
    
    
//    TableViewCellModel *data3 = [[TableViewCellModel alloc] init];
//    data3.title = @"元/月";
//    data3.index = 3;
//    [self.self.unitArray addObject:data3];
    
    
}

#pragma mark - JSDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
    return 4;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column == kColumOfMenuPosition || column == kColumOfMenuJobType) {
        return YES;
    }
    return NO;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column{
    switch (column) {
        case kColumOfMenuPosition:
            return self.positionIndex;
            break;
        case kColumOfMenuJobType:
            return self.jobTypeIndex;
            break;
        case kColumOfMenuTime:
            return self.timeIndex;
            break;
        case kColumOfMenuUnit:
            return self.unitIndex;
            break;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    switch (column) {
        case kColumOfMenuPosition:
            return self.positionArray.count;
            break;
        case kColumOfMenuJobType:
            return self.jobTypeArray.count;
            break;
        case kColumOfMenuTime:
            return self.timeArray.count;
            break;
        case kColumOfMenuUnit:
            return self.unitArray.count;
            break;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case kColumOfMenuPosition:
            return @"位置";
            break;
        case kColumOfMenuJobType:
            return @"岗位";
            break;
        case kColumOfMenuTime:
            return @"结算方式";
            break;
        case kColumOfMenuUnit:
            return @"默认排序";
            break;
    }
    return nil;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath{
    switch (indexPath.column) {
        case kColumOfMenuPosition:
        {
            CollectionViewCellModel *model = self.positionArray[indexPath.row];
            return model.name;
        }
            break;
        case kColumOfMenuJobType:
        {
            CollectionViewCellModel *model = self.jobTypeArray[indexPath.row];
            return model.name;
        }
            break;
        case kColumOfMenuTime:
        {
            TableViewCellModel *model = self.timeArray[indexPath.row];
            return model.title;
        }
            break;
        case kColumOfMenuUnit:
        {
            TableViewCellModel *model = self.unitArray[indexPath.row];
            return model.title;
        }
            break;
    }

    return nil;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{
   
    switch (indexPath.column) {
        case kColumOfMenuPosition:
        {
            self.positionIndex = indexPath.row;
        }
            break;
        case kColumOfMenuJobType:
        {
            self.jobTypeIndex = indexPath.row;
        }
            break;
        case kColumOfMenuTime:
        {
            self.timeIndex = indexPath.row;
        }
            break;
        case kColumOfMenuUnit:
        {
            self.unitIndex = indexPath.row;
        }
            break;
    }
    [self componentRequestStrWithMenu:menu];
}


- (void)componentRequestStrWithMenu:(JSDropDownMenu *)menu{
    
    //
    
    NSMutableString *choose = [[NSMutableString alloc] init];
    // 城市ID
    NSString *cityID = nil;
    
    if (menu.isViewAllParttime) {
        cityID = [NSString stringWithFormat:@"query_condition:{city_id:%@",[[UserData sharedInstance] city].id];
    }else{
        if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
            cityID = [NSString stringWithFormat:@"query_condition:{city_id:%@, through:1",[[UserData sharedInstance] city].id];
        }else{
            cityID = [NSString stringWithFormat:@"query_condition:{city_id:%@",[[UserData sharedInstance] city].id];
        }
    }
    
    [choose appendString:cityID];
    
    NSString *positionStr1 = @"";
    LocalModel *local = [[UserData sharedInstance] local];
    if (local) {
        positionStr1 = [NSString stringWithFormat:@", coord_latitude:\"%@\",coord_longitude:\"%@\"", local.latitude, local.longitude];
    } else {
        positionStr1 = @"";
    }
    
    [choose appendString:positionStr1];
    // 位置
    if(self.unitIndex != 1){
        if (self.positionIndex != 0) {
            NSString *positionStr = @"";
            CollectionViewCellModel *model =  self.positionArray[self.positionIndex];
            if (model.type == CollectionViewCellModelTypeDefault) { // 附近
            } else { // 子区域
                CityModel *city = model.model;
                positionStr = [NSString stringWithFormat:@", address_area_id:\"%@\", coord_use_type:\"1\"", city.id];
            }
            [choose appendString:positionStr];
        }else{
            [choose appendString:@", coord_use_type:\"1\""];
        }
    }

    // 岗位
    if (self.jobTypeIndex != 0) {
        
        NSString *jobStr = nil;
        CollectionViewCellModel *model =  self.jobTypeArray[self.jobTypeIndex];
        // 一种岗位, 其他
        JobClassifierModel *job = model.model;
        jobStr = [NSString stringWithFormat:@", job_type_id:[%@]", job.job_classfier_id];
        [choose appendString:jobStr];
    }
    
    
    //  结算方式
    if (self.timeIndex != 0) {
        TableViewCellModel *model = self.timeArray[self.timeIndex];
        NSString *timeCondition = [NSString stringWithFormat:@", settlement_way:%ld", (long)model.index];
        [choose appendString:timeCondition];
    }
    
    // 排序
    if (self.unitIndex != 0) {
        if (self.unitIndex == 1) {
            [choose appendString:@""];
        }else{
            TableViewCellModel *model = self.unitArray[self.unitIndex];
            NSString *moneyCondition = [NSString stringWithFormat:@", sort_type:%ld", (long)model.index];
            [choose appendString:moneyCondition];
        }
    }
    
    [choose appendString:@"}"];
    if ([menu.selectDelegate respondsToSelector:@selector(menu:didSelectResult:)]) {
        [menu.selectDelegate menu:menu didSelectResult:choose];
    }
}


@end
