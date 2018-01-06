//
//  EditeResumeCell_position.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditeResumeCell_position.h"
#import "WDConst.h"

@interface EditeResumeCell_position ()

@property (weak, nonatomic) IBOutlet UITextField *utfPosition;
@property (weak, nonatomic) IBOutlet UIButton *btnPosition;
- (IBAction)utfOnChange:(UITextField *)sender;

@end

@implementation EditeResumeCell_position

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnPosition addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setJkModel:(JKModel *)jkModel{
    _jkModel = jkModel;
    if (jkModel.obode.length) {
        self.utfPosition.text = jkModel.obode;
    }else{
        self.utfPosition.text = nil;
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(EditeResumeCell_position:)]) {
        [self.delegate EditeResumeCell_position:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)utfOnChange:(UITextField *)sender {
    self.jkModel.obode = sender.text;
}
@end
