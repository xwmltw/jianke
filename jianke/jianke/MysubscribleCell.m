//
//  MysubscribleCell.m
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MysubscribleCell.h"
#import "WDConst.h"

@interface MysubscribleCell (){
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDes;
@property (weak, nonatomic) IBOutlet UIButton *btnFouse;
- (IBAction)btnOnClick:(UIButton *)sender;


@end

@implementation MysubscribleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.imgHead setCornerValue:30.0f];
}

- (void)setEpModel:(EPModel *)epModel atIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:epModel.profile_url] placeholderImage:[UIHelper getDefaultHead]];
    self.labName.text = epModel.true_name.length ? epModel.true_name : @"";
    self.labName.textColor = (epModel.sex.integerValue == 1) ? [UIColor XSJColor_base] : [UIColor XSJColor_middelRed];
    self.labDes.text = epModel.desc.length ? epModel.desc : @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mysubscribleCell:atIndexPtah:)]) {
        [self.delegate mysubscribleCell:self atIndexPtah:_indexPath];
    }
}
@end
