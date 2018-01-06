//
//  MKMessageComposeHelper.m
//  jianke
//
//  Created by xiaomk on 16/7/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKMessageComposeHelper.h"
#import <MessageUI/MessageUI.h>
#import "XSJConst.h"

@interface MKMessageComposeHelper ()<MFMessageComposeViewControllerDelegate>{

}
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) MFMessageComposeViewController *mcVC;
@property (nonatomic, copy) MKBlock block;

@end

@implementation MKMessageComposeHelper

Impl_SharedInstance(MKMessageComposeHelper);

//- (MFMessageComposeViewController *)mcVC{
//    if (!_mcVC) {
//        _mcVC = [[MFMessageComposeViewController alloc] init];
//        _mcVC.messageComposeDelegate = self;
//    }
//    return _mcVC;
//}


- (void)showWithRecipientArray:(NSArray *)recipientArray onViewController:(UIViewController *)vc block:(MKBlock)block{
    [self showWithRecipientArray:recipientArray body:nil onViewController:vc block:block];
}

- (void)showWithRecipientArray:(NSArray *)recipientArray body:(NSString *)body onViewController:(UIViewController *)vc block:(MKBlock)block{
    // 判断当前设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        [XSJUIHelper showToast:@"请确认设备是否支持发送短信，是否插入SIM卡"];
        return ;
    }
    
    // 设置收件人列表
    if (!vc) {
        return;
    }
    self.vc = vc;
    self.block = block;

    self.mcVC = nil;
    self.mcVC = [[MFMessageComposeViewController alloc] init];
    self.mcVC.messageComposeDelegate = self;
    self.mcVC.recipients = [NSArray arrayWithArray:recipientArray];
    self.mcVC.navigationBar.tintColor = [UIColor whiteColor];
    self.mcVC.body = body;
    
    double delayInSeconds = 0.1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc presentViewController:self.mcVC animated:YES completion:nil];
    });
}

#pragma mark - ***** MFMessageComposeViewControllerDelegate ******
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultSent) {
        [UIHelper toast:@"发短信成功"];
    }else if(result == MessageComposeResultCancelled){
        [UIHelper toast:@"取消发短信"];
    }else if(result == MessageComposeResultFailed){
        [UIHelper toast:@"发短信失败"];
    }
    MKBlockExec(self.block,@(1));
}

@end
