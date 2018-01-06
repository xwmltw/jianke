//
//  MoneyBagSetPassword_VC.m
//  jianke
//
//  Created by xiaomk on 15/10/6.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MoneyBagSetPassword_VC.h"
#import "UIHelper.h"
#import "WDConst.h"

@interface MoneyBagSetPassword_VC ()

@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfPwdConfirm;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecret;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecretCheck;
@end

@implementation MoneyBagSetPassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置钱袋子密码";
    self.tfPwd.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPwdConfirm.keyboardType = UIKeyboardTypeNumberPad;
    
    // Do any additional setup after loading the view.
}


//密码长度限制

- (IBAction)TFPwdChange:(UITextField *)sender {
    if (sender.text.length > 0) {
        self.imgSecret.hidden = YES;
    }else{
        self.imgSecret.hidden = NO;
    }
    if (sender.text.length > 6) {
        sender.text = [sender.text substringToIndex:6];
    }
}
//确认密码
- (IBAction)TFPwdConfirmNum:(UITextField *)sender {

    if (sender.text.length > 0) {
        self.imgSecretCheck.hidden = YES;
    }else{
        self.imgSecretCheck.hidden = NO;
    }
    if (sender.text.length > 6) {
        sender.text = [sender.text substringToIndex:6];
    }
}

- (IBAction)btnSendOnclick:(UIButton *)sender {
    
    if (self.tfPwd.text.length != 6) {
        [UIHelper toast:@"请设置6位数字的密码"];
        return;
    }
    
    if (![self.tfPwdConfirm.text isEqualToString:self.tfPwd.text]) {
        [UIHelper toast:@"两次密码输入不一致"];
        return;
    }
    
    NSString* password = self.tfPwd.text;
    NSData* passData = [RsaHelper encryptString:password publicKey:nil];
    NSString* pass = [[WDRequestMgr sharedInstance] bytesToHexString:passData];
    
    NSString* content = [NSString stringWithFormat:@"password:\"%@\"",pass];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_installMoneyBagPassword" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
