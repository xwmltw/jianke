//
//  EditResumeAlertTelView.m
//  jianke
//
//  Created by yanqb on 2017/7/17.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditResumeAlertTelView.h"
#import "WDConst.h"

@implementation EditResumeAlertTelView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"alertTelView" owner:nil options:nil].firstObject;
        self.btnGetCode.tag = AlertTelBtnTag_code;
        self.btnCancel.tag = AlertTelBtnTag_cancel;
        self.btnUpdate.tag = AlertTelBtnTag_update;
        
       
    }
    return self;
}
- (IBAction)btnOnClick:(UIButton *)sender {
    MKBlockExec(self.block,sender);
}
- (IBAction)textTelNume:(UITextField *)sender {
    if(sender.text.length > 11){
        sender.text = [sender.text substringToIndex:11];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface AlertTelVIew ()
@end

@implementation AlertTelVIew

- (instancetype)initWithFrame:(CGRect)frame block:(MKBlock )block{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
        
        //监听键盘
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardEndShow:) name:UIKeyboardWillHideNotification object:nil];
        
        self.editTelView = [[EditResumeAlertTelView alloc]init];
        self.editTelView.block = block;
        [self addSubview:self.editTelView];
        
        CGFloat width = (272*SCREEN_WIDTH)/375;
        CGFloat height = (222*SCREEN_HEIGHT)/667;
        
        [self.editTelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(100);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
    }
    return self;

}
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardFrame = [[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat width = (272*SCREEN_WIDTH)/375;
    CGFloat height = (222*SCREEN_HEIGHT)/667;
    [self.editTelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(keyboardFrame.origin.y-height-50);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

}
- ( void)keyboardEndShow:(NSNotification *)notification{
    
    
    
    CGFloat width = (272*SCREEN_WIDTH)/375;
    CGFloat height = (222*SCREEN_HEIGHT)/667;
    
    [self.editTelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
   


    
}
- (void)dealloc{
    // 移除通知
    [WDNotificationCenter removeObserver:self];
    
}
@end
