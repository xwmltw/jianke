//
//  PersonServDetailCell.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServDetailCell.h"
#import "PersonServiceModel.h"
#import "WDConst.h"

@interface PersonServDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labUnit;
@property (weak, nonatomic) IBOutlet UILabel *labServiceType;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTime1;
@property (weak, nonatomic) IBOutlet UILabel *labTime2;
@property (weak, nonatomic) IBOutlet UILabel *labTime3;
@property (weak, nonatomic) IBOutlet UILabel *labContent;



@end

@implementation PersonServDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(PersonServiceModel *)model{
    model.cellHeight = 185.0f;
    
    self.labTitle.text = model.service_title;
    
    self.labMoney.text = [NSString stringWithFormat:@"￥%.2f%@", model.salary.value.floatValue, [model.salary getTypeDesc]];
    self.labUnit.text = [model.salary getTypeDesc];
    self.labServiceType.text = [model getServiceTypeStr];
    if (model.service_type_classify_name.length) {
        self.labServiceType.text = [self.labServiceType.text stringByAppendingFormat:@" - %@", model.service_type_classify_name];
    }
    self.labAddress.text = model.working_place;
    if (model.working_time_start_date && model.working_time_end_date) {
        NSString *startStr = [DateHelper getDateFromTimeNumber:model.working_time_start_date withFormat:@"yyyy-M-dd"];
        NSString *endStr = [DateHelper getDateFromTimeNumber:model.working_time_end_date withFormat:@"yyyy-M-dd"];
        self.labDate.text = [NSString stringWithFormat:@"%@至%@", startStr, endStr];
    }
    self.labTime1.hidden = YES;
    self.labTime2.hidden = YES;
    self.labTime3.hidden = YES;
    if (model.working_time_period.f_start && model.working_time_period.f_end) {
        self.labTime1.hidden = NO;
        model.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.f_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.f_end.longLongValue * 0.001)]];
        self.labTime1.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    if (model.working_time_period.s_start && model.working_time_period.s_end) {
        self.labTime2.hidden = NO;
        model.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.s_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.s_end.longLongValue * 0.001)]];
        self.labTime2.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    if (model.working_time_period.s_start && model.working_time_period.s_end) {
        self.labTime3.hidden = NO;
        model.cellHeight += 20.0f;
        NSString *startTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.t_start.longLongValue * 0.001)]];
        NSString *endTime = [NSString stringWithFormat:@"%@", [DateHelper getTimeWithNumber:@(model.working_time_period.t_end.longLongValue * 0.001)]];
        self.labTime3.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    self.labContent.text = model.service_desc;
    CGFloat contentHeight = [self.labContent contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    model.cellHeight = model.cellHeight + 30 + contentHeight + 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
