//
//  DynamicPwdRegist_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "DynamicPwdRegist_VC.h"
#import "XSJConst.h"

@interface DynamicPwdRegist_VC ()

@property (nonatomic, strong) UITextField *tfName;
@property (nonatomic, strong) UITextField *tfPassword;
@end

@implementation DynamicPwdRegist_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写信息";
    self.view.backgroundColor = [UIColor XSJColor_grayTinge];
    
    [self setupUI];
    
}

- (void)btnRegiestOnclick:(UIButton *)sender{
    if (self.tfName.text.length == 0) {
        [UIHelper toast:@"请输入您的姓名"];
        return;
    }
    
    if (self.tfPassword.text.length < 6){
        [UIHelper toast:@"请输入6-20位密码"];
        return;
    }
    
  
    
    NSString *password = self.tfPassword.text;
    NSData *passDada = [RsaHelper encryptString:password publicKey:nil];
    NSString *pass = [[WDRequestMgr sharedInstance] bytesToHexString:passDada];
    
    NSNumber *loginType = [[UserData sharedInstance] getLoginType];

    RegistUserByPhoneNumPM *model = [[RegistUserByPhoneNumPM alloc] init];
    model.phone_num = self.phone;
    model.sms_authentication_code = self.authNum;
    model.password = pass;
    model.user_type = loginType;
    model.true_name = self.tfName.text;
    
    NSString* content = [model getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_registUserByPhoneNum" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {

            [[XSJUserInfoData sharedInstance] savePhone:weakSelf.phone password:self.tfPassword.text];
            MKBlockExec(weakSelf.boolBlock, YES)
        }
    }];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.tfName) {
        if (self.tfName.text.length >= 20) {
            self.tfName.text  = [self.tfName.text substringToIndex:20];
        }
    }else if (textField == self.tfPassword){
        if (self.tfPassword.text.length > 20) {
            self.tfPassword.text = [self.tfPassword.text  substringToIndex:20];
        }
    }
}

- (void)setupUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v231_card_bg"]];
    [bgView addSubview:imgBg];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = MKCOLOR_RGB(228, 228, 228);
    [bgView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = MKCOLOR_RGB(228, 228, 228);
    [bgView addSubview:line2];
    
    
    UITextField *tfName = [[UITextField alloc] init];
    tfName.placeholder = @"姓名";
    tfName.font = [UIFont systemFontOfSize:16];
    [tfName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [bgView addSubview:tfName];
    self.tfName = tfName;
    
    UITextField *tfPassword = [[UITextField alloc] init];
    tfPassword.placeholder = @"设置密码";
    tfPassword.font = [UIFont systemFontOfSize:16];
    [tfPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    tfPassword.secureTextEntry = YES;
    [bgView addSubview:tfPassword];
    self.tfPassword = tfPassword;
    
    UIButton *btnRegiest = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegiest setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [btnRegiest setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"]  forState:UIControlStateHighlighted];
    [btnRegiest setTitle:@"完成" forState:UIControlStateNormal];
    [btnRegiest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegiest addTarget:self action:@selector(btnRegiestOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnRegiest];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_offset(180);
    }];
    
    [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(bgView).offset(54);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(line1.mas_bottom).offset(54);
    }];
    
    [tfName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(16);
        make.right.equalTo(bgView).offset(-16);
        make.top.equalTo(bgView);
        make.bottom.equalTo(line1.mas_top);
    }];
    
    [tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(16);
        make.right.equalTo(bgView).offset(-16);
        make.top.equalTo(line1.mas_bottom);
        make.bottom.equalTo(line2.mas_top);
    }];
    
    [btnRegiest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(16);
        make.right.equalTo(bgView).offset(-16);
        make.top.equalTo(line2.mas_bottom).offset(12);
        make.bottom.equalTo(bgView).offset(-16);
    }];
    
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
