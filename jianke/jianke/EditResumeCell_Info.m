//
//  EditResumeCell_Info.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditResumeCell_Info.h"
#import "WDConst.h"

@interface EditResumeCell_Info ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTip;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UITextField *utf;
- (IBAction)utfOnChange:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;


@end

@implementation EditResumeCell_Info

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.utf.delegate = self;
}

- (void)setJkModel:(JKModel *)jkModel{
    _jkModel = jkModel;
    self.imgIcon.image = [UIImage imageNamed:@"job_icon_push"];
    self.utf.hidden = YES;
    self.labTitle.hidden = NO;
    self.imgIcon.hidden = NO;
    self.btnHelp.hidden = YES;
    switch (self.cellType) {
        case EditResumeCellType_age:{
            self.labTip.text = @"年龄(必选)";
            self.labTitle.text = (jkModel.birthday.length)? [jkModel getAgeStr]: @"请输入年龄";
        }
            break;
        case EditResumeCellType_city:{
            self.labTip.text = @"居住地(必选)";
            if (jkModel.city_name.length) {
                if (jkModel.address_area_name.length) {
                    self.labTitle.text = [NSString stringWithFormat:@"%@%@", jkModel.city_name, jkModel.address_area_name];
                }else{
                    self.labTitle.text = jkModel.city_name;
                }
            }else{
                self.labTitle.text = @"请选择常驻城区";
            }
        }
            break;
        case EditResumeCellType_tel:{
            self.labTip.text = @"联系方式(必填)";
            self.labTitle.text = jkModel.telphone ? jkModel.telphone.description : @"填写联系方式";
        }
            break;
        case EditResumeCellType_education:{
            self.labTip.text = @"学历";
            self.labTitle.text = jkModel.education ? [jkModel getEducationStr]: @"请选择您的学历";
        }
            break;
        case EditResumeCellType_school:{
            self.labTip.text = @"学校/毕业学校";
            self.labTitle.text = (jkModel.school_name.length) ? jkModel.school_name: @"请选择您的学校";
        }
            break;
        case EditResumeCellType_profession:{
            self.labTip.text = @"专业";
            self.utf.hidden = NO;
            self.labTitle.hidden = YES;
            self.imgIcon.hidden = YES;
            self.utf.placeholder = @"限20个字";
            self.utf.text = (jkModel.profession.length) ? jkModel.profession: nil;
        }
            break;
        case EditResumeCellType_speaility:{
            self.labTip.text = @"特长";
            self.utf.hidden = NO;
            self.labTitle.hidden = YES;
            self.imgIcon.hidden = YES;
            self.utf.placeholder = @"限20个字";
            self.utf.text = (jkModel.specialty.length) ? jkModel.specialty: nil;
        }
            break;
        default:
            break;
    }
}

- (void)setModel:(ResumeExperienceModel *)model{
    _model = model;
    self.imgIcon.image = [UIImage imageNamed:@"job_icon_push"];
    self.utf.hidden = YES;
    self.labTitle.hidden = NO;
    self.imgIcon.hidden = NO;
    self.utf.tag = self.postCellType;
    switch (self.postCellType) {
        case postWorkExpCellType_jobType:{
            self.labTip.text = @"岗位分类(必选)";
            self.labTitle.text = (model.job_classify_name.length) ? model.job_classify_name: @"选择岗位分类";
        }
            break;
        case postWorkExpCellType_jobTitle:{
            self.labTip.text = @"岗位名称(必填)";
            self.utf.hidden = NO;
            self.labTitle.hidden = YES;
            self.imgIcon.hidden = YES;
            self.utf.placeholder = @"限20个字";
            self.utf.text = model.job_title.length ? model.job_title: nil;
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

- (IBAction)utfOnChange:(UITextField *)sender {
    if (self.cellType) {
        switch (self.cellType) {
            case EditResumeCellType_profession:{
                self.jkModel.profession = sender.text;
            }
                break;
            case EditResumeCellType_speaility:{
                self.jkModel.specialty = sender.text;
            }
                break;
            default:
                break;
        }
    }else if (self.postCellType){
        switch (self.postCellType) {
            case postWorkExpCellType_jobTitle:{
                self.model.job_title = sender.text;
            }
                break;
            default:
                break;
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 20) { //限制字数
        return NO;
        return YES;
    }
    return YES;
}


@end
