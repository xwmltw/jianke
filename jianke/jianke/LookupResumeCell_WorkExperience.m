//
//  LookupResumeCell_WorkExperience.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_WorkExperience.h"
#import "WDConst.h"

@interface LookupResumeCell_WorkExperience ()
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;

@end

@implementation LookupResumeCell_WorkExperience

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ResumeExperience *)model{
    if (model.job_begin_time && model.job_end_time) {
        self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@，%@", [DateHelper getDateFromTimeNumber:model.job_begin_time withFormat:@"yyyy/MM/dd"], [DateHelper getDateFromTimeNumber:model.job_end_time withFormat:@"yyyy/MM/dd"], model.job_classify_name];
    }
    self.labTitle.text = model.job_title;
    self.labContent.text = model.job_content.length ? model.job_content: nil;
    
    model.cellHeight = 72 + 16;
    if (!self.labContent.text.length) {
        model.cellHeight -= 8;
    }else{
        model.cellHeight += [self.labContent contentSizeWithWidth:SCREEN_WIDTH - 32].height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
