//
//  LineDashPolyline.h
//  jianke
//
//  Created by fire on 15/11/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <MAMapKit/MAPolyline.h>
#import <MAMapKit/MAOverlay.h>

@interface LineDashPolyline :NSObject <MAOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

@property (nonatomic, retain)  MAPolyline *polyline;

- (id)initWithPolyline:(MAPolyline *)polyline;

@end

