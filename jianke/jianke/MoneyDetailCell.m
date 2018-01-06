//
//  MoneyDetailCell.m
//  jianke
//
//  Created by 时现 on 15/11/18.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MoneyDetailCell.h"
#import "PayDetailModel.h"
#import "UIImageView+WebCache.h"


@interface MoneyDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *trueNameAndReason;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MoneyDetailCell

+ (instancetype)new{
    static UINib* _nib;
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"MoneyDetailCell" bundle:nil];
    }
    MoneyDetailCell* cell;
    if (_nib) {
        cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)refreshWithData:(PayDetailModel *)model{
    if (model) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.user_profile_url] placeholderImage:nil];
        self.trueNameAndReason.text = model.item_title;
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.actual_amount.intValue*0.01];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
