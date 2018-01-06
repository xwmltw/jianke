//
//  PlatOrderCell.m
//  jianke
//
//  Created by yanqb on 2016/11/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PlatOrderCell.h"
#import "PersonServiceModel.h"
#import "DateHelper.h"
#import "UILabel+MKExtension.h"

@interface PlatOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTime1;
@property (weak, nonatomic) IBOutlet UILabel *labTime2;
@property (weak, nonatomic) IBOutlet UILabel *labTime3;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;


@end

@implementation PlatOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPersonalServiceModel:(PersonServiceModel *)personalServiceModel{
    _personalServiceModel = personalServiceModel;
    personalServiceModel.cellHeight = 60.0f;
    self.labTitle.text = personalServiceModel.service_title;
    self.labSalary.text = [NSString stringWithFormat:@"￥%.2f%@", personalServiceModel.salary.value.floatValue, [personalServiceModel.salary getTypeDesc]];
    self.labDate.text = [NSString stringWithFormat:@"￥%@%@", personalServiceModel.salary.value, [personalServiceModel.salary getTypeDesc]];
    self.imgStatus.hidden = (personalServiceModel.status.integerValue != 2);
    
    self.labAddress.text = personalServiceModel.working_place;
    
    NSString *startStr = [DateHelper getDateFromTimeNumber:personalServiceModel.working_time_start_date withFormat:@"M-dd"];
    NSString *endStr = [DateHelper getDateFromTimeNumber:personalServiceModel.working_time_end_date withFormat:@"M-dd"];
    self.labDate.text = [NSString stringWithFormat:@"%@至%@", startStr, endStr];
    self.labTime1.hidden = YES;
    self.labTime2.hidden = YES;
    self.labTime3.hidden = YES;
    if (personalServiceModel.working_time_period.f_start && personalServiceModel.working_time_period.f_end) {
        self.labTime1.hidden = NO;
        personalServiceModel.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.f_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.f_end.longLongValue * 0.001)]];
        self.labTime1.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    if (personalServiceModel.working_time_period.s_start && personalServiceModel.working_time_period.s_end) {
        self.labTime2.hidden = NO;
        personalServiceModel.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.s_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.s_end.longLongValue * 0.001)]];
        self.labTime2.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    if (personalServiceModel.working_time_period.s_start && personalServiceModel.working_time_period.s_end) {
        self.labTime3.hidden = NO;
        personalServiceModel.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.t_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(personalServiceModel.working_time_period.t_end.longLongValue * 0.001)]];
        self.labTime3.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    self.labDetail.text = personalServiceModel.service_desc;
    personalServiceModel.cellHeight += 25.0f;
    
    CGFloat height = [self.labDetail contentSizeWithWidth:SCREEN_WIDTH - 48].height;
    
    //判断是否是三行显示
    height = (height < 54.0f) ? height : 54.0f;
    personalServiceModel.cellHeight += height;
    
    personalServiceModel.cellHeight += 16.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
