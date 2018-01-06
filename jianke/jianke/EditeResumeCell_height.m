//
//  EditeResumeCell_height.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditeResumeCell_height.h"
#import "WDConst.h"

@interface EditeResumeCell_height () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *utfHeight;
@property (weak, nonatomic) IBOutlet UITextField *utfWeight;
- (IBAction)utfHeightOnChange:(UITextField *)sender;

- (IBAction)utfWeightOnChange:(UITextField *)sender;


@end

@implementation EditeResumeCell_height

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.utfHeight.delegate = self;
    self.utfWeight.delegate = self;
}

- (void)setModel:(JKModel *)model{
    _model = model;
    self.utfHeight.text = model.height ? model.height.description: nil;
    self.utfWeight.text = model.weight ? model.weight.description: nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)utfWeightOnChange:(UITextField *)sender {
    self.model.weight = @(sender.text.floatValue);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 3) { //限制字数
        return NO;
        return YES;
    }
    return YES;
}

- (IBAction)utfHeightOnChange:(UITextField *)sender {
    self.model.height = @(sender.text.floatValue);
}
@end
