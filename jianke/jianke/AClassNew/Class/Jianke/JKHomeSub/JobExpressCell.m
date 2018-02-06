//
//  JobExpressCell.m
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobExpressCell.h"
#import "JobModel.h"
#import "WDConst.h"
#import "UIImageView+WebCache.h"
@interface JobExpressCell(){
    JobModel* _jobModel;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imgJobType;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsAuth;
@property (weak, nonatomic) IBOutlet UILabel *labJobTItle;
@property (weak, nonatomic) IBOutlet UILabel *labSalaryValue;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgHot;
@property (weak, nonatomic) IBOutlet UIImageView *imgApplyFull;
@property (weak, nonatomic) IBOutlet UIView *botLine;
@property (weak, nonatomic) IBOutlet UILabel *labPayUnit;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTuiJianLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgBaoLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgBao;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLeft;
@property (weak, nonatomic) IBOutlet UIImageView *stcikImg;
@property (weak, nonatomic) IBOutlet UIImageView *salaryGoodIconImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStickLeft;

@property (nonatomic, strong) UIButton *btnCloseSSP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgIconBotton;
@property (weak, nonatomic) IBOutlet UIView *fullView;

@end

@implementation JobExpressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JobExpressCell";
    JobExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.fullView.layer.borderWidth = 0.5;
    cell.fullView.layer.borderColor = [MKCOLOR_RGB(255, 97, 142)CGColor];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"JobExpressCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}


- (void)refreshWithData:(JobModel*)model{
    [self refreshWithData:model andSearchStr:nil];
}

- (void)refreshWithData:(JobModel*)model andSearchStr:(NSString*)searchStr{
    if (model) {
        self.botLine.hidden = NO;
        if (self.isFromEpProfile && self.indexPath) {
            if (self.indexPath.row >= 4) {
                self.botLine.hidden = YES;
            }
        }
        self.fullView.hidden = YES;
        if (model.today_is_can_apply.integerValue == 0) {
            self.fullView.hidden = NO;
        }
        _jobModel = model;
        self.imgHot.hidden = YES;
        self.stcikImg.hidden = YES;
        self.imgBao.hidden = YES;
        self.iconImgView.hidden = YES;
        self.layoutTitleLeft.constant = 8;
        self.layoutTuiJianLeft.constant = 8;
        self.layoutStickLeft.constant = 8;
        self.layoutImgBaoLeft.constant = 8;
        if (model.hot.intValue == 1) {
            self.imgHot.hidden = NO;
            self.layoutTuiJianLeft.constant +=29;
            self.layoutStickLeft.constant += 29;
            self.layoutImgBaoLeft.constant += 29;
            self.layoutTitleLeft.constant += 29;
        }
        if (model.enable_recruitment_service.integerValue == 1) {
            self.imgBao.hidden = NO;
            self.layoutTuiJianLeft.constant +=22;
            self.layoutStickLeft.constant += 22;
            self.layoutTitleLeft.constant += 22;
        }
        if (model.stick.integerValue == 1) {
            self.stcikImg.hidden = NO;
            self.layoutTuiJianLeft.constant +=22;
            self.layoutTitleLeft.constant += 22;
        }
        if (model.is_vip_job.integerValue == 1) {
            self.iconImgView.hidden = NO;
            self.layoutTitleLeft.constant += 22;
        }
//        if (model.enable_recruitment_service.integerValue == 1) {
//            self.imgBao.hidden = NO;
//            if (model.stick.integerValue == 0) {
//                self.stcikImg.hidden = YES;
//                self.layoutTuiJianLeft.constant = 30;
//                self.layoutTitleLeft.constant = 52;
//            }else{
//                self.stcikImg.hidden = NO;
//            }
//        }else{
//            self.imgBao.hidden = YES;
//            if (model.stick.integerValue == 0) {
//                self.stcikImg.hidden = YES;
//                self.layoutTuiJianLeft.constant = 8;
//                self.layoutTitleLeft.constant = 30;
//            }else{
//                self.stcikImg.hidden = NO;
//                self.layoutStickLeft.constant = 8;
//                self.layoutTuiJianLeft.constant = 30;
//                self.layoutTitleLeft.constant = 52;
//            }
//            
//        }
        
        self.imgIsAuth.hidden = model.enterprise_verified.intValue != 3;
        [self.imgJobType sd_setImageWithURL:[NSURL URLWithString:model.job_classfie_img_url] placeholderImage:[UIHelper getDefaultImage]];
        
        if (searchStr && searchStr.length > 0) {
            NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:model.job_title];
            NSRange range = [model.job_title rangeOfString:searchStr];
            if (range.location != NSNotFound) {
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
                self.labJobTItle.attributedText = attributeStr;
            }else{
                self.labJobTItle.text = model.job_title;
            }
        }else{
            self.labJobTItle.text = model.job_title;
            if (model.isReaded) {
                self.labJobTItle.textColor = MKCOLOR_RGBA(34, 58, 80, 0.48);
            } else {
                self.labJobTItle.textColor = MKCOLOR_RGB(34, 58, 80);
            }
        }
        
        NSString *moneyStr = [NSString stringWithFormat:@"%.2f", model.salary.value.floatValue];
        moneyStr = [NSString stringWithFormat:@"%@元", [moneyStr stringByReplacingOccurrencesOfString:@".00" withString:@""]];
        NSString *salaryUnitStr = [NSString stringWithFormat:@"%@", model.salary.getTypeDesc];
        self.labSalaryValue.text = [NSString stringWithFormat:@"%@%@", moneyStr, salaryUnitStr];
        
        self.labPayUnit.text = [model.salary getSettlementDesc];
        
        if (model.job_close_reason.integerValue == 3) {
            self.imgApplyFull.hidden = NO;
            self.imgApplyFull.image = [UIImage imageNamed:@"v3_tag_xiajia"];
        }else{
            self.imgApplyFull.image = [UIImage imageNamed:@"jk_home_applyfull"];
            self.imgApplyFull.hidden = model.has_been_filled.intValue != 1;
        }
        
        NSString* starTime = [DateHelper getDateWithNumber:model.work_time_start];
        NSString* endTime = [DateHelper getDateWithNumber:model.work_time_end];
        self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@",starTime,endTime];
        
        NSString *distanceStr = @"";
        if (model.distance) {
            int dis = model.distance.intValue;
            if (dis < 1000) {
                 distanceStr = [NSString stringWithFormat:@"%dm",dis];
            }else if(dis < 10000){
                float num = dis/1000;
                distanceStr = [NSString stringWithFormat:@"%.1fkm",num];
            }
        }
        
        self.labAddress.text = [NSString stringWithFormat:@"%@ %@", (model.address_area_name.length) ? model.address_area_name : (model.city_name.length) ? model.city_name : model.working_place, distanceStr];
        
        // 专题图标

        self.salaryGoodIconImg.hidden = YES;
        self.layoutImgIconBotton.constant = 39;
        if (model.guarantee_amount_status.integerValue == 1) {
            self.layoutImgIconBotton.constant = 64;
            self.salaryGoodIconImg.hidden = NO;
        }
    }
}


- (void)btnCloseSSPOnclick:(UIButton *)sender{
    [sender removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jobExpressCell_closeSSPAD)]) {
        [self.delegate jobExpressCell_closeSSPAD];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgJobType setCornerValue:25.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
