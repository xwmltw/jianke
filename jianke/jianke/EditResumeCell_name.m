//
//  EditResumeCell_name.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditResumeCell_name.h"
#import "WDConst.h"
#import "NSString+XZExtension.h"

@interface EditResumeCell_name () <UITextFieldDelegate>{
    JKModel *_JkModel;
}

@property (weak, nonatomic) IBOutlet UITextField *utfName;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnMan;
@property (weak, nonatomic) IBOutlet UIButton *btnWoman;
@property (weak, nonatomic) IBOutlet UIButton *btnImgView;
- (IBAction)utfOnChange:(UITextField *)sender;
- (IBAction)btnOnClick:(UIButton *)sender;
- (IBAction)btnWomanOnClick:(UIButton *)sender;
- (IBAction)btnManOnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;

@end

@implementation EditResumeCell_name

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.utfName.delegate = self;
    [self.imgView setCornerValue:40.0f];
    self.btnHelp.tag = 100;
    [self.btnMan setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnMan setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    [self.btnWoman setImage:[UIImage imageNamed:@"frequent_icon_black_unselected"] forState:UIControlStateNormal];
    [self.btnWoman setImage:[UIImage imageNamed:@"frequent_icon_black_selected"] forState:UIControlStateSelected];
    self.btnWoman.selected = YES;
}

- (void)setModel:(JKModel *)model{
    _JkModel = model;
    self.btnHelp.hidden = YES;
    self.utfName.text = (model.true_name.length) ? model.true_name: nil;
    
    if (model.id_card_verify_status.integerValue == 2 || model.id_card_verify_status.integerValue == 3) {
        self.btnHelp.hidden = NO;

        self.utfName.userInteractionEnabled = NO;
    }else{
        self.utfName.userInteractionEnabled = YES;
    }
    
//    self.utfName.userInteractionEnabled = (model.id_card_verify_status.integerValue != 3);
    
    self.btnWoman.selected = (model.sex.integerValue == 0);
    self.btnMan.selected = (model.sex.integerValue == 1);
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.profile_url]] placeholderImage:[UIHelper getDefaultHead]];
}

- (IBAction)utfOnChange:(UITextField *)sender {
    _JkModel.true_name = sender.text;
}

- (IBAction)btnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(EditResumeCell_name:)]) {
        [self.delegate EditResumeCell_name:sender.tag];
    }
    
}

- (IBAction)btnWomanOnClick:(UIButton *)sender {
    sender.selected = YES;
    _JkModel.sex = @0;
    self.btnMan.selected = NO;
}

- (IBAction)btnManOnClick:(UIButton *)sender {
    sender.selected = YES;
    _JkModel.sex = @1;
    self.btnWoman.selected = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 10) {
        return NO;
        
    }
    return YES;
}
- (IBAction)btnHelp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(EditResumeCell_name:)]) {
        [self.delegate EditResumeCell_name:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
