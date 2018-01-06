//
//  PhoneRecallCourse_VC.m
//  jianke
//
//  Created by fire on 16/9/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PhoneRecallCourse_VC.h"
#import "UIPlaceHolderTextView.h"

@interface PhoneRecallCourse_VC ()

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeLab;

@end

@implementation PhoneRecallCourse_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他";
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
    textView.maxLength = 50;
    textView.backgroundColor = [UIColor XSJColor_grayTinge];
    textView.placeholder = @"未报名成功的其他原因";
    self.textView = textView;
    
    UIButton *button = [UIButton buttonWithTitle:@"提交" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(submitAction:)];
    
    [self.view addSubview:textView];
    [self.view addSubview:button];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@170);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(20);
        make.left.equalTo(@16);
        make.right.equalTo(@(-16));
        make.height.equalTo(@44);
    }];
    
}

- (void)submitAction:(UIButton *)sender{
    if (!self.textView.text || !self.textView.text.length) {
        [UIHelper toast:@"内容不能为空"];
        return;
    }
    if (self.textView.text.length > 50) {
        [UIHelper toast:@"内容不能超过50字"];
        return;
    }
    
    [[XSJRequestHelper sharedInstance] postStuContactApplyJob:self.jobId resultType:self.type remark:self.textView.text block:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"提交成功"];
            MKBlockExec(self.block, YES);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//- (void)textViewDidChange:(UITextView *)textView{
//
//    self.placeLab.hidden = (textView.text.length > 0) ? YES : NO ;
//}

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
