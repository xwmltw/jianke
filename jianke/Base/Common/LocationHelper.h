//
//  LocationHelper.h
//  jianke
//
//  Created by xiaomk on 15/11/11.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject
+ (id)sharedInstance;

- (void)getGeolocationsCompled:(MKBlock)compled;

@end
