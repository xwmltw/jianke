//
//  TalkToBoss.m
//  jianke
//
//  Created by 郑东喜 on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "TalkToBoss_VC.h"
#import "UIHelper.h"
#import "UserData.h"
#import "FeedbackModel.h"
#import "WDConst.h"
#import "NetHelper.h"
#import "RsaHelper.h"
#import "UserData.h"
#import "DateHelper.h"
#import "QuartzCore/QuartzCore.h"
#import "BaseButton.h"
#import "ParamModel.h"

@interface TalkToBoss_VC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTvBg;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtnChange;      /*!< 提交按钮 */
@property (weak, nonatomic) IBOutlet UITextView *alertMessage;      /*!< 注意事项 */
@property (weak, nonatomic) IBOutlet UITextView *editSuggsetion;    /*!< 反馈输入框 */

@property (weak, nonatomic) IBOutlet UILabel *showAlert;            /*!< 反馈文字提示 */
@property (nonatomic, strong) FeedbackModel* feedbackInfo;
@property (weak, nonatomic) IBOutlet BaseButton *selectBtn;
@property (nonatomic, copy) NSArray *feedbackClassifyLisy;          /*!< 意见反馈类型列表 */
@property (nonatomic, strong) FeedbackParam *feedbackModel;         /*!< 提交意见类型 */

- (IBAction)selectQuestionType:(BaseButton *)sender;

@end

@implementation TalkToBoss_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"对话产品汪";
    [self.selectBtn setMarginForImg:-10 marginForTitle:0];
    [self.viewTvBg addBorderInDirection:BorderDirectionTypeTop | BorderDirectionTypeBottom borderWidth:0.7 borderColor:[UIColor XSJColor_tGrayTinge] isConstraint:YES];
    
    _editSuggsetion.delegate = self;
    _selectBtn.userInteractionEnabled = NO;
    _showAlert.hidden = NO;
    
    self.feedbackModel = [[FeedbackParam alloc] init];
    [self getClassfiyList];
}

/**
 *输出网络请求信息
 **/
-(void)sendMsg {
    CityModel* cityModel = [[UserData sharedInstance] city];
    
    SubmitFeedbackV2* contModel = [[SubmitFeedbackV2 alloc] init];
    contModel.city_id = cityModel.parent_id;
    contModel.address_area_id = cityModel.id;
    contModel.phone_num = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    contModel.desc = self.editSuggsetion.text;
    contModel.feedback_classify = self.feedbackModel.id;
    
    NSString* content = [contModel getContent];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_submitFeedback_v2" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            [UIHelper toast:@"提交成功！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [UIHelper toast:@"提交失败，请重新提交！"];
        }
    }];
}

// 获取意见分类
- (void)getClassfiyList{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:NO withBlock:^(ClientGlobalInfoRM *result) {
        if (result) {
            weakSelf.feedbackClassifyLisy = result.feedback_classify_list;
            weakSelf.selectBtn.userInteractionEnabled = YES;
        }
    }];
}

//复制qq群号码
- (IBAction)showAlert:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString* qqShareNum = @"257635945";
    [pab setString:qqShareNum];
    
    [UIHelper toast:@"已复制Q群号码"];
}

- (IBAction)btnTalkToBoss:(UIButton *)sender {
    ELog("=====text：%@",_editSuggsetion.text)
    if (_editSuggsetion.text.length == 0) {
        [_editSuggsetion resignFirstResponder];
        [UIHelper toast:@"请输入反馈信息！"];
        return;
    }
    
    if (_editSuggsetion.text.length > 0) {
        [self sendMsg];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    ELog("====textViewDidBeginEditing");
    //    _showAlert.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_editSuggsetion.text.length > 0) {
        _showAlert.hidden = YES;
    }else if (_editSuggsetion.text.length == 0) {
        _showAlert.hidden = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_editSuggsetion.text.length <= 0) {
        _showAlert.hidden = NO;
    }
}


- (IBAction)viewBgOnClick:(id)sender {
    [self.editSuggsetion resignFirstResponder];
}


- (IBAction)selectQuestionType:(BaseButton *)sender {
    [self.view endEditing:YES];
    
    NSArray *titles = [self.feedbackClassifyLisy valueForKey:@"name"];
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:titles];
    sheet.needCancelButton = NO;
    [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        [sender setTitle:titles[buttonIndex] forState:UIControlStateNormal];
        self.feedbackModel = [FeedbackParam objectWithKeyValues:self.feedbackClassifyLisy[buttonIndex]];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
