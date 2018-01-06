//
//  JoinJKCell_custome.m
//  jianke
//
//  Created by yanqb on 2016/12/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JoinJKCell_custome.h"
#import "UIColor+Extension.h"
#import "ParamModel.h"
#import "Masonry.h"
#import "WDConst.h"

@interface JoinJKCell_custome ()

@property (nonatomic, strong) UILabel *labTip;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) PostResumeInfoPM *resumeInfoRM;
@property (nonatomic, assign) JoinJKCellType cellType;

@end

@implementation JoinJKCell_custome

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.labTip = [UILabel labelWithText:@"年龄" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.labTitle.font = [UIFont systemFontOfSize:15.0f];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    [self.contentView addSubview:self.labTip];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:line];
    
    [self.labTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(16);
    }];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTip.mas_bottom).offset(4);
        make.left.equalTo(self.labTip);
    }];
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.7);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PostResumeInfoPM *)model cellType:(JoinJKCellType)cellType{
    self.resumeInfoRM = model;
    self.cellType = cellType;
    
    switch (cellType) {
        case JoinJKCellType_Birthday:{
            self.labTip.text = @"年龄";
            if (model.birthday.length) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:model.birthday];
                NSInteger year = [DateHelper compareYearsFromDate:date toDate:[NSDate date]];
                self.labTitle.text = [NSString stringWithFormat:@"%ld岁", year];
            }else{
                self.labTitle.text = @"选择年龄";
            }
            
//            self.labTitle.text = (!model.birthday.length) ? @"年龄" : model.birthday;
            self.imgIcon.image = [UIImage imageNamed:@"job_icon_xia"];
        }
            break;
        case JoinJKCellType_City:{
            self.labTip.text = @"居住地";
            NSString *str = @"";
            if (model.city_id) {
                str = [str stringByAppendingString:model.city_name];
            }
            if (model.address_area_id) {
                str = [str stringByAppendingString:model.area_name];
            }
            self.labTitle.text = (str.length)? str: @"选择当前居住城市、区域";
            self.imgIcon.image = [UIImage imageNamed:@"job_icon_push"];
        }
            break;
        case JoinJKCellType_Area:{
            self.labTitle.text = (model.address_area_id) ? model.area_name: @"选择常驻的城市、区域";
            self.imgIcon.image = [UIImage imageNamed:@"job_icon_push"];
        }
            break;
        default:
            break;
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
