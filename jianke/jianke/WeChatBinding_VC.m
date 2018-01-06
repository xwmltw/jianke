//
//  WeChatBinding_VC.m
//  jianke
//
//  Created by xiaomk on 16/3/7.V270_img_qrcode
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WeChatBinding_VC.h"
#import "WDConst.h"

@interface WeChatBinding_VC (){
    NSString* _qrCodeUrl;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgViewQr;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveImg;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenWeChat;

@end

@implementation WeChatBinding_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"绑定微信";
    
    [UIHelper setCorner:self.btnSaveImg];
    [UIHelper setCorner:self.btnOpenWeChat];
    [UIHelper setBorderWidth:1 andColor:[UIColor XSJColor_base] withView:self.btnOpenWeChat];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_getBindWechatPublicQrCode" andContent:nil];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response){
            _qrCodeUrl = response.content[@"QrCodeUrl"];
            if (_qrCodeUrl.length > 0) {
                [weakSelf showQRCodeImage];
            }
        }
    }];
}

- (void)showQRCodeImage{
    UIImage* qrImage = [MKCommonHelper createQrImageWithUrl:_qrCodeUrl withImgWidth:155];
    self.imgViewQr.image = qrImage;
}

- (IBAction)btnSaveImgOnclick:(UIButton *)sender {
    [[MKCommonHelper sharedInstance] saveImageToPhotoLib:self.imgViewQr.image];
}

- (IBAction)btnOpenWeChatOnclick:(UIButton *)sender {
//    NSString* urlStr = @"http://weixin.qq.com/r/uEjYwFbESQs2rRKj9x2q";
    NSString* urlStr = @"weixin://";
    NSURL* url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [UIHelper toast:@"你没有安装微信"];
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
