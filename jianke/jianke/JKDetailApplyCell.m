//
//  JKDetailApplyCell.m
//  jianke
//
//  Created by fire on 16/2/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKDetailApplyCell.h"
#import "JKModel.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "WDConst.h"

@interface JKDetailApplyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


@implementation JKDetailApplyCell

- (void)setModel:(JKModel *)model
{
    _model = model;
    
    // 头像
    self.headerImgView.layer.cornerRadius = 2;
    self.headerImgView.clipsToBounds = YES;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:model.user_profile_url] placeholderImage:[UIImage imageNamed:@"main_icon_avatar"]];
    
    // 用户名
    self.nameLabel.text = model.true_name;
    
    // 日期
    self.dateLabel.font = [UIFont fontWithName:kFont_RSR size:15];
    if (model.stu_work_time_type.integerValue == 2) { // 默认
        
        NSString *startDate = [DateHelper getDateWithNumber:model.stu_work_time.firstObject];
        NSString *endDate = [DateHelper getDateWithNumber:model.stu_work_time.lastObject];
        self.dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startDate, endDate];
        
    } else { // 兼客选择
        self.dateLabel.text = [DateHelper dateRangeStrWithMicroSecondNumArray:model.stu_work_time];
    }
    
    CGFloat height = [self.dateLabel contentSizeWithWidth:SCREEN_WIDTH - 80].height +32 +24;
    model.cellHeight = height > 72 ? height : 72 ;
}


@end
