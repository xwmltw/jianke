//
//  LocationHelper.m
//  jianke
//
//  Created by xiaomk on 15/11/11.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "LocationHelper.h"
#import "WDConst.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationHelper()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation LocationHelper
+ (instancetype)sharedInstance {
    static LocationHelper *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setUp];
    });
    return sharedInstance;
}

- (void)setUp{
    
}

//Impl_SharedInstance(LocationHelper);

- (void)getGeolocationsCompled:(MKBlock)compled{

    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            ELog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }else{
            ELog(@"==location:%@",location);
            if (regeocode) {
                ELog(@"===reGeocode:%@",regeocode);
            }
        }
    }];
}

@end
