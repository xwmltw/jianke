//
//  JobBillDetailCell.m
//  jianke
//
//  Created by 时现 on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobBillDetailCell.h"
#import "JobBillModel.h"
#import "UIImageView+WebCache.h"
#import "UIHelper.h"
#import "WDConst.h"

@interface JobBillDetailCell()
{
    PayListModel *_plModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgSex;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSalary;

@end
@implementation JobBillDetailCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JobBillDetailCell";
    JobBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"JobBillDetailCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)refreshWithData:(PayListModel*)data{
    if (data) {
        _plModel = data;
        
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_plModel.profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];

        //姓名
        self.labName.text = _plModel.true_name;
        
        //性别
        if (_plModel.sex.intValue == 0) {
            [self.imgSex setImage:[UIImage imageNamed:@"v230_female"]];
        }else{
            [self.imgSex setImage:[UIImage imageNamed:@"v230_male"]];
        }
        
        self.labSalary.font = [UIFont fontWithName:kFont_RSR size:20];
        self.labSalary.text = [NSString stringWithFormat:@"%.2f",_plModel.ent_publish_price.intValue * 0.01];
    }
}

@end
