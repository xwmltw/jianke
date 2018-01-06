//
//  RedBaoRule_VC.m
//  jianke
//
//  Created by yanqb on 2017/7/4.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "RedBaoRule_VC.h"
#import "WDConst.h"

@interface RedBaoRule_VC ()

@end

@implementation RedBaoRule_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动细则";
    UILabel *labTitle = [[UILabel alloc]init];
    labTitle.text =self.labDesc;
    [labTitle setFont:[UIFont systemFontOfSize:24.0f]];
    [labTitle setTextColor:MKCOLOR_RGB(34, 58, 80)];
    
    UILabel *lab= [[UILabel alloc]init];
    lab.text = @"活动细则";
    [lab setFont:[UIFont systemFontOfSize:15.0f]];
    [lab setTextColor:MKCOLOR_RGB(34, 58, 80)];
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.numberOfLines = 0;
    lab1.text = self.content;
    [lab1 setFont:[UIFont systemFontOfSize:15.0f]];
    [lab1 setTextColor:MKCOLOR_RGBA(34, 58, 80,0.48)];
    
//    UILabel *lab2 = [[UILabel alloc]init];
//    lab2.numberOfLines = 0;
//    lab2.text = @"2. 红包金额1-10元不等,数量有限,先到先得,祝您好运！";
//    [lab2 setFont:[UIFont systemFontOfSize:15.0f]];
//    [lab2 setTextColor:MKCOLOR_RGBA(34, 58, 80,0.48)];
//    
//    UILabel *lab3 = [[UILabel alloc]init];
//    lab3.numberOfLines = 0;
//    lab3.text = @"3. 每人每天仅限2次分享";
//    [lab3 setFont:[UIFont systemFontOfSize:15.0f]];
//    [lab3 setTextColor:MKCOLOR_RGBA(34, 58, 80,0.48)];
//    
//    UILabel *lab4 = [[UILabel alloc]init];
//    lab4.numberOfLines = 0;
//    lab4.text = @"4.领取到的红包金额将自动进入【钱袋子】,您可通过钱袋子查看获奖详情。";
//    [lab4 setFont:[UIFont systemFontOfSize:15.0f]];
//    [lab4 setTextColor:MKCOLOR_RGBA(34, 58, 80,0.48)];
//    
//    UILabel *lab5 = [[UILabel alloc]init];
//    lab5.numberOfLines = 0;
//    lab5.text = @"5. 本活动与苹果商店无关,兼客兼职拥有该活动的所有解释权。";
//    [lab5 setFont:[UIFont systemFontOfSize:15.0f]];
//    [lab5 setTextColor:MKCOLOR_RGBA(34, 58, 80,0.48)];
    
    [self.view addSubview:labTitle];
    [self.view addSubview:lab];
    [self.view addSubview:lab1];
//    [self.view addSubview:lab2];
//    [self.view addSubview:lab3];
//    [self.view addSubview:lab4];
//    [self.view addSubview:lab5];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo (self.view).offset(24);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(labTitle.mas_bottom).offset(16);
    }];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(lab.mas_bottom).offset(8);
    }];
//    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(16);
//        make.right.equalTo(self.view).offset(-16);
//        make.top.equalTo(lab1.mas_bottom).offset(8);
//    }];
//    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(16);
//        make.right.equalTo(self.view).offset(-16);
//        make.top.equalTo(lab2.mas_bottom).offset(8);
//    }];
//    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(16);
//        make.right.equalTo(self.view).offset(-16);
//        make.top.equalTo(lab3.mas_bottom).offset(8);
//    }];
//    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(16);
//        make.right.equalTo(self.view).offset(-16);
//        make.top.equalTo(lab4.mas_bottom).offset(8);
//    }];
    
    
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
