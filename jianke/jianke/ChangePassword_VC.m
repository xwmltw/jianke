//
//  ChangePassword_VC.m
//  jianke
//
//  Created by 郑东喜 on 15/9/26.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "ChangePassword_VC.h"
#import "UIHelper.h"
#import "UserData.h"
#import "RsaHelper.h"


@interface ChangePassword_VC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *newsPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;


@end

@implementation ChangePassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_btnChangePassword setCornerValue:20];
    
    if (self.pwdAccountType == PwdAccountType_MoneyBag){
        self.title = @"修改钱袋子密码";
        self.oldPassword.keyboardType = UIKeyboardTypeNumberPad;
        self.newsPassword.keyboardType = UIKeyboardTypeNumberPad;
        self.confirmPwd.keyboardType = UIKeyboardTypeNumberPad;
        
        self.oldPassword.placeholder = @"请输入原密码(6位数字)";
        self.newsPassword.placeholder = @"请输入6位数字新密码";
        
    }else if (self.pwdAccountType == PwdAccountType_Login){
        self.title =@"修改登录密码";
    }
    
    self.oldPassword.secureTextEntry = YES;
    self.newsPassword.secureTextEntry = YES;
    self.confirmPwd.secureTextEntry = YES;
    
    [self.btnChangePassword setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [self.btnChangePassword setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackEvent:@"修改登录密码_返回"];
}
- (IBAction)changePwd:(UIButton *)sender {

    if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"修改登录密码_确定"];

    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"修改钱袋子密码_确定"];
    }
    if (self.oldPassword.text.length <= 0) {
        [UIHelper toast:@"请输入原密码"];
        return;
    }
    
    if (self.pwdAccountType == PwdAccountType_MoneyBag) {
        if (self.newsPassword.text.length != 6) {
            [UIHelper toast:@"请设置6位数字的密码"];
            return;
        }
    }else{
        if (self.newsPassword.text.length < 6) {
            [UIHelper toast:@"新密码不能少于6位"];
            return;
        }
        if (self.newsPassword.text.length > 32) {
            [UIHelper toast:@"密码长度不能超过32位"];
        }
    }
   
    if (![self.newsPassword.text isEqualToString:self.confirmPwd.text]) {
        
        [UIHelper toast:@"两次输入密码不一致"];
        return;
    }
    
    [self sendMsg];
    
}

- (void)sendMsg {
    
//    NSString *password = self.tfPassword.text;
//    
//    NSData* pass_data = [RsaHelper encryptString:self.tfPassword.text publicKey:nil];
//    password = [NetHelper bytesToHexString:pass_data];
    
    
    NSData* oldPassData = [RsaHelper encryptString:self.oldPassword.text publicKey:nil];
    NSString* oldPassword = [[WDRequestMgr sharedInstance] bytesToHexString:oldPassData];

    NSData* newPassData = [RsaHelper encryptString:self.newsPassword.text publicKey:nil];
    NSString* newPwd = [[WDRequestMgr sharedInstance] bytesToHexString:newPassData];
   
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    
    
    if (self.pwdAccountType == PwdAccountType_MoneyBag) {
        NSString* content = [NSString stringWithFormat:@"oldPassword:\"%@\",newPassword:\"%@\"", oldPassword, newPwd];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_modifyMoneyBagPassword" andContent:content];
        request.isShowLoading = YES;
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            if (response && [response success]) {
                [UIHelper toast:@"钱袋子密码修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        
    }else if (self.pwdAccountType == PwdAccountType_Login){
        
        NSString* content = [NSString stringWithFormat:@"oldPassword:\"%@\",newPassword:\"%@\",user_type:%@",
                             oldPassword, newPwd, userType];
        
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_modifyPassword" andContent:content];
        request.isShowLoading = YES;
        [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
            if (response && [response success]) {
                [[XSJUserInfoData sharedInstance] setPassword:self.newsPassword.text];
                [UIHelper toast:@"登录密码更改成功！"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
  
}
//限制密码长度为32.
- (IBAction)oldPwd:(UITextField *)sender {
       if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"修改登录密码_原密码"];
        if (sender.text.length > 32) {
            sender.text = [sender.text substringToIndex:32];
        }
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"修改钱袋子密码_原密码"];
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }
}
- (IBAction)newPwd:(UITextField *)sender {
       if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"修改登录密码_新密码"];
        if (sender.text.length > 32) {
            sender.text = [sender.text substringToIndex:32];
        }
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"修改钱袋子密码_新密码"];
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }
}
- (IBAction)confirmPwd:(UITextField *)sender {
        if (self.pwdAccountType == PwdAccountType_Login) {
        if (sender.text.length > 32) {
            sender.text = [sender.text substringToIndex:32];
        }
    }else if (self.pwdAccountType == PwdAccountType_MoneyBag){
        [TalkingData trackEvent:@"修改钱袋子密码_确定密码"];
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.pwdAccountType == PwdAccountType_Login) {
        [TalkingData trackEvent:@"账号信息_找回登录密码_返回"];
    }
}

- (IBAction)viewBgOnClick:(UIView *)sender {
    [self.oldPassword resignFirstResponder];
    [self.newsPassword resignFirstResponder];
    [self.confirmPwd resignFirstResponder];
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
