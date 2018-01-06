//
//  EvaluationViewController.m
//  jianke
//
//  Created by yanqb on 2017/5/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EvaluationViewController.h"
#import "UIPlaceHolderTextView.h"

@interface EvaluationViewController (){
    NSInteger _maxLengh;
}

@property (nonatomic, weak) UIPlaceHolderTextView *textView;
@property (nonatomic, weak) UILabel *labTip;


@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自我评价";
    [self setupViews];
}

- (void)setupViews{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
    
    _maxLengh = 120;
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
    textView.placeholder = @"独特的自我评价能加深雇主对你的印象";
    textView.placeholderColor = [UIColor XSJColor_tGrayDeepTransparent32];
    textView.backgroundColor = [UIColor XSJColor_newGray];
    textView.text = self.str;
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.maxLength = _maxLengh;
    self.textView = textView;
    
    UIButton *rebtn = [UIButton buttonWithTitle:@"重写" bgColor:MKCOLOR_RGB(232, 247, 250) image:nil target:self sector:@selector(reWrithAction:)];
    [rebtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [rebtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rebtn setCornerValue:14];
    
    UILabel *lable = [[UILabel alloc]init];
    [lable setFont:[UIFont systemFontOfSize:12]];
    lable.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    lable.attributedText = [self getMutableAttStrWith:self.str];
    _labTip = lable;
    
    WEAKSELF
    textView.block = ^(NSString *text){
        weakSelf.labTip.attributedText = [weakSelf getMutableAttStrWith:text];
    };
    
    [self.view addSubview:textView];
    [self.view addSubview:rebtn];
    [self.view addSubview:lable];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(220);
        
    }];
    
    [rebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(28);
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rebtn);
        make.right.equalTo(self.view).offset(-16);
    }];
}

- (void)reWrithAction:(UIButton *)sender{
    self.textView.text = nil;
}
- (NSMutableAttributedString *)getMutableAttStrWith:(NSString *)text{
    if (!text.length) {
        text = @"";
    }
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"还能输入" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    NSString *str = [NSString stringWithFormat:@"%ld", _maxLengh - text.length];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];
    return mutableAttStr;
}

- (void)rightItemOnClick{
    [self.view endEditing:YES];
    
    self.textView.text = (self.textView.text.length) ? self.textView.text: @"";
    
    [[XSJRequestHelper sharedInstance] postResumeOtherInfoWithDes:self.textView.text isPublick:nil block:^(id result) {
        if (result) {
            [UIHelper toast:@"已保存"];
            MKBlockExec(self.block, nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)backToLastView{
    [self check:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)check:(MKBlock)block{
    
    BOOL isModified = NO;
    if (self.str.length) {
        if (![self.textView.text isEqualToString:self.str]) {
            isModified = YES;
        }
    }else if (self.textView.text.length){
        isModified = YES;
    }
    if (isModified) {
        [MKAlertView alertWithTitle:nil message:@"您编辑的信息还未保存，确定要退出吗？" cancelButtonTitle:@"果断退出" confirmButtonTitle:@"留在这里" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                MKBlockExec(block, nil);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
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
