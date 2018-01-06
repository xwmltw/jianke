//
//  LocateManager.m
//  jianke
//
//  Created by fire on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "LocateManager.h"
#import <CoreLocation/CoreLocation.h>
#import "WDConst.h"
#import "LocalModel.h"
#import "JZLocationConverter.h"
#import "WDLoadingView.h"

@interface LocateManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locateManager; /*!< 定位管理 */
@property (nonatomic, copy) MKBlock block; /*!< 回调block */
@property (nonatomic, assign) BOOL isShowLonging;
@end

@implementation LocateManager

Impl_SharedInstance(LocateManager);

//static MBProgressHUD* HUD;

- (void)locateWithBlock:(MKBlock)block{
    [self locateIsShowLoading:NO block:block];
}


- (void)locateIsShowLoading:(BOOL)isShowLonging block:(MKBlock)block {
    self.isShowLonging = isShowLonging;
    if (![CLLocationManager locationServicesEnabled]) {
        [UIHelper toast:@"不支持定位服务"];
        block(nil);
        return;
    }    
    
    CLLocationManager *locateManager = [[CLLocationManager alloc] init];
    locateManager.delegate = self;
    locateManager.desiredAccuracy = kCLLocationAccuracyBest;
    locateManager.distanceFilter = 100;
    self.locateManager = locateManager;
    self.block = block;
    
    if ([locateManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locateManager requestWhenInUseAuthorization];
    } else {
        [self.locateManager startUpdatingLocation];
        [UIHelper showLoading:YES withMessage:@"定位中"];
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    ELog(@"xxxxxxxxxxx请求定位xxxxxxxxxxxx");
    [UIHelper showLoading:NO withMessage:@"定位成功"];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }
            break;
        default:
        {
            [self.locateManager startUpdatingLocation];
            if (self.isShowLonging) {
                [UIHelper showLoading:YES withMessage:@"定位中"];
            }
        }
            break;
    }
}

/** 定位成功 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    ELog(@"xxxxxxxxxxx定位xxxxxxxxxxxx");
    if (self.isShowLonging) {
        [UIHelper showLoading:NO withMessage:@"定位中"];
    }

    [self.locateManager stopUpdatingLocation];
    LocalModel *local = [[LocalModel alloc] init];
    CLLocation *newLocation = locations.firstObject;
    CLLocationCoordinate2D coord = [JZLocationConverter wgs84ToGcj02:[newLocation coordinate]];
    
    local.latitude = [NSString stringWithFormat:@"%f", coord.latitude];
    local.longitude = [NSString stringWithFormat:@"%f", coord.longitude];
    
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        if(error == nil && [placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            local.country = placemark.country;
            local.administrativeArea = placemark.administrativeArea;
            local.subAdministrativeArea = placemark.subAdministrativeArea;
            local.locality = placemark.locality;
            local.subLocality = placemark.subLocality;
            local.thoroughfare = placemark.thoroughfare;
            local.subThoroughfare = placemark.subThoroughfare;
            local.postalCode = placemark.postalCode;
            local.address = placemark.name;
            
            
            ELog(@"== placemark:%@", placemark.addressDictionary);
            ELog(@"==localModel:%@",[local simpleJsonString]);
            
            // 保存定位信息
            [[UserData sharedInstance] setLocal:local];
            [XSJUserInfoData activateDevice];
            //             UserData *user = [UserData sharedInstance];
            //             user.local = local;
            
            if (self.block) {
                self.block(local);
            }
        }else if(error == nil && [placemarks count] == 0){
            ELog(@"No results were returned.");
            if (self.block) {
                self.block(nil);
            }
        }else if(error != nil) {
            ELog(@"An error occurred = %@", error);
            if (self.block) {
                self.block(nil);
            }
        }
    }];
}

/** 定位失败 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [UIHelper showLoading:NO withMessage:@"定位中"];
    [self.locateManager stopUpdatingLocation];
    if (self.block) {
        self.block(nil);
    }
}


@end
