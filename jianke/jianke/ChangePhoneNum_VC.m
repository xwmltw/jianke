//
//  ChangePhoneNum_VC.m
//  
//
//  Created by 郑东喜 on 15/9/18.
//
//

#import "ChangePhoneNum_VC.h"
#import "UIHelper.h"
#import "UserData.h"
#import "RsaHelper.h"
#import "WebView_VC.h"

@interface ChangePhoneNum_VC () {
    BOOL _bGetAuthNum;
    NSTimer* _timer;
    int _countdown;
}


@property (weak, nonatomic) IBOutlet UITextField *TFPwd;
@property (weak, nonatomic) IBOutlet UITextField *TFPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tfAuthNum;
@property (weak, nonatomic) IBOutlet UIButton *btnGetAuthNum;
//@property (weak, nonatomic) IBOutlet UIButton *RegistVC;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtnChange;

@property (weak, nonatomic) IBOutlet UILabel *labelSecond;
- (IBAction)pushTipVC:(id)sender;

@end

@implementation ChangePhoneNum_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改手机号";
    
    [_phoneBtnChange setCornerValue:20];
    
    self.tfAuthNum.keyboardType = UIKeyboardTypeNumberPad;
    
//    [self.phoneBtnChange setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
//    [self.phoneBtnChange setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
    

    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackEvent:@"更换手机号码_返回"];
}

/**
 *侦测电话号码长度
 **/
- (IBAction)TFPhoneNum:(UITextField *)sender {
       if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}

/**
 *侦测密码长度
 **/
- (IBAction)TFPwdNum:(UITextField *)sender {
    
       if (sender.text.length > 32) {
        sender.text = [sender.text substringToIndex:32];
    }
}

/**
 *侦测验证码长度
 **/
- (IBAction)getAuthNumBtn:(UITextField *)sender {
    if (sender.text.length > 6) {
        sender.text = [sender.text substringToIndex:6];
    }
}


- (IBAction)getAuthNumBtnOnClick:(UIButton *)sender {
    if (self.TFPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }
    
    [TalkingData trackEvent:@"更换手机号码_获取验证码"];
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAuthNumWithPhoneNum:self.TFPhoneNum.text andBlock:^(id select) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取验证码成功"];
        [weakSelf retryCountDown];
    } withOPT:WdVarifyCodeOptTypeChgPhoneNum userType:userType];
}

- (IBAction)changeConfirmBtn:(UIButton *)sender{
    [TalkingData trackEvent:@"更换手机号码_确定"];

    if (!_bGetAuthNum) {
        [UIHelper toast:@"请重新获取验证码"];
        return;
    }
    
    if (self.TFPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }
    
    if (self.tfAuthNum.text.length != 6) {
        [UIHelper toast:@"请输入正确的验证码"];
        return;
    }
    
    [self sendMsg];
}

- (void)sendMsg {
    
    NSString* pass = [NSString stringWithFormat:@"%@%@", self.TFPwd.text, [XSJNetWork getChallenge]];
    
    NSString* content = [NSString stringWithFormat:@"phone_num:\"%@\",password:\"%@\",sms_authentication_code:\"%@\"",
                         self.TFPhoneNum.text, [[pass MD5] uppercaseString], self.tfAuthNum.text];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_updatePhoneNum" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            [[XSJUserInfoData sharedInstance] setUserPhone:self.TFPhoneNum.text];
            [UIHelper toast:@"手机号码更改成功！"];
            
//            [UIHelper showLoginVC];
            
            [[UserData sharedInstance] setLoginStatus:NO];
            [[UserData sharedInstance] setLogoutActive:YES];
            [XSJUIHelper showMainScene];
            ELog(@"******周杰伦上线了,并给你发了一个上线的通知");
            [UserData delayTask:2.0f onTimeEnd:^{
                [[XSJRequestHelper sharedInstance] autoLogin:^(id result) {
                }];
            }];
            
        }
    }];
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
        self.labelSecond.hidden = YES;
        [self.btnGetAuthNum setEnabled:YES];
    }else{
        self.labelSecond.hidden = NO;
        self.labelSecond.text = [NSString stringWithFormat:@"%.2d", _countdown];
        [self.btnGetAuthNum setTitle:@"秒后重试" forState:UIControlStateDisabled];
        _countdown--;
    }
}
- (IBAction)viewBgOnClick:(id)sender {
    [self.TFPwd resignFirstResponder];
    [self.TFPhoneNum resignFirstResponder];
    [self.tfAuthNum resignFirstResponder];
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
