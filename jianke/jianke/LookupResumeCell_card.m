//
//  LookupResumeCell_card.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_card.h"
#import "WDConst.h"
#import "NSString+XZExtension.h"

@interface LookupResumeCell_card ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation LookupResumeCell_card

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(JKModel *)model{
    switch (self.cellType) {
        case LookupResumeCellType_studentId:{
            self.labTitle.text = @"学生证号：";
            self.labNum.text = model.stu_id_card_no.length ? model.stu_id_card_no: nil;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.stu_id_card_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
            break;
        case LookupResumeCellType_healthId:{
            self.labTitle.text = @"健康证号：";
            self.labNum.text = model.health_cer_no;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.health_cer_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
