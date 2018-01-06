//
//  JobDetailCell_Info2.m
//  jianke
//
//  Created by yanqb on 2017/4/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobDetailCell_Info2.h"
#import "JobModel.h"
#import "WDConst.h"

@interface JobDetailCell_Info2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labsubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labCompany;
@property (weak, nonatomic) IBOutlet UIImageView *imageAuthentication;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCenter;


@end

@implementation JobDetailCell_Info2
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JobDetailCell_Info2";
    JobDetailCell_Info2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"JobDetailCell_Info2" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.imgHead setCornerValue:28.0f];
    }
    return cell;
}


- (void)setJobModel:(JobModel *)jobModel{
    _jobModel = jobModel;
    
    self.imageAuthentication.hidden = YES;
    if (jobModel.enterprise_info.verifiy_status.integerValue == 3) {
        self.imageAuthentication.hidden = NO;
    }
    
    
    
    
    self.labName.text = jobModel.enterprise_info.true_name.length ? jobModel.enterprise_info.true_name : nil;

    if (!jobModel.enterprise_info.industry_name.length && !jobModel.enterprise_info.enterprise_name.length) {
        self.layoutNameTop.constant = 18;
    }else if (!jobModel.enterprise_info.enterprise_name.length){
        self.layoutNameTop.constant = 5;
        self.layoutTop.constant = 10;
    }else if (!jobModel.enterprise_info.industry_name.length){
        self.layoutNameTop.constant = 5;
        self.layoutCenter.constant = 15;
    }
    
    if (jobModel.enterprise_info.enterprise_name.length) {
        self.labCompany.text = jobModel.enterprise_info.enterprise_name;
    }else{
        self.labCompany.text = nil;
    }
    

    if (jobModel.enterprise_info.industry_name.length) {
        if ([jobModel.enterprise_info.industry_name isEqualToString:@"其他行业"] && jobModel.enterprise_info.industry_desc.length) {
            self.labsubTitle.text = [NSString stringWithFormat:@"%@-%@",jobModel.enterprise_info.industry_name,jobModel.enterprise_info.industry_desc];
        }else{
            self.labsubTitle.text = jobModel.enterprise_info.industry_name;
        }
    }else{
        self.labsubTitle.text = nil;
    }
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:jobModel.enterprise_info.profile_url] placeholderImage:[UIHelper getDefaultHead]];    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
