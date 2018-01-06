//
//  ForgotPassword_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ForgotPassword_VC.h"
#import "UIHelper.h"
#import "UserData.h"
#import "RsaHelper.h"
#import "WebView_VC.h"

@interface ForgotPassword_VC (){

    BOOL _bGetAuthNum;
    NSTimer* _timer;
    int _countdown;
}

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tfAuthNum;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdatePwd;
@property (weak, nonatomic) IBOutlet UIButton *btnGetAuthNum;

@property (weak, nonatomic) IBOutlet UILabel *labelSecond;

- (IBAction)pushTipVC:(id)sender;

@end

@implementation ForgotPassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    [_btnUpdatePwd setCornerValue:20];
    
    if ([[UserData sharedInstance]getLoginType].integerValue == WDLoginType_JianKe) {
        [TalkingData trackEvent:@"兼客登录_忘记密码页面"];
    }
    self.tfPhoneNum.keyboardType = UIKeyboardTypeNamePhonePad;
    self.tfAuthNum.keyboardType = UIKeyboardTypeNumberPad;
    if (self.pwdAccountType == PwdAccountType_Login) {
        self.title = @"找回登录密码";
        self.tfPwd.keyboardType = UIKeyboardTypeDefault;
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        self.title = @"找回钱袋子密码";
        self.tfPwd.keyboardType = UIKeyboardTypeNumberPad;
        self.tfPwd.placeholder = @"  请输入6位数字新密码";
    }
    
//    [self.btnUpdatePwd setBackgroundImage:[UIImage imageNamed:@"v231_register"] forState:UIControlStateNormal];
//    [self.btnUpdatePwd setBackgroundImage:[UIImage imageNamed:@"v231_registerdown"] forState:UIControlStateHighlighted];
    
    [self.tfPhoneNum addTarget:self action:@selector(tfPhoneNumDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfAuthNum addTarget:self action:@selector(tfAuthNumDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSString* userPhone = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    if (userPhone) {
        self.tfPhoneNum.text = userPhone;
    }
}

- (IBAction)btnGetAuthNumOnClick:(UIButton *)sender {
    if (self.tfPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }
    
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    NSInteger getAuthType = -1;
    if (self.pwdAccountType == PwdAccountType_Login) {
        getAuthType = WdVarifyCodeOptTypeFindPassword;
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        getAuthType = WdVarifyCodeOptTypeFindMoneyBagPwd;
    }
    if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData  trackEvent:@"找回登录密码_获取验证码"];
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"找回钱袋子密码_获取验证码"];
    }else{
        [TalkingData trackEvent:@"忘记密码_获取验证码"];
    }

    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAuthNumWithPhoneNum:self.tfPhoneNum.text andBlock:^(id select) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取验证码成功"];
        [weakSelf retryCountDown];
    } withOPT:getAuthType userType:userType];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"找回登录密码_返回"];
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"找回钱袋子密码_返回"];
    }
}

- (IBAction)btnUpdatePwdOnClick:(UIButton *)sender {
    if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"找回登录密码_确定"];
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"找回钱袋子密码_确定"];

    }
    if (self.tfPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }else if (self.tfAuthNum.text.length != 6) {
        [UIHelper toast:@"请输入正确的验证码"];
        return;
    }else if (!_bGetAuthNum) {
        [UIHelper toast:@"请重新获取验证码"];
        return;
    }
    
    if (self.pwdAccountType == PwdAccountType_MoneyBag) {
        if (self.tfPwd.text.length != 6) {
            [UIHelper toast:@"请设置6位数字的密码"];
            return;
        }
    }else{
        if (self.tfPwd.text.length < 6){
            [UIHelper toast:@"密码长度必须大于5位"];
            return;
        }else if (self.tfPwd.text.length > 32){
            [UIHelper toast:@"密码长度不能超过32位"];
            return;
        }
    }
    
    [self sendUpdatePwdRequest];

}



- (void)retryCountDown{
    self.btnGetAuthNum.enabled = NO;
    
    _countdown = 60; //倒计时时间
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(id)sender{
    if (_countdown <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.labelSecond.hidden = YES;
        [self.btnGetAuthNum setEnabled:YES];
    }else{
        self.labelSecond.hidden = NO;
        self.labelSecond.text = [NSString stringWithFormat:@"%.2d", _countdown];
        [self.btnGetAuthNum setTitle:@"秒后重试" forState:UIControlStateDisabled];
        
        _countdown--;
    }
}

- (void)tfPhoneNumDidChange:(UITextField *)textField{
    if (textField == self.tfPhoneNum) {
        if (self.tfPhoneNum.text.length >= 11) {
            self.tfPhoneNum.text = [self.tfPhoneNum.text substringToIndex:11];
        }
    }
}
- (void)tfAuthNumDidChange:(UITextField *)textField{
    if (textField == self.tfAuthNum){
        if (self.tfAuthNum.text.length >= 6) {
            self.tfAuthNum.text = [self.tfAuthNum.text substringToIndex:6];
        }

    }
}

- (IBAction)bgViewOnClick:(id)sender {
    [self.tfPhoneNum resignFirstResponder];
    [self.tfAuthNum resignFirstResponder];
    [self.tfPwd resignFirstResponder];
}
//发送请求
- (void)sendUpdatePwdRequest{
    NSNumber* loginType = [[UserData sharedInstance] getLoginType];
    NSAssert(loginType, @"=====loginType nil");
    
    NSData* passDada = [RsaHelper encryptString:self.tfPwd.text publicKey:nil];
    NSString* pass = [[WDRequestMgr sharedInstance] bytesToHexString:passDada];
    
    ResetPasswordByPhoneNumPM* model = [[ResetPasswordByPhoneNumPM alloc] init];
    model.phone_num = self.tfPhoneNum.text;
    model.password = pass;
    model.sms_authentication_code = self.tfAuthNum.text;
    
    if (self.pwdAccountType == PwdAccountType_Login) {
        model.user_type = loginType;
        NSString* content = [model getContent];
        
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_resetPasswordByPhoneNum" andContent:content];
        request.isShowLoading = YES;
        [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
            if (response && [response success]) {
                [UIHelper toast:@"找回密码成功！"];
                [[XSJUserInfoData sharedInstance] setPassword:self.tfPwd.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        NSString* content = [model getContent];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_resetMoneyBagPassword" andContent:content];
        request.isShowLoading = YES;
        [request sendRequestWithResponseBlock:^(id response) {
            if (response && [response success]) {
                [UIHelper toast:@"修改钱袋子密码成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    
}

- (IBAction)newPwdNum:(UITextField *)sender {
    if (self.pwdAccountType == PwdAccountType_MoneyBag){
        
        if (sender.text.length >6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }else{
        if (self.pwdAccountType == PwdAccountType_Login) {
            if (sender.text.length > 32) {
                sender.text = [sender.text substringToIndex:32];
            }
        }
    }
}

- (IBAction)confirmNum:(UITextField *)sender {

    if (self.pwdAccountType == PwdAccountType_MoneyBag){
        if (sender.text.length >6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }else{
        if (self.pwdAccountType == PwdAccountType_Login) {
            if (sender.text.length > 32) {
                sender.text = [sender.text substringToIndex:32];
            }
        }
    }
}

//typedef NS_ENUM(NSInteger, PwdAccountType) {
//    PwdAccountType_Login = 1,       //登录账号
//    PwdAccountType_MoneyBag = 2     //钱袋子账号
//};
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.pwdAccountType == PwdAccountType_Login) {
    } else if (self.pwdAccountType == PwdAccountType_MoneyBag) {
        [TalkingData trackEvent:@"找回钱袋子密码_返回"];
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pushTipVC:(id)sender {
    WebView_VC *vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,KUrl_NoGetCodePage];;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
