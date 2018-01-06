//
//  Regist_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "Regist_VC.h"
#import "UIHelper.h"
#import "RsaHelper.h"
#import "NetHelper.h"
#import "CityModel.h"
#import "UserData.h"
#import "WebView_VC.h"
#import "TalkingDataAppCpa.h"
#import "WebView_VC.h"

@interface Regist_VC (){

    BOOL _bGetAuthNum;
    NSTimer* _timer;
    int _countdown;
}

@property (weak, nonatomic) IBOutlet UITextField *TFPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *TFAuthNum;
@property (weak, nonatomic) IBOutlet UITextField *TFPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;
@property (weak, nonatomic) IBOutlet UIButton *btnGetAuthNum;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewhight;

@property (weak, nonatomic) IBOutlet UILabel *lableSecond;

- (IBAction)pushTipVC:(id)sender;


@end

@implementation Regist_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.title = @"注册";
    
    [_btnRegist setCornerValue:20];
    
    _layoutViewhight.constant = (SCREEN_WIDTH - 108) * 176/267 +52;
    
    [self.TFPhoneNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.TFAuthNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.TFPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self createCloseBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendRegistRequest{
    [TalkingData trackEvent:@"兼客登录_注册_注册"];

    NSString* phoneNum = self.TFPhoneNum.text;
    NSString* password = self.TFPwd.text;
    NSString* authNum = self.TFAuthNum.text;

    NSNumber* loginType = [[UserData sharedInstance] getLoginType];
    NSData* passDada = [RsaHelper encryptString:password publicKey:nil];
    NSString* pass = [[WDRequestMgr sharedInstance] bytesToHexString:passDada];
    
    RegistUserByPhoneNumPM* model = [[RegistUserByPhoneNumPM alloc] init];
    model.phone_num = phoneNum;
    model.password = pass;
    model.sms_authentication_code = authNum;
    model.user_type = loginType;
    NSString* content = [model getContent];
    if ([UserData sharedInstance].registrationID.length) {
        content = [content stringByAppendingFormat:@", \"push_id\": \"%@\"", [UserData sharedInstance].registrationID];
    }
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_registUserByPhoneNum" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"注册成功！"];
            [TalkingDataAppCpa onRegister:model.phone_num];
            [[XSJUserInfoData sharedInstance] savePhone:weakSelf.TFPhoneNum.text password:weakSelf.TFPwd.text];
            MKBlockExec(weakSelf.block, weakSelf.isShowGuide);
        }
    }];
}

#pragma mark - 按钮事件
- (IBAction)getAuthNumBtnOnClick:(UIButton *)sender {
    if (self.TFPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }
    [self.TFPhoneNum resignFirstResponder];
    [self.TFAuthNum resignFirstResponder];
    [self.TFPwd resignFirstResponder];
    
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    [TalkingData trackEvent:@"兼客登录_注册_获取验证码"];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAuthNumWithPhoneNum:self.TFPhoneNum.text andBlock:^(id select) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取验证码成功"];
        [weakSelf retryCountDown];
    } withOPT:WdVarifyCodeOptTypeRegist userType:userType];
}

- (IBAction)btnRegistOnClick:(UIButton *)sender {
    if (self.TFPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }else if (self.TFAuthNum.text.length != 6) {
        [UIHelper toast:@"请输入正确的验证码"];
        return;
    }else if (!_bGetAuthNum) {
        [UIHelper toast:@"请重新获取验证码"];
        return;
    }else if (self.TFPwd.text.length < 6){
        [UIHelper toast:@"密码长度必须大于5位"];
        return;
    }else if (self.TFPwd.text.length > 32){
        [UIHelper toast:@"密码长度必须小于32位"];
        return;
    }
    
    [self sendRegistRequest];
}

- (IBAction)btnLoginOnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)bgViewOnClick:(id)sender {
    [self.TFPhoneNum resignFirstResponder];
    [self.TFAuthNum resignFirstResponder];
    [self.TFPwd resignFirstResponder];
}

//倒计时
- (void)retryCountDown{
    self.btnGetAuthNum.enabled = NO;
    _countdown = 60; //倒计时时间
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(id)sender{
    if (_countdown <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.lableSecond.hidden = YES;
        [self.btnGetAuthNum setEnabled:YES];
    }else{
        self.lableSecond.hidden = NO;
        self.lableSecond.text = [NSString stringWithFormat:@"%.2d", _countdown];
        [self.btnGetAuthNum setTitle:@"秒后重试" forState:UIControlStateDisabled];
        _countdown--;
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.TFPhoneNum) {
        if (self.TFPhoneNum.text.length >= 11) {
            self.TFPhoneNum.text = [self.TFPhoneNum.text substringToIndex:11];
        }
    }else if (textField == self.TFAuthNum){
        if (self.TFAuthNum.text.length >= 6) {
            self.TFAuthNum.text = [self.TFAuthNum.text substringToIndex:6];
        }
    }else if (textField == self.TFPwd){        
        if (self.TFPwd.text.length > 32) {
            self.TFPwd.text = [self.TFPwd.text  substringToIndex:32];
        }
    }
}


- (IBAction)btnAgreementOnclick:(UIButton *)sender {
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, KUrl_userAgreementPage];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 返回 */
- (void)backToLastView{
    if (self.isToRegister) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)dismissVC{
    if (self.isFromNewFrature) {
        [XSJUIHelper showMainScene];
    }else{
        MKBlockExec(self.loginBlock, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pushTipVC:(id)sender {
    WebView_VC *vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,KUrl_NoGetCodePage];;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
