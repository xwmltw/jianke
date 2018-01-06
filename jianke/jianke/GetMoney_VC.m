//
//  GetMoney_VC.m
//  jianke
//
//  Created by xiaomk on 15/11/11.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "GetMoney_VC.h"
#import "WXApi.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "ThirdPartAccountModel.h"
#import "ForgotPassword_VC.h"
#import "MKAlertView.h"

@interface GetMoney_VC ()<UIAlertViewDelegate,DLAVAlertViewDelegate,UIAlertViewDelegate>{
    NSNumber* _moneyAmount;
    WechatParmentRequest* _wxGetMoneyRequestModel;
    AlipayPM* _alipayPM;

    int _selectType;
}

@property (weak, nonatomic) IBOutlet UITextField *tfMoneyNum;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UIButton *btnAlipay;
@property (weak, nonatomic) IBOutlet UIView *zhifubaoView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn;

@property (weak, nonatomic) IBOutlet UILabel *zhifubaoAlert;
@property (weak, nonatomic) IBOutlet UILabel *labAlipayDesc;
@property (nonatomic, copy) NSString *descStr;
//@property (weak, nonatomic) IBOutlet UITextView *noticeTextView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToBtn;
@property (nonatomic, copy) NSNumber *wechat_sigle_withdraw_min_limit;  //微信取现最低金额

@end

@implementation GetMoney_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取出";
    self.zhifubaoAlert.hidden = YES;
    self.view.backgroundColor = [UIColor XSJColor_grayDeep];
    self.tfPwd.placeholder = @"请输入6位钱袋子密码";
    
    self.zhifubaoView.hidden = YES;
    [self.showMoreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    
    // 微信登陆,获取Code通知
    [WDNotificationCenter addObserver:self selector:@selector(getWeiXinAccessTokenForPay:) name:WXGetMoneyGetCodeNotification object:nil];

    [self selectTypeWithWechat:YES];
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
        if (globalModel) {
            weakSelf.labAlipayDesc.text = globalModel.withdraw_desc;
            weakSelf.wechat_sigle_withdraw_min_limit = globalModel.wechat_sigle_withdraw_min_limit;
        }
    }];
}

- (void)showMore{
    self.zhifubaoView.hidden = NO;
    self.moreView.hidden = YES;
}

- (IBAction)btnSendOnclick:(UIButton *)sender {
    if (self.tfMoneyNum.text.length <= 0) {
        [UserData delayTask:0.3 onTimeEnd:^{
            [UIHelper toast:@"请输入需要取出的金额"];
        }];
        return;
    }

    if (self.tfMoneyNum.text.intValue < 1) {
        [UserData delayTask:0.3 onTimeEnd:^{
            [UIHelper toast:@"单次取现金额不能少于1元"];
        }];
        return;
    }
    if (self.tfPwd.text.length != 6) {
        [UserData delayTask:0.3 onTimeEnd:^{
            [UIHelper toast:@"请输入有效的6位密码"];
        }];
        return;
    }
    
    if (self.btnWechat.selected == YES) {
        if (self.tfMoneyNum.text.floatValue < self.wechat_sigle_withdraw_min_limit.floatValue) {
            NSString *str = [NSString stringWithFormat:@"微信最低取出金额 ¥%@",self.wechat_sigle_withdraw_min_limit];
            [UIHelper toast:str];
            return;
        }
    }
    
    if (self.btnAlipay.selected == YES) {
        if (self.tfMoneyNum.text.floatValue <  self.alipay_sigle_withdraw_min_limit.floatValue) {
            NSString *str = [NSString stringWithFormat:@"支付宝最低取出金额 ¥%@",self.alipay_sigle_withdraw_min_limit];
            [UIHelper toast:str];
            return;
        }
    }

    //验证钱袋子密码
    [self estimatePassword];
    
}
- (IBAction)pwdChanged:(UITextField *)sender {
    if (sender.text.length > 6) {
        sender.text = [sender.text substringToIndex:6];
    }
}

- (void)estimatePassword{
    
    NSString *pwd = [[[NSString stringWithFormat:@"%@%@",self.tfPwd.text,[XSJNetWork getChallenge]]MD5]uppercaseString];
    NSString *content_1 = [NSString stringWithFormat:@"acct_encpt_password:\"%@\"",pwd];
    
    RequestInfo *request_1 = [[RequestInfo alloc]initWithService:@"shijianke_userConfirmAccountMoneyPassword" andContent:content_1];
    WEAKSELF
    [request_1 sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
//            钱袋子密码正确
            [weakSelf payTypeSelect];
        }
    }];
    
    
//    NSString *content_2 = @"";
//    RequestInfo *request_2 = [[RequestInfo alloc]initWithService:@"shijianke_getThirdPartyInfo" andContent:content_2];
//    
//    [request_2 sendRequestWithResponseBlock:^(ResponseInfo* response) {
//        
//        if (response && response.success) {
//            [UIHelper toast:@"获取第三方信息成功"];
//        }
//    }];
//
}

-(void)payTypeSelect{
    NSString* password = [[[NSString stringWithFormat:@"%@%@",self.tfPwd.text, [XSJNetWork getChallenge]] MD5] uppercaseString];
    
    if (_selectType == 1) {
        _wxGetMoneyRequestModel = [[WechatParmentRequest alloc] init];
        _wxGetMoneyRequestModel.acct_encpt_password = password;
        _wxGetMoneyRequestModel.client_time_millseconds = [NSString stringWithFormat:@"%lld", [DateHelper getTimeStamp]];
        _wxGetMoneyRequestModel.payment_amount = [NSString stringWithFormat:@"%0.0f", self.tfMoneyNum.text.floatValue * 100];
        
        [self wxAuthRequest];
    }else if (_selectType == 2){
        
        _alipayPM = [[AlipayPM alloc] init];
        _alipayPM.acct_encpt_password = password;
        _alipayPM.client_time_millseconds = [NSString stringWithFormat:@"%lld", [DateHelper getTimeStamp]];
        _alipayPM.payment_amount = [NSString stringWithFormat:@"%0.0f", self.tfMoneyNum.text.floatValue * 100];
        [self showAlertToAlipay];
    }
}

- (void)showAlertToAlipay{
    DLAVAlertView* alert = [[DLAVAlertView alloc] initWithTitle:@"支付宝取出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:DLAVAlertViewStyleLoginAndPasswordInput];
    alert.tag = 101;
    
    UITextField* tfAccount = [alert textFieldAtIndex:0];
    tfAccount.placeholder = @"支付宝账号(手机号码或邮箱地址)";
    [tfAccount setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    tfAccount.keyboardType = UIKeyboardTypeEmailAddress;
    tfAccount.secureTextEntry = NO;
    
    UITextField* tfUserName = [alert textFieldAtIndex:1];
    tfUserName.placeholder = @"账号所属人真实姓名";
    tfUserName.keyboardType = UIKeyboardTypeDefault;
    tfUserName.secureTextEntry = NO;
    [tfUserName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

    WEAKSELF
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex == 1){
            if (buttonIndex == 0 && alertView.tag == 101) {
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }else if (buttonIndex == 1) {
                if (alertView.tag == 101) {
                    UITextField* tfUserName = [alertView textFieldAtIndex:1];
                    UITextField* tfAccount = [alertView textFieldAtIndex:0];
                    if (tfUserName.text.length == 0) {
                        [UserData delayTask:0.3 onTimeEnd:^{
                            [UIHelper toast:@"请输入账号所属人真实姓名"];
                        }];
                        [weakSelf showAlertToAlipay];
                        return;
                    }
                    if (tfAccount.text.length == 0) {
                        [UserData delayTask:0.3 onTimeEnd:^{
                           [UIHelper toast:@"请输入你的支付宝账号"];
                        }];
                        
                        [weakSelf showAlertToAlipay];
                        return;
                    }
                    _alipayPM.alipay_user_true_name = tfUserName.text;
                    _alipayPM.alipay_user_name = tfAccount.text;
                    
                    NSString* sign = [NSString stringWithFormat:@"%@%@%@%@",_alipayPM.payment_amount,_alipayPM.alipay_user_name,_alipayPM.acct_encpt_password, _alipayPM.client_time_millseconds];
                    _alipayPM.client_sign = [[sign MD5] uppercaseString];
                    
                    NSString* content = [_alipayPM getContent];
                    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_alipayPaymentRequest" andContent:content];
                    request.isShowLoading = YES;
                    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
                        if (response && [response success]) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                            [UserData delayTask:0.3 onTimeEnd:^{
                                [UIHelper toast:@"提取成功，系统将在24小时内处理取款请求"];
                            }];
                        }
                    }];
                }
            }
        }
    }];
}
- (void)willPresentAlertView:(DLAVAlertView *)alertView{
    alertView.width = alertView.width + 50;
    alertView.x = SCREEN_WIDTH/2 - alertView.width/2;

//    alertView.width = alertView.width + 50;
}

#pragma mark - 微信取现========================================================
- (void)wxAuthRequest{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        ELog(@"===安装了微信客户端");
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"WXGetMoney";
        [WXApi sendReq:req];
    }else{
        ELog(@"没有安装微信客户端");
        [UIHelper toast:@"你没有安装微信"];
    }
}

//获取 微信appid
- (void)getWeiXinAccessTokenForPay:(NSNotification*)notification{
    ELog(@"=====notification");
    NSString* code = notification.userInfo[WXGetMoneyGetCodeInfo];
    ThirdPartAccountModel* wechatAccount = [ThirdPartAccountModel wechatAccount];
    NSString* url = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatAccount.getAccessTokenURL, wechatAccount.appID, wechatAccount.appKey, code];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            ELog("------dic:%@",dic);
            NSString *openid = dic[@"openid"];
            _wxGetMoneyRequestModel.open_id = openid;
            
            NSString* sign = [NSString stringWithFormat:@"%@%@%@%@",_wxGetMoneyRequestModel.payment_amount,_wxGetMoneyRequestModel.open_id,_wxGetMoneyRequestModel.acct_encpt_password,_wxGetMoneyRequestModel.client_time_millseconds];
            _wxGetMoneyRequestModel.client_sign = [[sign MD5] uppercaseString];
            
            [self sendGetMoneyRequest];
        }
    }];
}

// 取现请求
- (void)sendGetMoneyRequest{
    NSString* content = [_wxGetMoneyRequestModel getContent];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_wechatParmentRequest" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:@"提取成功"];
            }];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)btnWechatOnclick:(UIButton *)sender {
    self.zhifubaoAlert.hidden = YES;
    [self selectTypeWithWechat:YES];
}

- (IBAction)btnAlipayOnclick:(UIButton *)sender {
    if (self.tfMoneyNum.text.floatValue < self.alipay_sigle_withdraw_min_limit.floatValue && self.tfMoneyNum.text.floatValue != 0) {
        self.zhifubaoAlert.text = [NSString stringWithFormat:@"支付宝最低取出金额 ¥%@",self.alipay_sigle_withdraw_min_limit];
        self.zhifubaoAlert.hidden = NO;
        self.tfMoneyNum.clearButtonMode = UITextFieldViewModeNever;
    }
    [self selectTypeWithWechat:NO];
}

- (void)selectTypeWithWechat:(BOOL)bType{
    self.btnWechat.selected = bType;
    self.btnAlipay.selected = !bType;
    _selectType = bType ? 1:2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPasswordBtn:(UIButton *)sender {
    
    ForgotPassword_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_forgotPwd"];
    vc.pwdAccountType = PwdAccountType_MoneyBag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeMoney:(UITextField *)sender {
    if (self.btnAlipay.selected == YES) {
        if (self.alipay_sigle_withdraw_min_limit) {
            
            if (sender.text.floatValue < self.alipay_sigle_withdraw_min_limit.floatValue && sender.text.floatValue != 0) {
                self.zhifubaoAlert.text = [NSString stringWithFormat:@"支付宝最低取出金额 ¥%@",self.alipay_sigle_withdraw_min_limit];
                self.zhifubaoAlert.hidden  = NO;
                sender.clearButtonMode = UITextFieldViewModeNever;
            }else{
                self.zhifubaoAlert.hidden = YES;
                sender.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
        }
    }else{
        self.zhifubaoAlert.hidden = YES;
        sender.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (IBAction)changeMoneyEnd:(UITextField *)sender {
    if (self.btnAlipay.selected == YES) {
        if (self.alipay_sigle_withdraw_min_limit) {
            
            if (sender.text.floatValue < self.alipay_sigle_withdraw_min_limit.floatValue && sender.text.floatValue != 0) {
                self.zhifubaoAlert.text = [NSString stringWithFormat:@"支付宝最低取出金额 ¥%@",self.alipay_sigle_withdraw_min_limit];
                self.zhifubaoAlert.hidden  = NO;
                sender.clearButtonMode = UITextFieldViewModeNever;
            }else{
                self.zhifubaoAlert.hidden = YES;
                sender.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
        }
    }else{
        self.zhifubaoAlert.hidden = YES;
        sender.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
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
