//
//  ApplyJKCell.m
//  jianke
//
//  Created by fire on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ApplyJKCell.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "UIHelper.h"

@interface ApplyJKCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView; /*!< 头像 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; /*!< 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; /*!< 日期 */
@property (weak, nonatomic) IBOutlet UILabel *stateLaebl; /*!< 状态 */


@end


@implementation ApplyJKCell


- (void)setModel:(JKModel *)model
{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
    
    self.nameLabel.text = model.true_name;
    
    if (model.stu_work_time_type.integerValue == 1) { // 兼客选择
                
        self.dateLabel.text = [DateHelper dateRangeStrWithSecondNumArray:model.stu_work_time];
        
    } else { // 默认
        
        NSString *starTimeStr = [DateHelper getDateWithNumber:model.stu_work_time.firstObject];
        NSString *endTimeStr = [DateHelper getDateWithNumber:model.stu_work_time.lastObject];
        
        self.dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@", starTimeStr, endTimeStr];
    }
    
    if (model.trade_loop_status.intValue == 1) {
        if (model.ent_read_resume_time) {
            
            self.stateLaebl.text = @"简历被查看";
        }else{
            
            self.stateLaebl.text = @"已报名";
        }
    }else if (model.trade_loop_status.intValue == 2){
        
        self.stateLaebl.text = @"录用成功";
    }else if (model.trade_loop_status.intValue == 3){
        
        if (model.trade_loop_finish_type.intValue == 3 || model.trade_loop_finish_type.intValue == 4 || model.trade_loop_finish_type.intValue == 6) {
            self.stateLaebl.text = @"录用成功";
        }
    }
    
    
}

@end
