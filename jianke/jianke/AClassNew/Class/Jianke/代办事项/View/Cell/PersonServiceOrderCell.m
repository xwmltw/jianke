//
//  PersonServiceOrderCell.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceOrderCell.h"
#import "PersonServiceModel.h"
#import "DateHelper.h"
#import "UILabel+MKExtension.h"
#import "UIView+MKExtension.h"
#import "UIColor+Extension.h"

@interface PersonServiceOrderCell (){
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak, nonatomic) IBOutlet UIView *redPoint1;
@property (weak, nonatomic) IBOutlet UIView *redPoint2;
@property (weak, nonatomic) IBOutlet UIView *redPoint3;

@property (weak, nonatomic) IBOutlet UILabel *labSatus1;
@property (weak, nonatomic) IBOutlet UILabel *labstatus2;
@property (weak, nonatomic) IBOutlet UILabel *labstatus3;

@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UIView *bgview;



@end

@implementation PersonServiceOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.redPoint1 setCornerValue:3.0f];
    [self.redPoint2 setCornerValue:3.0f];
    [self.redPoint3 setCornerValue:3.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setPersonServiceModel:(PersonServiceModel *)personServiceModel{
    _personServiceModel = personServiceModel;
    personServiceModel.cellHeight = 80.0f;
    self.labTitle.text = personServiceModel.service_title;
    self.labSalary.text = [NSString stringWithFormat:@"￥%.2f%@",personServiceModel.salary.value.floatValue ,[personServiceModel.salary getTypeDesc]];
    self.labAddress.text = personServiceModel.working_place;
    
    //工作日期
    NSString* starTime = [DateHelper getDateWithNumber:@(personServiceModel.working_time_start_date.longLongValue * 0.001)];
    NSString* endTime = [DateHelper getDateWithNumber:@(personServiceModel.working_time_end_date.longLongValue * 0.001)];
    self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@",starTime,endTime];
    
    //工作时间段
    NSString *workTimePeriod = @"";
    if (personServiceModel.working_time_period.f_start && personServiceModel.working_time_period.f_end) {
        workTimePeriod = [workTimePeriod stringByAppendingFormat:@"%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.f_start.longLongValue * 0.001)]];
        workTimePeriod = [workTimePeriod stringByAppendingFormat:@"~%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.f_end.longLongValue * 0.001)]];
    }
    if (personServiceModel.working_time_period.s_start && personServiceModel.working_time_period.s_end) {
        workTimePeriod = [workTimePeriod stringByAppendingFormat:@",%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.s_start.longLongValue * 0.001)]];
        workTimePeriod = [workTimePeriod stringByAppendingFormat:@"~%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.s_end.longLongValue * 0.001)]];
    }
    if (personServiceModel.working_time_period.t_start && personServiceModel.working_time_period.t_end) {

        workTimePeriod = [workTimePeriod stringByAppendingFormat:@",%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.t_start.longLongValue * 0.001)]];
        workTimePeriod = [workTimePeriod stringByAppendingFormat:@"~%@", [DateHelper getTimeWithNumber:@(personServiceModel.working_time_period.t_end.longLongValue * 0.001)]];
    }
    self.labTime.text = workTimePeriod;
    self.redPoint1.hidden = NO;
    self.redPoint2.hidden = NO;
    self.redPoint3.hidden = NO;
    
    self.labSatus1.hidden = NO;
    self.labstatus2.hidden = NO;
    self.labstatus3.hidden = NO;
    
    switch (personServiceModel.apply_status.integerValue) {
        case 1:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labSatus1.text = @"待报名";
            self.labSatus1.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus2.text = @"待确认";
            self.labstatus2.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
        
            self.redPoint3.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus3.text = @"待沟通";
            self.labstatus3.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.labStatus.text = @"待您确认";
            personServiceModel.cellHeight += 82.0f;
        }
            break;
        case 2:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已报名";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus2.text = @"待确认";
            self.labstatus2.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.redPoint3.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus3.text = @"待沟通";
            self.labstatus3.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
        
            self.labStatus.text = @"待对方确认";
            personServiceModel.cellHeight += 82.0f;
        }
            break;
        case 3:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已拒绝";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.hidden = YES;
            self.redPoint3.hidden = YES;
            
            self.labstatus2.hidden = YES;
            self.labstatus3.hidden = YES;
            
            self.labStatus.text = @"已拒绝";
            personServiceModel.cellHeight += 30.0f;
        }
            break;
        case 4:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已报名";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_base];
            self.labstatus2.text = @"已确认";
            self.labstatus2.textColor = [UIColor XSJColor_base];
            
            self.redPoint3.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus3.text = @"待沟通";
            self.labstatus3.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.labStatus.text = @"待对方联系";
            personServiceModel.cellHeight += 82.0f;
        }
            break;
        case 5:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已报名";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_base];
            self.labstatus2.text = @"不合适";
            self.labstatus2.textColor = [UIColor XSJColor_base];
            
            self.redPoint3.hidden = YES;
            self.labstatus3.hidden = YES;
            
            self.labStatus.text = @"不合适";
            personServiceModel.cellHeight += 56.0f;
        }
            break;
        case 6:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已报名";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_base];
            self.labstatus2.text = @"已确认";
            self.labstatus2.textColor = [UIColor XSJColor_base];
            
            self.redPoint3.backgroundColor = [UIColor XSJColor_base];
            self.labstatus3.text = @"已沟通";
            self.labstatus3.textColor = [UIColor XSJColor_base];
            
            self.labStatus.text = @"已完成";
            personServiceModel.cellHeight += 82.0f;
        }
            break;
        case 7:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已取消";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.hidden = YES;
            self.redPoint3.hidden = YES;
            
            self.labstatus2.hidden = YES;
            self.labstatus3.hidden = YES;
            
            self.labStatus.text = @"对方已取消";
            personServiceModel.cellHeight += 30.0f;
        }
            break;
        default:{
            self.redPoint1.backgroundColor = [UIColor XSJColor_base];
            self.labSatus1.text = @"已报名";
            self.labSatus1.textColor = [UIColor XSJColor_base];
            
            self.redPoint2.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus2.text = @"待确认";
            self.labstatus2.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.redPoint3.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent32];
            self.labstatus3.text = @"待沟通";
            self.labstatus3.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
            
            self.labStatus.text = @"待对方确认";
            personServiceModel.cellHeight += 82.0f;
        }
            break;
    }
    
    personServiceModel.cellHeight += 57.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
