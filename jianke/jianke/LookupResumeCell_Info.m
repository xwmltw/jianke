//
//  LookupResumeCell_Info.m
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_Info.h"
#import "WDConst.h"

@interface LookupResumeCell_Info ()

@property (weak, nonatomic) IBOutlet UILabel *labTitleName;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitleName;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;


@end

@implementation LookupResumeCell_Info

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellType:(LookupResumeCellType)cellType{
    _cellType = cellType;
    self.labSubTitle.hidden = YES;
    self.labSubTitleName.hidden = YES;
    switch (cellType) {
        case LookupResumeCellType_sex:
        case LookupResumeCellType_height:{
            self.labSubTitle.hidden = NO;
            self.labSubTitleName.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setModel:(JKModel *)model{
    self.labTitle.hidden = NO;
    self.labTitleName.hidden = NO;
    self.backgroundColor = [UIColor clearColor];

    switch (self.cellType) {
        case LookupResumeCellType_jobType:{
            self.labTitleName.text = @"岗位类型：";
            self.backgroundColor = MKCOLOR_RGB(248, 249, 250);
            self.labTitle.text = (model.subscribe_job_classify_str.length) ? model.subscribe_job_classify_str : @"暂未填写";
        }
            break;
        case LookupResumeCellType_jobArea:{
            self.labTitleName.text = @"兼职区域：";
            self.backgroundColor = MKCOLOR_RGB(248, 249, 250);
            self.labTitle.text = (model.subscribe_address_area_str.length) ? model.subscribe_address_area_str: @"暂未填写";
        }
            break;
        case LookupResumeCellType_name:{
            self.labTitleName.text = @"姓名：";
            self.labTitle.text = (model.true_name.length) ? model.true_name: @"-";
        }
            break;
        case LookupResumeCellType_sex:{
            self.labTitleName.text = @"性别：";
            self.labTitle.text = (model.sex.integerValue) ? @"男": @"女";
            self.labSubTitleName.text = @"年龄：";
            if (model.age) {
                self.labSubTitle.text = [NSString stringWithFormat:@"%@", model.age.description];
            }else{
                self.labSubTitle.text = @"-";
            }
        }
            break;
        case LookupResumeCellType_live:{
            self.labTitleName.text = @"居住地：";
            if (model.city_name.length) {
                if (model.address_area_name.length) {
                    self.labTitle.text = [NSString stringWithFormat:@"%@%@", model.city_name, model.address_area_name];
                }else{
                    self.labTitle.text = model.city_name;
                }
            }else{
                self.labTitle.text = @"-";
            }
        }
            break;
        case LookupResumeCellType_account:{
            self.labTitleName.text = @"联系方式: ";
            
            self.labTitle.text = model.telphone;
        }
            break;
        case LookupResumeCellType_personnelCategories:{
            self.labTitleName.text = @"人员类别：";
            if (model.user_type || !self.isLookOther) {
                self.labTitle.text = (model.user_type.integerValue) ? @"学生": @"社会人员";
                
            }else if(!model.user_type && !model.education && !model.school_name.length && !model.profession.length && !model.specialty.length && !model.height.floatValue){
                self.labTitle.hidden = YES;
                self.labTitleName.text = @"他很懒哦,什么都没写~";
            }else{
                self.labTitleName.hidden = YES;
                self.labTitle.hidden = YES;
            }        }
            break;
        case LookupResumeCellType_education:{
            self.labTitleName.text = @"学历：";
            if (model.education) {
                self.labTitle.text = [model getEducationStr];
            }else{
                self.labTitle.text = @"-";
            }
        }
            break;
        case LookupResumeCellType_school:{
            self.labTitleName.text = @"学校/毕业学校：";
            self.labTitle.text = (model.school_name.length) ? model.school_name: @"-";
        }
            break;
        case LookupResumeCellType_professional:{
            self.labTitleName.text = @"专业：";
            self.labTitle.text = (model.profession.length) ? model.profession: @"-";
        }
            break;
        case LookupResumeCellType_speciality:{
            self.labTitleName.text = @"特长：";
            self.labTitle.text = (model.specialty.length) ? model.specialty: @"-";
        }
            break;
        case LookupResumeCellType_height:{
            self.labTitleName.text = @"身高：";
            if (model.height.floatValue) {
                self.labTitle.text = [NSString stringWithFormat:@"%@cm", model.height.description];
            }else{
                self.labTitle.text = @"-";
            }
            self.labSubTitleName.text = @"体重：";
            if (model.weight.floatValue) {
                self.labSubTitle.text = [NSString stringWithFormat:@"%@kg", model.weight.description];
            }else{
                self.labSubTitle.text = @"-";
            }
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
