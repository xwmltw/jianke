//
//  MoneyBagPasswordManager.m
//  jianke
//
//  Created by xiaomk on 16/4/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MoneyBagPasswordManager.h"
#import "WDConst.h"
#import "QueryAccountMoneyModel.h"
#import "XSJNetWork.h"

@interface MoneyBagPasswordManager()<UIAlertViewDelegate>{
    
}

@property (nonatomic, copy) MKBlock blockSetPwd;
@property (nonatomic, copy) MKBlock blockCommitPwd;
@property (nonatomic, strong) MoneyBagInfoModel* mbiModel;
@end

@implementation MoneyBagPasswordManager
Impl_SharedInstance(MoneyBagPasswordManager);

#pragma mark - ***** 设置钱袋子密码 ******
- (void)setPasswordSuccess:(MKBlock)blockSetPwd{
    [self setPasswordSuccess:YES block:blockSetPwd];
}

- (void)setPasswordSuccess:(BOOL)isShowLoding block:(MKBlock)blockSetPwd{
    if (blockSetPwd == nil) {
        return;
    }
    self.blockSetPwd = blockSetPwd;
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryAccountMoney" andContent:nil];
    request.isShowLoading = isShowLoding;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            weakSelf.mbiModel = [MoneyBagInfoModel objectWithKeyValues:response.content];
            
            if (weakSelf.mbiModel.account_money_info.has_set_bag_pwd.intValue == 0) {
                [weakSelf showPwdActionSheet];
            }else{
                blockSetPwd(weakSelf.mbiModel);
            }
        }else{
            blockSetPwd(nil);
        }
    }];
}


/** 首次设置钱袋子密码弹窗 */
- (void)showPwdActionSheet{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"钱袋子密码" message:@"为保证资金安全，请设置钱袋子密码。重要操作需要输密码完成。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 100;
    
    UITextField* tfPwd = [alert textFieldAtIndex:0];
    tfPwd.placeholder = @"请输入六位钱袋子密码";
    tfPwd.keyboardType = UIKeyboardTypeNumberPad;
    tfPwd.secureTextEntry = YES;
    [tfPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [alert show];
}

/** 设置密码 */
- (void)setMoneyPwd:(NSString*)password{
    NSData* passData = [RsaHelper encryptString:password publicKey:nil];
    NSString* pass = [[WDRequestMgr sharedInstance] bytesToHexString:passData];
    
    NSString* content = [NSString stringWithFormat:@"password:\"%@\"",pass];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_installMoneyBagPassword" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"设置成功"];
            if (weakSelf.blockSetPwd) {
                weakSelf.blockSetPwd(weakSelf.mbiModel);
            }
        }else{
            if (weakSelf.blockSetPwd) {
                weakSelf.blockSetPwd(nil);
            }
        }
    }];
}


#pragma mark - ***** 验证钱袋子密码 ******
- (void)showCommitPassword:(MKBlock)blockCommitPwd{
    if (blockCommitPwd == nil) {
        return;
    }
    self.blockCommitPwd = blockCommitPwd;
    [self showAlertViewWithCommitPassword];
}

- (void)showAlertViewWithCommitPassword{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入钱袋子密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    alert.tag = 200;
    
    UITextField* tfPwd = [alert textFieldAtIndex:0];
    tfPwd.placeholder = @"请输入六位钱袋子密码";
    tfPwd.keyboardType = UIKeyboardTypeNumberPad;
    tfPwd.secureTextEntry = YES;
    [tfPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [alert show];
}

- (void)commitPassword:(NSString*)password{
    NSString *pwd = [[[NSString stringWithFormat:@"%@%@",password,[XSJNetWork getChallenge]]MD5]uppercaseString];
    NSString *content = [NSString stringWithFormat:@"acct_encpt_password:\"%@\"",pwd];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_userConfirmAccountMoneyPassword" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            if (weakSelf.blockCommitPwd) {
                weakSelf.blockCommitPwd(password);
            }
        }else{
            [weakSelf showAlertViewWithCommitPassword];
        }
    }];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
  
    if (alertView.tag == 100) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            if (self.blockSetPwd) {
                self.blockSetPwd(nil);
            }
        }else if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField* tfPsw = [alertView textFieldAtIndex:0];
            if (tfPsw.text.length != 6) {
                [self showPwdActionSheet];
                [UIHelper toast:@"请输入六位钱袋子密码"];
                return;
            }
            [self setMoneyPwd:tfPsw.text];
        }
    }else if (alertView.tag == 200){
        if (buttonIndex == alertView.cancelButtonIndex) {
            if (self.blockCommitPwd) {
                self.blockCommitPwd(nil);
            }
        }else if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField* tfPsw = [alertView textFieldAtIndex:0];
            if (tfPsw.text.length != 6) {
                [self showAlertViewWithCommitPassword];
                [UIHelper toast:@"请输入六位钱袋子密码"];
                return;
            }
            [self commitPassword:tfPsw.text];
        }
    }
}


- (void)textFieldDidChange:(UITextField*)textField{
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}


@end
