//
//  MANaviPolyline.m
//  jianke
//
//  Created by fire on 15/11/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MANaviPolyline.h"

@implementation MANaviPolyline

- (id)initWithPolyline:(MAPolyline *)polyline
{
    self = [super init];
    if (self)
    {
        self.polyline = polyline;
        self.type = MANaviAnnotationTypeDrive;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate
{
    return [_polyline coordinate];
}

- (MAMapRect) boundingMapRect
{
    return [_polyline boundingMapRect];
}

@end