//
//  Login_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "Login_VC.h"
#import "WDCache.h"
#import "WDConst.h"
#import "MainNavigation_VC.h"
#import "TagView.h"
#import "Regist_VC.h"
#import "ForgotPassword_VC.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "ThirdPartAccountModel.h"
#import "PerfectInfo_VC.h"
#import "ResponseInfo.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "EPModel.h"
#import "CityTool.h"
#import "LocalModel.h"
#import "CitySelectController.h"
#import "DynamicPwdRegist_VC.h"
#import "WebView_VC.h"
#import "WelcomeJoinJK_VC.h"

@interface Login_VC () <TencentSessionDelegate,UITextFieldDelegate>{
    BOOL _loginPwdCommonType;
    
    BOOL _bGetAuthNum;
    NSTimer *_timer;
    int _countdown;

}

@property (nonatomic, strong) TencentOAuth *tencentOAuth; /*!< QQ OAuth对象 */
@property (nonatomic, strong) NSArray *tencentOAuthPermissions; /*!< QQ OAuth请求权限 */



@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIButton *btnSina;
@property (weak, nonatomic) IBOutlet UIButton *btnQQ;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;


@property (weak, nonatomic) IBOutlet UIButton *btnLoginTypeSwitch;


@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnGetTempPwd;
@property (weak, nonatomic) IBOutlet UIButton *vertifyOrforgotBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutbtnheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTextView;

@end

@implementation Login_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    self.title = @"登录";
    
    [_loginBtn setCornerValue:20];
    self.layoutbtnheight.constant = (SCREEN_WIDTH - 108) * 176 / 267 +56;
    
    
    //    初始化状态
    [[UserData sharedInstance] setLoginStatus:NO];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        self.btnWechat.hidden = YES;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        self.btnQQ.hidden = YES;
    }

    
    NSString* userPhone = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    if (userPhone && userPhone.length > 0) {
        self.phoneNumTF.text = userPhone;
    }
    
    [WDNotificationCenter removeObserver:self];
    // 微博登陆,获取AccessToken通知
    [WDNotificationCenter addObserver:self selector:@selector(getWeiBoAccessToken:) name:WBLoginGetRespNotification object:nil];
    // 微信登陆,获取Code通知
    [WDNotificationCenter addObserver:self selector:@selector(getWeiXinAccessToken:) name:WXLoginGetCodeNotification object:nil];
    
    [self.btnLoginTypeSwitch addTarget:self action:@selector(btnLoginTypeSwitchOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnGetTempPwd addTarget:self action:@selector(btnGetTempPwdOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginPwdCommonType = YES;
    [self setLoginPwdType];
    
//    if (!self.isFromNewFrature) {
        [self createCloseBtn];
//    }
    
    if (self.isToRegister) {
        Regist_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_registVC"];
        vc.isFromNewFrature = self.isFromNewFrature;
        vc.isToRegister = self.isToRegister;
        vc.isShowGuide = self.isShowGuide;
        vc.loginBlock = self.blcok;
        WEAKSELF
        vc.block = ^(BOOL isShowGuide){
            NSString *username = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
            NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
            [weakSelf sendLoginRequestWithUsername:username password:password type:LoginPwdType_commonPassword isShowGuide:isShowGuide];
        };
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)setLoginPwdType{
    
    self.btnGetTempPwd.hidden = _loginPwdCommonType;
    self.pwdTF.delegate = self;
    if (_loginPwdCommonType) {
        [self.btnLoginTypeSwitch setTitle:@"动态密码登录" forState:UIControlStateNormal];
        self.pwdTF.placeholder = @"密码";
        self.pwdTF.secureTextEntry = YES;
        self.pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.labTime.hidden = YES;
    }else{
        [self.btnLoginTypeSwitch setTitle:@"账号密码登录" forState:UIControlStateNormal];
        self.pwdTF.placeholder = @"动态密码";
        self.pwdTF.secureTextEntry = NO;
        self.pwdTF.clearButtonMode = UITextFieldViewModeNever;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginBtnOnClick:nil];
    return YES;
}
- (void)updateVertifyOrforgotBtn{
    if (_loginPwdCommonType) {
        [self.vertifyOrforgotBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    }else{
        [self.vertifyOrforgotBtn setTitle:@"无法获取验证码？" forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮事件
/** 切换登录模式 */
- (void)btnLoginTypeSwitchOnclick:(UIButton *)sender{
    _loginPwdCommonType = !_loginPwdCommonType;
    self.layoutTextView.constant = _loginPwdCommonType ? 32 : 150;
    self.pwdTF.text = nil;
    [self setLoginPwdType];
    [self updateVertifyOrforgotBtn];
}

/** 获取动态密码 */
- (void)btnGetTempPwdOnclick:(UIButton *)sender{
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getAuthNumWithPhoneNum:self.phoneNumTF.text andBlock:^(id result) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取动态密码成功"];
        [weakSelf retryCountDown];
    } withOPT:WdVarifyCodeOptTypeDynamicPwdLogin userType:userType];
}

/** 倒计时 */
- (void)retryCountDown{
    self.btnGetTempPwd.enabled = NO;
    _countdown = 60; //倒计时时间
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(id)sender{
    if (_countdown <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.labTime.hidden = YES;
        self.btnGetTempPwd.enabled = YES;
    }else{
        self.labTime.hidden = _loginPwdCommonType;
        self.labTime.text = [NSString stringWithFormat:@"%.2d", _countdown];
        [self.btnGetTempPwd setTitle:@"秒后重试" forState:UIControlStateDisabled];
        _countdown--;
    }
}

//忘记密码
- (IBAction)forgotPwdBtnOnClick:(UIButton *)sender {
    if (_loginPwdCommonType) {
        ForgotPassword_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_forgotPwd"];
        vc.pwdAccountType = PwdAccountType_Login;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WebView_VC *vc = [[WebView_VC alloc] init];
        vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,KUrl_NoGetCodePage];;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

//注册
- (IBAction)regiestBtnOnClick:(UIButton *)sender {
    Regist_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_registVC"];
    vc.isFromNewFrature = self.isFromNewFrature;
    vc.isShowGuide = self.isShowGuide;
    vc.loginBlock = self.blcok;
//    RegisterGuide_VC *viewCtrl = [[RegisterGuide_VC alloc] init];
//    [self.navigationController pushViewController:viewCtrl animated:YES];
    
    WEAKSELF
    vc.block = ^(BOOL isShowGuide){
        NSString *username = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
        NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
        [weakSelf sendLoginRequestWithUsername:username password:password type:LoginPwdType_commonPassword isShowGuide:isShowGuide];
    };
    [self.navigationController pushViewController:vc animated:NO];
}

//登录
- (IBAction)loginBtnOnClick:(UIButton *)sender {
    if (self.phoneNumTF.text.length <= 0) {
        [UIHelper toast:@"用户名不能为空!"];
        return;
    }
    if (self.phoneNumTF.text.length != 11) {
        [UIHelper toast:@"用户名应为11位有效手机号码长度!"];
        return;
    }
    if (self.pwdTF.text.length <= 0) {
        [UIHelper toast:@"密码不能为空!"];
        return;
    }
    
    if (!_loginPwdCommonType && !_bGetAuthNum) {
        [UIHelper toast:@"请获取动态密码"];
        return;
    }

    NSString* username = self.phoneNumTF.text;
    NSString* password = self.pwdTF.text;
    LoginPwdType type;
    if (_loginPwdCommonType) {
        type = LoginPwdType_commonPassword;
    }else{
        type = LoginPwdType_dynamicSmsCode;
    }
    [self sendLoginRequestWithUsername:username password:password type:type];

}

#pragma mark - 发送登录请求
- (void)sendLoginRequestWithUsername:(NSString *)username password:(NSString *)password type:(LoginPwdType)type isShowGuide:(BOOL)isShowGuide{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] loginWithUsername:username pwd:password loginPwdType:type bolck:^(ResponseInfo *result) {
        if (result) {
            if (type == LoginPwdType_dynamicSmsCode && [result isKindOfClass:[ResponseInfo class]]) {
                ResponseInfo *response = (ResponseInfo*)result;
                if (response.errCode.integerValue == 8) {
                    DynamicPwdRegist_VC *vc = [DynamicPwdRegist_VC alloc];
                    vc.phone = username;
                    vc.authNum = password;
                    vc.boolBlock = ^(BOOL bRet){
                        if (bRet) {
                            [weakSelf reLogin:isShowGuide];
                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                [weakSelf backToLastViewWithLoginSuccess:@(100)];
            }else{
                [weakSelf lastLoginSuccess:isShowGuide withResponse:result];
            }
        }
    }];
    
}

- (void)sendLoginRequestWithUsername:(NSString *)username password:(NSString *)password type:(LoginPwdType)type{
    [self sendLoginRequestWithUsername:username password:password type:type isShowGuide:NO];
}

- (void)reLogin:(BOOL)isShowGuide{
    NSString *username = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    NSString *password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
    [self sendLoginRequestWithUsername:username password:password type:LoginPwdType_commonPassword isShowGuide:isShowGuide];
}

- (void)lastLoginSuccess:(BOOL)isShowGuide withResponse:(ResponseInfo *)response{
    if (self.isFromNewFrature) {    //其实从新特性页面过来的一定是跳引导页的
        if (isShowGuide) {
            [self showGuideVC:YES block:^(id result) {
                [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
                [XSJUIHelper showMainScene];
            }];
        }else{
            NSString *trueName = [response.content objectForKey:@"true_name"];
            if (!trueName.length) {
               [self showGuideVC:NO block:^(id result) {
                   [XSJUIHelper showMainScene];
               }];
            }else{
                [XSJUIHelper showMainScene];
            }
        }
    }else{
        [WDNotificationCenter postNotificationName:WDNotifi_LoginSuccess object:nil];
        if (isShowGuide) {
            WEAKSELF
            [self showGuideVC:YES block:^(id result) {
                [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
                [weakSelf backToLastViewWithLoginSuccess:@(100)];
            }];
        }else{
            NSString *trueName = [response.content objectForKey:@"true_name"];
            if (!trueName.length) {
                WEAKSELF
                [self showGuideVC:NO block:^(id result) {
                    [weakSelf backToLastViewWithLoginSuccess:@(100)];
                }];
            }else{
                [self backToLastViewWithLoginSuccess:@(100)];
            }
        }
    }
}

- (void)showGuideVC:(BOOL)isShowJobTrends block:(MKBlock)block{
//    WEAKSELF
    WelcomeJoinJK_VC *viewCtrl = [[WelcomeJoinJK_VC alloc] init];
    viewCtrl.isFromNewFeature = self.isFromNewFrature;
    viewCtrl.isNotShowJobTrends  = !isShowJobTrends;
    viewCtrl.block = block;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - 第三方登录======================
#pragma mark - QQ登陆
- (IBAction)qqLoginBtnOnClick:(UIButton *)sender {
    [TalkingData trackEvent:@"兼客登录_QQ"];
    ThirdPartAccountModel* qqAccount = [ThirdPartAccountModel qqAccount];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAccount.appID andDelegate:self];
    self.tencentOAuth.redirectURI = qqAccount.redirectURL;
    
    self.tencentOAuthPermissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_LIST_ALBUM, kOPEN_PERMISSION_UPLOAD_PIC, nil];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [self.tencentOAuth authorize:self.tencentOAuthPermissions inSafari:NO];
    }else{
        [UIHelper toast:@"你没有安装QQ"];
    }
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    ELog("===qq登录 授权成功");
    if (self.tencentOAuth.accessToken && self.tencentOAuth.accessToken.length != 0) {
        ELog(@"=========accessToken%@    =openId:%@",self.tencentOAuth.accessToken, self.tencentOAuth.openId);
        [self loginWithThirdPartType:WDThirdLogin_type_QQ accessToken:self.tencentOAuth.accessToken openId:self.tencentOAuth.openId];
    }
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        [UIHelper toast:@"您已取消登录"];
    }else{
        [UIHelper toast:@"登录失败"];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    [UIHelper toast:@"网络无法连接，请设置网络"];
}

#pragma mark - 微博
- (IBAction)sinaLoginBtnOnClick:(UIButton *)sender {
    //    ThirdPartAccountModel* weiboAccout = [ThirdPartAccountModel weiboAccount];
    [TalkingData trackEvent:@"兼客登录_微博"];
    WBAuthorizeRequest* request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.jianke.cc";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)getWeiBoAccessToken:(NSNotification *)notification{
    ELog(@"====微博授权后回调");
    WBAuthorizeResponse *response = notification.userInfo[WBLoginGetRespInfo];
    NSString *accessToken = response.accessToken;
    NSString *openId = response.userID;
    ELog(@"=====accessToken:%@,  openId:%@",accessToken,openId);
    // 发送登陆请求
    if (accessToken && accessToken.length != 0) {
        [self loginWithThirdPartType:WDThirdLogin_type_WeiBo accessToken:accessToken openId:openId];
    }
}

#pragma mark - 微信=================
- (IBAction)wxLoginBtnOnClick:(UIButton *)sender {
    [TalkingData trackEvent:@"兼客登录_微信"];
    // 安装了微信,并且安装的版本支持开放API
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        ELog(@"======安装了微信客户端");
        // 进行APP跳转授权
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"WXlogin";
        [WXApi sendReq:req];
    } else { // 没有安装微信
        ELog(@"没有安装微信客户端");
        // 进行网页授权
        [UIHelper toast:@"你没有安装微信"];
//        BindWechatViewController *vc = [[BindWechatViewController alloc] init];
//        NavC_WithStatusBar *nav = [[NavC_WithStatusBar alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)getWeiXinAccessToken:(NSNotification *)notification{
    
    ELog(@"线程----%@",[NSThread currentThread]);
    NSString* code = notification.userInfo[WXLoginGetCodeInfo];
    ThirdPartAccountModel* wechatAccount = [ThirdPartAccountModel wechatAccount];
    
    NSString *url =[NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatAccount.getAccessTokenURL, wechatAccount.appID, wechatAccount.appKey, code];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    WEAKSELF
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        ELog(@"=====response:%@", response);
        if (data) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 //            ELog(@"=====dic:%@", dic);
            // 发送登陆请求
            NSString *access_token = dic[@"access_token"];
            NSString *openid = dic[@"openid"];
            
            ELog(@"=========================== access_token =============== %@", access_token);
            ELog(@"=========================== openid =============== %@", openid);
            
            if (access_token && openid) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loginWithThirdPartType:WDThirdLogin_type_WeiXin accessToken:access_token openId:openid];
                });
            }
            
        }
    }];
    
}

#pragma mark - 第三方登陆公用方法
- (void)loginWithThirdPartType:(NSInteger)type accessToken:(NSString *)accessToken openId:(NSString *)openId{
    
    PostOathUserInfoPM* model = [[PostOathUserInfoPM alloc] init];
    model.thrid_plat_type = [[NSNumber alloc] initWithInteger:type];
    model.access_token = accessToken;
    model.open_id = openId;
    model.user_type = [[UserData sharedInstance] getLoginType];
    NSString* content = [model getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postOathUserInfo" andContent:content];
    request.isShowLoading = YES;
    request.loadingMessage = @"登录中...";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSNumber* oAuth_id = response.content[@"oauth_id"];
            
            if (oAuth_id && oAuth_id.integerValue != 0) {
                ELog(@"=====登陆成功，需要完善信息");
                PerfectInfo_VC* pvc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_perfectInfo"];
                pvc.oauth_id = response.content[@"oauth_id"];
                pvc.resBlock = ^(id obj){
                    if (weakSelf.isFromNewFrature) {
                        [XSJUIHelper showMainScene];
                    }else{
                        [[UserData sharedInstance] setLoginStatus:YES];
                        [[UserData sharedInstance] setLogoutActive:NO];
                        [WDNotificationCenter postNotificationName:WDNotifi_LoginSuccess object:nil];
                        [weakSelf backToLastViewWithLoginSuccess:@(100)];
                    }
                };
                [weakSelf.navigationController pushViewController:pvc animated:YES];
                
            }else{
            
                [[UserData sharedInstance] setLoginStatus:YES];
                [[UserData sharedInstance] setLogoutActive:NO];
                
                if (weakSelf.isFromNewFrature) {        //从引导页过来
                    [XSJUIHelper showMainScene];
                    
                    [WDNotificationCenter postNotificationName:PerfectResumeAlertViewNotification object:nil];
                }else{                              //个人中心过来
                    [UserData delayTask:0.3 onTimeEnd:^{
                        [WDNotificationCenter postNotificationName:WDNotifi_LoginSuccess object:nil];
                        [weakSelf backToLastViewWithLoginSuccess:@(100)];
                    }];
                }
            }
        }
    }];
}


- (IBAction)bgViewOnClick:(id)sender {
    [self.phoneNumTF resignFirstResponder];
    [self.pwdTF resignFirstResponder];
}

//返回
- (void)backToLastViewWithLoginSuccess:(NSNumber*)loginType{
    MKBlockExec(self.blcok, loginType);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textField delegate
- (IBAction)phoneInputChanged:(UITextField *)sender {
    if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}

- (IBAction)pwdInputChanged:(UITextField *)sender {
    if (sender.text.length > 32) {
        sender.text = [sender.text substringToIndex:32];
    }
}

#pragma mark - 重写返回事件
- (void)backToLastView{
    if (!self.isFromNewFrature) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismissVC{
    if (!self.isFromNewFrature) {
        MKBlockExec(self.blcok, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [XSJUIHelper showMainScene];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    DLog(@"dealloc");
    [WDNotificationCenter removeObserver:self];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
