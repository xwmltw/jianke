//
//  VerificationCode _VC.m
//  jianke
//
//  Created by xuzhi on 16/8/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "VerificationCode _VC.h"
#import "UILabel+MKExtension.h"
#import "Masonry.h"
#import "UIButton+Extension.h"

@interface VerificationCode__VC ()

@end

@implementation VerificationCode__VC

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel labelWithText:@"无法获取验证码，参考以下解决方法" textColor:[UIColor whiteColor] fontSize:14.0f];
    label.frame = CGRectMake(0, 100, SCREEN_WIDTH - 100, 44);
    label.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = label;
    [self initUI];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"1、检查短信是否被其他应用软件拦截；",@"2、确认手机已缴费且正常服务正常；",@"3、联系运营商取消黑名单；",@"4、如果是信号网络延迟，可稍后尝试重新获取。"];
    UILabel *label = nil;
    for (NSInteger index = 0; index < array.count; index++) {
        label = [UILabel labelWithText:array[index] textColor:nil fontSize:14.0f];
        label.frame = CGRectMake(16, 50+20*index, SCREEN_WIDTH - 32, 20);
        [self.view addSubview:label];
    }
    
    label = [UILabel labelWithText:@"如以上方法无法解决，" textColor:nil fontSize:14.0f];
    label.frame = CGRectMake(16, 100+20*3, SCREEN_WIDTH - 32, 30);
    [self.view addSubview:label];
    
    UILabel *leftLabel = [UILabel labelWithText:@"请拨打：" textColor:nil fontSize:14.0f];
    UIButton *button = [UIButton buttonWithTitle:@"400-168-9788" bgColor:nil image:nil target:self sector:@selector(callAction:)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UILabel *rightLabel = [UILabel labelWithText:@" 获取帮助" textColor:nil fontSize:14.0f];
    
    [self.view addSubview:leftLabel];
    [self.view addSubview:rightLabel];
    [self.view addSubview:button];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(label.mas_bottom);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@1);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(leftLabel);
        make.leading.equalTo(leftLabel.mas_trailing);
        make.width.greaterThanOrEqualTo(@1);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(leftLabel);
        make.leading.equalTo(button.mas_trailing);
        make.width.greaterThanOrEqualTo(@1);
    }];
    
}

- (void)callAction:(UIButton *)sender{
    [[MKOpenUrlHelper sharedInstance] makeCallWithPhone:@"400-168-9788"];
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
