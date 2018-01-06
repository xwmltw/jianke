//
//  JobQAAlertView.m
//  jianke
//
//  Created by yanqb on 2018/1/3.
//  Copyright © 2018年 xianshijian. All rights reserved.
//

#import "JobQAAlertView.h"
#import "Masonry.h"
#import "UIHelper.h"
@implementation JobQAAlert
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:ges];
        self.alertView.hidden = NO;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(-120);
            make.left.mas_equalTo(self).offset(24);
            make.right.mas_equalTo(self).offset(-24);
            make.height.mas_equalTo((135*SCREEN_WIDTH)/375);
        }];
        
        
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)ges{
    self.hidden = YES;
    [self.alertView.contentField resignFirstResponder];
}

- (JobQAAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[JobQAAlertView alloc]init];
        [self addSubview:_alertView];
    }
    return _alertView;
}
@end


@implementation JobQAAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self  = [[NSBundle mainBundle]loadNibNamed:@"JobQAAlert" owner:nil options:nil].lastObject;
        self.contentField.delegate = self;
        self.contentField.keyboardType = UIKeyboardTypeASCIICapable;
        [self.contentField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length >1 && textField.text.length> 49) {
//        [UIHelper toast:@"内容不能超过50字"];
//        return YES;
//    }
//    return YES;
//}
- (void)textFieldDidChange:(UITextField*)textField{
    if (textField.text.length >= 50) {
        [UIHelper toast:@"内容不能超过50字"];
        textField.text = [textField.text substringToIndex:50];
    }
}
- (IBAction)btnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alertDelegate:)]) {
        [self.delegate alertDelegate:sender.tag];
    }
}

@end
