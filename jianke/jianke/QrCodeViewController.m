//
//  QrCodeViewController.m
//  jianke
//
//  Created by fire on 15/11/9.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "QrCodeViewController.h"
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "UserData.h"

@interface QrCodeViewController ()

@property (nonatomic, weak) UIButton *reflushBtn; /*!< 刷新按钮 */
@property (nonatomic, weak) UIButton *qrBtn; /*!< 二维码按钮 */
@property (nonatomic, strong) NSTimer *timer; /*!< 定时器 */
@property (nonatomic, assign) CGFloat brightness; /*!< 屏幕亮度 */
@property (nonatomic, strong) UIButton *fullBtn; /*!< 全屏Btn */
@property (nonatomic, weak) UIImageView *qrImgView; /*!< 全屏Btn上的二维码 */

@end

@implementation QrCodeViewController


- (UIButton *)fullBtn
{
    if (!_fullBtn) {
        _fullBtn = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_fullBtn addTarget:self action:@selector(hideBigImage) forControlEvents:UIControlEventTouchUpInside];
        [_fullBtn setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView * qrImgView = [[UIImageView alloc] init];
        qrImgView.backgroundColor = [UIColor redColor];
        [_fullBtn addSubview:qrImgView];
        self.qrImgView = qrImgView;
        
        // logo
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:@"main_icon_logo"];
        [_fullBtn addSubview:logoImageView];
        
        [qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(_fullBtn);
            make.width.equalTo(_fullBtn).offset(-148);
            make.height.equalTo(qrImgView.mas_width);
        }];
        
        // logo
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(_fullBtn);
            make.height.equalTo(@(40));
            make.width.equalTo(logoImageView.mas_height);
        }];
    }
    
    return _fullBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"岗位二维码";
    [self setupUI];
    
    [self createQrImage];
    
    [self setupAutoReflushRqCode];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor XSJColor_base];
    
    // contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 3;
    contentView.layer.masksToBounds = YES;
    [self.view addSubview:contentView];
    
    // 二维码
    UIButton *qrBtn = [[UIButton alloc] init];
    qrBtn.adjustsImageWhenHighlighted = NO;
    [qrBtn addTarget:self action:@selector(showBigImage) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:qrBtn];
    self.qrBtn = qrBtn;
    
    // 刷新按钮
    UIButton *reflushBtn = [[UIButton alloc] init];
    [reflushBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    reflushBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    reflushBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [reflushBtn addTarget:self action:@selector(reflushBtnClilck) forControlEvents:UIControlEventTouchUpInside];
    [reflushBtn setImage:[UIImage imageNamed:@"qr_jiaobiao_refresh"] forState:UIControlStateNormal];
    [reflushBtn setTitle:[NSString stringWithFormat:@"%.f分钟后自动更新", (self.expireTime.longLongValue * 0.001 / 60)] forState:UIControlStateNormal];
    [reflushBtn setTitleColor:MKCOLOR_RGB(159, 159, 159) forState:UIControlStateNormal];
    [contentView addSubview:reflushBtn];
    self.reflushBtn = reflushBtn;
    
    // 提示文字
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"下载最新版兼客，扫码报名并自动录用！";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tipLabel];
    
    
    // logo
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"main_icon_logo"];
    [contentView addSubview:logoImageView];
    
    
    // contentView
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(86));
        make.left.equalTo(@(26));
        make.right.equalTo(@(-26));
        make.height.equalTo(contentView.mas_width);
    }];
    
    // qrBtn
    [qrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(contentView);
        make.edges.equalTo(contentView).insets(UIEdgeInsetsMake(48, 48, 48, 48));
    }];
    
    // 刷新按钮
    [reflushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(contentView);
        make.width.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-16);
        make.height.equalTo(@(20));
        
    }];
    
    
    // 提示文字
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(contentView);
        make.height.equalTo(@(20));
        make.top.equalTo(contentView.mas_bottom).offset(30);
        
    }];
    
    
    // logo
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(contentView);
        make.height.equalTo(@(40));
        make.width.equalTo(logoImageView.mas_height);
    }];
    
}

/** 显示全屏二维码 */
- (void)showBigImage
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.fullBtn];
}

/** 移除全屏二维码 */
- (void)hideBigImage
{
    [self.fullBtn removeFromSuperview];
}

/** 生成二维码 */
- (void)createQrImage
{
    CIImage *ciImage = [self createQRForString:self.qrCode];
    
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:self.view.width - 148];
    [self.qrBtn setImage:qrImage forState:UIControlStateNormal];
    
    [self fullBtn];
    self.qrImgView.image = qrImage;
}


- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // 返回CIImage
    return qrFilter.outputImage;
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage* qrImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return qrImage;
}


- (void)reflushBtnClilck{
    DLog(@"二维码刷新");
    
    WEAKSELF
    [[UserData sharedInstance] entRefreshJobQrCodeWithJobId:self.jobId block:^(ResponseInfo *response) {
        
        if (!response) {
            
            [weakSelf.reflushBtn setImage:[UIImage imageNamed:@"qr_icon_no"] forState:UIControlStateNormal];
            [weakSelf.reflushBtn setTitle:@"更新失败, 请检查网络连接!" forState:UIControlStateNormal];
            [weakSelf.reflushBtn setTitleColor:MKCOLOR_RGB(255, 72, 81) forState:UIControlStateNormal];
            
            return;
        }
        
        if (response.success) {
            
            weakSelf.qrCode = response.content[@"qr_code"];
            weakSelf.expireTime = response.content[@"expire_time"];
            [weakSelf createQrImage];
            
            [weakSelf.reflushBtn setImage:[UIImage imageNamed:@"qr_icon_yes"] forState:UIControlStateNormal];
            [weakSelf.reflushBtn setTitle:@"已更新" forState:UIControlStateNormal];
            [weakSelf.reflushBtn setTitleColor:MKCOLOR_RGB(78, 118, 202) forState:UIControlStateNormal];
            weakSelf.reflushBtn.userInteractionEnabled = NO;
            
            // 重置定时器
            [self.timer invalidate];
            [self setupAutoReflushRqCode];

            // 2秒更新
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                [weakSelf.reflushBtn setImage:[UIImage imageNamed:@"qr_jiaobiao_refresh"] forState:UIControlStateNormal];
                [weakSelf.reflushBtn setTitle:[NSString stringWithFormat:@"%.f分钟后自动更新", (self.expireTime.longLongValue * 0.001 / 60)] forState:UIControlStateNormal];
                [weakSelf.reflushBtn setTitleColor:MKCOLOR_RGB(159, 159, 159) forState:UIControlStateNormal];
                weakSelf.reflushBtn.userInteractionEnabled = YES;
            });
        }
    }];
}


- (void)setupAutoReflushRqCode
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.expireTime.longLongValue * 0.001 target:self selector:@selector(reflushBtnClilck) userInfo:nil repeats:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
    [UIScreen mainScreen].brightness = self.brightness;
    
    [super viewDidDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.brightness = [UIScreen mainScreen].brightness;
    [UIScreen mainScreen].brightness = 0.9;
}

@end
