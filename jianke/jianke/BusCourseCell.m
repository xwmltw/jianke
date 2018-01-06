//
//  BusCourseCell.m
//  jianke
//
//  Created by fire on 15/11/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//


#import "BusCourseCell.h"
#import "DateHelper.h"
#import "DateTools.h"

@interface BusCourseCell()

@property (weak, nonatomic) IBOutlet UILabel *busTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end


@implementation BusCourseCell



- (void)setTransit:(AMapTransit *)transit
{
    _transit = transit;
    
    // 标题
    NSString *busTitle = @"";
    for (AMapSegment *segment in transit.segments) {

        AMapBusLine *busline = [segment.buslines firstObject];
        
        NSString *busName = nil;
        if (busline && busline.name.length > 0) {
            
            busName = [busline.name substringToIndex:[busline.name rangeOfString:@"("].location]; // 去除详情
            
            if (busTitle.length < 1) {
                busTitle = [NSString stringWithFormat:@"%@", busName];
                
            } else {
                
                busTitle = [NSString stringWithFormat:@"%@ -> %@", busTitle, busName];
            }
        }
    }
    
    self.busTitleLabel.text = busTitle;    
    
    // 时间
    self.timeLabel.text = [DateHelper timeStringWithSecond:transit.duration];
    
    // 距离
    CGFloat distance = transit.walkingDistance;
    
    for (AMapSegment *segment in transit.segments) {
        
        AMapBusLine *busline = [segment.buslines firstObject];
        distance += busline.distance;
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f 公里", distance * 0.001];
}





@end
