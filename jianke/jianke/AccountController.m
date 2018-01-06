//
//  AccountController.m
//  jianke
//
//  Created by fire on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  账号信息

#import "AccountController.h"
#import "ChangePhoneNum_VC.h"
#import "ChangePassword_VC.h"
#import "ForgotPassword_VC.h"
#import "WDConst.h"

@interface AccountController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号信息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor XSJColor_grayTinge];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 32;
    }else{
        return 32;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    view.backgroundColor = [UIColor XSJColor_grayTinge];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, SCREEN_WIDTH - 20, 20)];
    label.textColor = MKCOLOR_RGB(128, 128, 128);
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    if (section == 0) {
        NSString* userPhone = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    
        label.text =[NSString stringWithFormat:@"当前登录账号:%@",userPhone];
    }else if (section == 1){
        label.text = @"更改密码";
    }else if (section == 2){
        label.text = @"找回密码";

    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (section == 0) {
        number = 1;
    }else if (section == 1){
        number = 2;
    }else if (section == 2){
        number = 2;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"accountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = MKCOLOR_RGBA(34, 58, 80, 0.8);
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"更换绑定账号";
//        cell.imageView.image = [UIImage imageNamed:@"v250_cellphone"];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"登录密码";
//            cell.imageView.image = [UIImage imageNamed:@"v250_loadcode"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"钱袋子密码";
//            cell.imageView.image = [UIImage imageNamed:@"v250_moneycode"];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"登录密码";
//            cell.imageView.image = [UIImage imageNamed:@"v250_loadcode"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"钱袋子密码";
//            cell.imageView.image = [UIImage imageNamed:@"v250_moneycode"];
        }
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return  1;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.section == 0) {
        ChangePhoneNum_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_changePhoneNumber"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ChangePassword_VC* vc =[UIHelper getVCFromStoryboard:@"Main" identify:@"sid_changePassword"];
            vc.pwdAccountType = PwdAccountType_Login;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            ChangePassword_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_changePassword"];
            vc.pwdAccountType = PwdAccountType_MoneyBag;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ForgotPassword_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_forgotPwd"];
            vc.pwdAccountType = PwdAccountType_Login;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1){
            ForgotPassword_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_forgotPwd"];
            vc.pwdAccountType = PwdAccountType_MoneyBag;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}


@end
