//
//  PayDetailCell.m
//  jianke
//
//  Created by xiaomk on 16/7/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PayDetailCell.h"
#import "PayDetailModel.h"
#import "XSJConst.h"

@interface PayDetailCell(){
    PayDetailModel *_model;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgSex;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UILabel *labWaitAuth;
@property (weak, nonatomic) IBOutlet UILabel *labSalay;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
- (IBAction)sendMessage:(id)sender;

@end

@implementation PayDetailCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PayDetailCell";
    PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PayDetailCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imgHead setCorner];
        [cell.labWaitAuth setCorner];
        [cell.labWaitAuth setBorderWidth:0.5 andColor:[UIColor XSJColor_grayLine]];
    }
    return cell;
}

- (void)refreshWithData:(PayDetailModel *)model{
    if (model) {
        _model = model;
        //头像
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
        
        if (model.sex.intValue == 0) {
            [self.imgSex setImage:[UIImage imageNamed:@"v230_female"]];
        }else{
            [self.imgSex setImage:[UIImage imageNamed:@"v230_male"]];
        }
        
        if (model.payroll_check_status.intValue == 1 && model.payroll_check_name) {
            NSString *name = [NSString stringWithFormat:@"%@(%@)",model.payroll_check_name,model.true_name];
            self.labName.text = name;
        }else{
            self.labName.text = model.true_name;
        }
        
        self.labPhone.text = model.telphone;
        self.labSalay.text = [NSString stringWithFormat:@"%0.2f",((float)model.actual_amount.intValue)/100];
        
        if (model.payroll_check_status.integerValue == 1) {
            self.labWaitAuth.text = @" 未领取 ";
        }else{
            self.labWaitAuth.text = @" 已发放 ";
        }
        self.messageBtn.hidden = !(model.payroll_check_status.integerValue == 1);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendMessage:(id)sender {
    [self.delegate sendMessage:_model];
}
@end
