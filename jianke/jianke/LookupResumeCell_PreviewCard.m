//
//  LookupResumeCell_PreviewCard.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_PreviewCard.h"
#import "WDConst.h"

@interface LookupResumeCell_PreviewCard ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIView *line;


@end

@implementation LookupResumeCell_PreviewCard

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(JKModel *)model{
    switch (self.cellType) {
        case LookupResumeCellType_previewStudentId:{
            self.labTitle.text = @"学生证";
            self.imgIcon.hidden = (model.stu_id_card_no == nil);
        }
            break;
        case LookupResumeCellType_previewHealthId:{
            self.labTitle.text = @"健康证";
            self.imgIcon.hidden = (model.health_cer_no == nil);
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
