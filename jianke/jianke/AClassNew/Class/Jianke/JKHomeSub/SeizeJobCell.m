//
//  SeizeJobCell.m
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "SeizeJobCell.h"
#import "JobModel.h"
#import "WDConst.h"
#import "TagView.h"
#import "ApplyJobResumeModel.h"


@interface SeizeJobCell(){
    NSMutableArray *_applyJKArray;

    TagView* tagView;
    JobModel* _jobModel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *labJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSalaryValue;
@property (weak, nonatomic) IBOutlet UILabel *labSalaryUnit;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imgHead_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead_2;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead_3;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead_4;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead_5;

@property (weak, nonatomic) IBOutlet UILabel *labApplyCount;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;

@property (weak, nonatomic) IBOutlet UIView *viewTagBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightLayou;


@property (weak, nonatomic) IBOutlet UIButton *totalMoneyBtn;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalMoneyBtnWidthConstraint;



@end

@implementation SeizeJobCell

+ (instancetype)new{
    static UINib* _nib;
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"SeizeJobCell" bundle:nil];
    }
    SeizeJobCell* cell;
    if (_nib) {
        cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    
    return cell;
}

- (void)refreshWithData:(JobModel*)model{
    if (model) {
        _jobModel = model;
        
// =============标签
        NSMutableArray* array = [NSMutableArray arrayWithArray:model.job_label];
//        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"标签1",@"标随碟附送签2",@"标签3",@"随碟附送4",@"标签11", @"标随碟附送签2",@"标随碟附送签2",@"标随碟附送签2",@"标随碟附送签2",nil];

        if (array && array.count > 0) {
            CGRect tagViewFrame = self.viewTagBg.frame;
            tagViewFrame.size.width = SCREEN_WIDTH - 24;
            
            tagView = [[TagView alloc] initWithWidth:(tagViewFrame.size.width)];
            [tagView showTagsWithArray:array isEnable:NO];
            
            CGFloat tagViewBgHeight = [tagView getTagViewHeight];
            self.tagViewHeightLayou.constant = tagViewBgHeight;
            
            [self.viewTagBg addSubview:tagView];
            
            CGRect frame = self.frame;
            frame.size.height = 136 + _tagViewHeightLayou.constant;
            self.frame = frame;
        }else{
            self.tagViewHeightLayou.constant = 0;
            CGRect frame = self.frame;
            frame.size.height = 136;
            self.frame = frame;
        }
       
// =============标签====end

        self.labJobTitle.text = model.job_title;
        
        NSString *moneyStr = [NSString stringWithFormat:@"￥%.1f", model.salary.value.floatValue];
        moneyStr = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];        
        self.labSalaryValue.text = moneyStr;
        self.labSalaryUnit.text = [NSString stringWithFormat:@"%@", model.salary.getTypeDesc];
        self.labSalaryValue.font = [UIFont fontWithName:kFont_RSR size:20];
        
        NSString* starTime = [DateHelper getDateWithNumber:model.work_time_start];
        NSString* endTime = [DateHelper getDateWithNumber:model.work_time_end];
        self.labDate.text = [NSString stringWithFormat:@"%@ 至 %@",starTime,endTime];
        self.labDate.font = [UIFont fontWithName:kFont_RSR size:13];
        
        self.labAddress.text = model.working_place;
        
//        if (model.has_been_filled.intValue == 1) {
//            self.btnApply.enabled = NO;
//        }else{
//            self.btnApply.enabled = YES;
//        }
        if (model.student_applay_status.intValue == 0) {
            if (model.has_been_filled.intValue == 1) {//没报名已经报满
                self.btnApply.enabled = NO;
                [self.btnApply setTitle:@"已报满" forState:UIControlStateDisabled];
                [self.btnApply setBackgroundImage:[UIImage imageNamed:@"ep_apply_btn_1"] forState:UIControlStateDisabled];
            }else{//没报名没报满
                self.btnApply.enabled = YES;
                [self.btnApply setTitle:@"抢单" forState:UIControlStateDisabled];
                [self.btnApply setBackgroundImage:[UIImage imageNamed:@"ep_apply_btn"] forState:UIControlStateNormal];
            }
        }else{
            if (model.has_been_filled.intValue == 1) {//已报名已报满
                self.btnApply.enabled = NO;
                [self.btnApply setTitle:@"已报满" forState:UIControlStateDisabled];
                [self.btnApply setBackgroundImage:[UIImage imageNamed:@"ep_apply_btn_1"] forState:UIControlStateDisabled];
            }else{//已报名没报满
                self.btnApply.enabled = NO;
                [self.btnApply setTitle:@"抢单成功" forState:UIControlStateDisabled];
                [self.btnApply setBackgroundImage:[UIImage imageNamed:@"ep_apply_btn_1"] forState:UIControlStateDisabled];

            }
            
        }
        
//        头像
        self.imgHead_1.hidden = YES;
        self.imgHead_2.hidden = YES;
        self.imgHead_3.hidden = YES;
        self.imgHead_4.hidden = YES;
        self.imgHead_5.hidden = YES;

        NSNumber* applyNum;
        if (model.apply_job_resumes && model.apply_job_resumes.count > 0) {
            applyNum = [NSNumber numberWithInteger:model.apply_job_resumes.count];
            _applyJKArray = [[NSMutableArray alloc] init];
            for (NSDictionary* data in model.apply_job_resumes) {
                ApplyJobResumeModel* model = [ApplyJobResumeModel objectWithKeyValues:data];
                [_applyJKArray addObject:model];
            }
            
            int showHeadNum = (int)((SCREEN_WIDTH-(90+30+12+4+4+12+4))/38);
            
            if (applyNum.intValue < showHeadNum) {
                showHeadNum = applyNum.intValue;
            }
            
            for (int i = 0; i < showHeadNum; i++) {
                ApplyJobResumeModel* applyModel = [_applyJKArray objectAtIndex:i];
                switch (i) {
                    case 0:
                        self.imgHead_1.hidden = NO;
                        [self.imgHead_1 sd_setImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                        [UIHelper setCorner:self.imgHead_1 withValue:2];

                        break;
                    case 1:
                        self.imgHead_2.hidden = NO;
                        [self.imgHead_2 sd_setImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                        [UIHelper setCorner:self.imgHead_2 withValue:2];
                        break;
                    case 2:
                        self.imgHead_3.hidden = NO;
                        [self.imgHead_3 sd_setImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                        [UIHelper setCorner:self.imgHead_3 withValue:2];
                        break;
                    case 3:
                        self.imgHead_4.hidden = NO;
                        [self.imgHead_4 sd_setImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                        [UIHelper setCorner:self.imgHead_4 withValue:2];
                        break;
                    case 4:
                        self.imgHead_5.hidden = NO;
                        [self.imgHead_5 sd_setImageWithURL:[NSURL URLWithString:applyModel.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                        [UIHelper setCorner:self.imgHead_5 withValue:2];
                        break;
                    default:
                        break;
                }
            }
        }else{
            applyNum = @(0);
        }
        
        NSString* applyNumStr = [NSString stringWithFormat:@"%@/%@", applyNum,model.recruitment_num];
        self.labApplyCount.text = applyNumStr;
        self.labApplyCount.font = [UIFont fontWithName:kFont_RSR size:13];
        
        
        // 时薪
        if (model.salary.unit.integerValue == 2) {

            CGFloat workTime = 0;
            WorkTimePeriodModel *workTimeModel = model.working_time_period;
            if (workTimeModel.f_start && workTimeModel.f_end) {
                workTime += [DateHelper hoursBetweenBeginNumber:workTimeModel.f_start andEndNumber:workTimeModel.f_end];
            }
            
            if (workTimeModel.s_start && workTimeModel.s_end) {
                workTime += [DateHelper hoursBetweenBeginNumber:workTimeModel.s_start andEndNumber:workTimeModel.s_end];
            }
            
            if (workTimeModel.t_start && workTimeModel.t_end) {
                workTime += [DateHelper hoursBetweenBeginNumber:workTimeModel.t_start andEndNumber:workTimeModel.t_end];
            }
            
            NSString *totalMoney = [NSString stringWithFormat:@"合计 %.1f/天", model.salary.value.doubleValue * workTime];
            
            totalMoney = [totalMoney stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            CGSize maxSize = CGSizeMake(MAXFLOAT, 22);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
            CGFloat width = [totalMoney boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
            
            self.totalMoneyBtnWidthConstraint.constant = width + 12;
            self.addressLabelTrailingConstraint.constant = self.totalMoneyBtnWidthConstraint.constant + 5;
            self.totalMoneyBtn.hidden = NO;
            self.redView.hidden = NO;
            [self.totalMoneyBtn setTitle:totalMoney forState:UIControlStateNormal];
            self.totalMoneyBtn.titleLabel.font = [UIFont fontWithName:kFont_RSR size:13];
            
        } else {
            
            self.totalMoneyBtnWidthConstraint.constant = 0;
            self.addressLabelTrailingConstraint.constant = self.totalMoneyBtnWidthConstraint.constant + 5;
            self.totalMoneyBtn.hidden = YES;
            self.redView.hidden = YES;
        }
        
        
    }
}




- (IBAction)btnApplyOnClick:(UIButton *)sender {    
    [_delegate cell_btnApplyOnclick:_jobModel];
}

- (IBAction)btnBgOnClick:(UIButton *)sender {
    [_delegate cell_didSelectRowAtIndex:_jobModel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/** 报名列表点击 */
- (IBAction)applyListClick:(UIButton *)sender
{
    [_delegate cell_applyListClick:_jobModel];
}




//- (void)willTransitionToState:(UITableViewCellStateMask)state{
//    [super willTransitionToState:state];
//    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask){
//        [self performSelector:@selector(resurseAndReplaceSubViewIfDeleteConfirmationControl:) withObject:self.subviews afterDelay:0];
//    }
//}
//
////递归和替换子控件,  替换删除按钮
//- (void)resurseAndReplaceSubViewIfDeleteConfirmationControl:(NSArray*)subviews{
//    NSString* deletaBtnName = @"person_resume";
//    for (UIView* subview in subviews) {
//        /**
//         *  ios7
//         */
//        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"]) {
//            UIButton* deleteButton = (UIButton*)subview;
//            [deleteButton setImage:[UIImage imageNamed:deletaBtnName] forState : UIControlStateNormal ];
//            [deleteButton setBackgroundColor:[UIColor whiteColor]];
//            for (UIView* view in subview.subviews) {
//                if ([view isKindOfClass:[UILabel class]]) {
//                    [view removeFromSuperview];
//                }
//            }
//        }
//        
//        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
//            for (UIView* innerSubView in subview.subviews) {
//                if (![innerSubView isKindOfClass:[UIButton class]]) {
//                    [innerSubView removeFromSuperview];
//                }
//            }
//        }
//        
//        if ([subview.subviews count] > 0) {
//            [self resurseAndReplaceSubViewIfDeleteConfirmationControl:subview.subviews];
//        }
//    }
//}

@end
