//
//  PerfectInfo_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "PerfectInfo_VC.h"
#import "UIHelper.h"
#import "WebView_VC.h"

@interface PerfectInfo_VC (){
    
    BOOL _bGetAuthNum;
    NSTimer* _timer;
    int _countdown;
}

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tfAuthNum;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *btnGetAuthNum;

@property (weak, nonatomic) IBOutlet UILabel *labelSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhone;
- (IBAction)pushTipVC:(id)sender;


@end

@implementation PerfectInfo_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"完善信息";
    [self.btnOk setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [self.btnOk setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
}

- (IBAction)ftPhoneNumChanged:(UITextField *)sender {
    if (sender.text.length > 0) {
        self.imgPhone.hidden = YES;
    }else{
        self.imgPhone.hidden = NO;
    }
    
    if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}

- (IBAction)ftAuthNumChanged:(UITextField *)sender {
    if (sender.text.length > 6) {
        sender.text = [sender.text substringToIndex:6];
    }
}

- (IBAction)btnGetAuthNumOnClick:(UIButton *)sender {
    if (self.tfPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入正确的手机号码"];
        return;
    }
    
    NSNumber* userType = [[UserData sharedInstance] getLoginType];

    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAuthNumWithPhoneNum:self.tfPhoneNum.text andBlock:^(id select) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取验证码成功"];
        [weakSelf retryCountDown];
    } withOPT:WdVarifyCodeOptTypePerfectInfo userType:userType];
    
}

//倒计时
- (void)retryCountDown{
    self.btnGetAuthNum.enabled = NO;
    _countdown = 60;
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

- (IBAction)btnOKOnClick:(UIButton *)sender {
    if (self.tfPhoneNum.text.length != 11) {
        [UIHelper toast:@"请输入11位有效手机号码"];
        return;
    }
    if (self.tfAuthNum.text.length != 6) {
        [UIHelper toast:@"请输入正确的验证码"];
        return;
    }
    if (!_bGetAuthNum) {
        [UIHelper toast:@"请重新获取验证码!"];
        return;
    }
    
    PostPerfectUserInfoPM* model = [[PostPerfectUserInfoPM alloc] init];
    model.oauth_id = self.oauth_id;
    model.phone_num = self.tfPhoneNum.text;
    model.sms_authentication_code = self.tfAuthNum.text;
    NSString* content = [model getContent];
    
    RequestInfo *info = [[RequestInfo alloc] initWithService:@"shijianke_postPerfectUserInfo" andContent:content];
    info.isShowLoading = YES;
    info.loadingMessage = @"请稍后";
    [info sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            ELog(@"完善个人简历成功, 自动登陆");
            [[XSJUserInfoData sharedInstance] setUserPhone:self.tfPhoneNum.text];
            [[UserData sharedInstance] setLoginStatus:YES];
            self.resBlock(@"OK");
        }
    }];
}

- (IBAction)bgVIewOnClick:(id)sender {
    [self.tfPhoneNum resignFirstResponder];
    [self.tfAuthNum resignFirstResponder];
}

- (IBAction)pushTipVC:(id)sender {
    WebView_VC *vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,KUrl_NoGetCodePage];;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
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

@end
