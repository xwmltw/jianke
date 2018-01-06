//
//  QRcodeScan_VC.m
//  jianke
//
//  Created by xiaomk on 15/11/5.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "QRcodeScan_VC.h"
#import "WDConst.h"
#import "UserData.h"
#import "JobDetail_VC.h"
#import "WebView_VC.h"

@interface QRcodeScan_VC ()<AVCaptureMetadataOutputObjectsDelegate>{
    BOOL _lightIsOpen;
    CGFloat _boxWidth;
    dispatch_queue_t _sessionQueue;
}

// 会话
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice* device;
//@property (nonatomic, strong) AVCaptureDeviceInput* input;
//@property (nonatomic, strong) AVCaptureMetadataOutput* output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
// 定时器
@property (nonatomic, strong) CADisplayLink *link;
// 扫描线
@property (nonatomic, strong) CALayer *scanLayer;
// 扫描框
@property (nonatomic, weak) UIView *boxView;
/// 保存二维码结果
@property (nonatomic, copy) NSString *resultStr;

//开光闪关灯按钮
@property (nonatomic, strong) UIButton* lightBtn;
@end


@implementation QRcodeScan_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self starRuning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self stopRunning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _boxWidth = 240;
    _lightIsOpen = NO;
    [self startReading];
}


- (void)startReading{
    
    //创建会话
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
    self.session = session;
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    _sessionQueue = dispatch_queue_create( "sessionqueue", NULL );

    dispatch_async(_sessionQueue, ^{
        [self.session beginConfiguration];
        
        NSError* error;
        // 1.获取输入设备
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.device = device;
        //初始化出入流 初始化输出流
        AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (!input) {
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不可用" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:aler];
            [aler show];
            ELog(@"===%@",[error localizedDescription]);
            return;
        }
        AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 添加 输入流 输出流
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
        
        if ([_session canAddOutput:output]) {
            [_session addOutput:output];
        }
        
        // 设置元数据类型 AVMetadataObjectTypeQRCode
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        
        //设置扫描范围
        CGSize size = self.view.bounds.size;
        CGRect cropRect = CGRectMake((SCREEN_WIDTH-_boxWidth)/2, 124, _boxWidth, _boxWidth);
        output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                           cropRect.origin.x/size.width,
                                           cropRect.size.height/size.height,
                                           cropRect.size.width/size.width);
        
        [self.session commitConfiguration];
    });
    
    // 创建预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.view.layer.bounds];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self initUI];
    
    //点击屏幕对焦对焦
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    if (singleTapGestureRecognizer) {
        [self.view addGestureRecognizer:singleTapGestureRecognizer];
    }
}

- (void)starRuning{
    dispatch_async(_sessionQueue, ^{
        [self.session startRunning];
        [self.link setPaused:NO];
    });
    self.scanLayer.hidden = NO;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updataFrame:)];
    self.link.frameInterval = 1;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.link setPaused:YES];
}

- (void)stopRunning{
    [self.session stopRunning];
    self.scanLayer.hidden = YES;
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}

- (void)initUI{
    
    //    output.rectOfInterest = CGRectMake(0.2, 0.18, 0.6, 0.5);
    
    // 10.设置扫描框
    //    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0.2 * SCREEN_WIDTH, 0.18 * SCREEN_HEIGHT, 0.6 * SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT)];
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-_boxWidth)/2, 124, _boxWidth, _boxWidth)];
    self.boxView = boxView;
    
    //    boxView.layer.borderColor = [UIColor grayColor].CGColor;
    //    boxView.layer.borderWidth = 3;
    [self.view addSubview:boxView];
    
    // 设置扫描线
    CALayer *scanLayer = [[CALayer alloc] init];
    self.scanLayer = scanLayer;
    scanLayer.frame = CGRectMake(0, 0, self.boxView.bounds.size.width, 1);
    scanLayer.backgroundColor = [UIColor XSJColor_base].CGColor;
    [self.boxView.layer addSublayer:scanLayer];
    
    //    设置灰色遮罩
    UIView* bgView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 124)];
    bgView_1.backgroundColor = [UIColor XSJColor_shadeBg];
    [self.view addSubview:bgView_1];
    
    UIView* bgView_2 = [[UIView alloc] initWithFrame:CGRectMake(0, _boxWidth+124, SCREEN_WIDTH, SCREEN_HEIGHT-_boxWidth-124)];
    bgView_2.backgroundColor = [UIColor XSJColor_shadeBg];
    [self.view addSubview:bgView_2];
    
    UIView* bgView_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 124, (SCREEN_WIDTH-_boxWidth)/2, _boxWidth)];
    bgView_3.backgroundColor = [UIColor XSJColor_shadeBg];
    [self.view addSubview:bgView_3];
    
    UIView* bgView_4 = [[UIView alloc] initWithFrame:CGRectMake(_boxWidth+(SCREEN_WIDTH-_boxWidth)/2, 124, (SCREEN_WIDTH-_boxWidth)/2, _boxWidth)];
    bgView_4.backgroundColor = [UIColor XSJColor_shadeBg];
    [self.view addSubview:bgView_4];
    
    
    UIImageView* imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_jiaobiao_1"]];
    UIImageView* imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_jiaobiao_2"]];
    UIImageView* imgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_jiaobiao_3"]];
    UIImageView* imgView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_jiaobiao_4"]];
    [self.boxView addSubview:imgView1];
    [self.boxView addSubview:imgView2];
    [self.boxView addSubview:imgView3];
    [self.boxView addSubview:imgView4];
    
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView.mas_left);
        make.top.equalTo(self.boxView.mas_top);
    }];
    
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxView.mas_top);
        make.right.equalTo(self.boxView.mas_right);
    }];

    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.boxView.mas_bottom);
        make.left.equalTo(self.boxView.mas_left);
    }];
    
    [imgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.boxView.mas_bottom);
        make.right.equalTo(self.boxView.mas_right);
    }];
    
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 64, 44)];
    [backBtn setImage:[UIImage imageNamed:@"v3_public_img_back"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88, 20, 80, 44)];
    [self.lightBtn setTitle:@"打开照明" forState:UIControlStateNormal];
    [self.lightBtn addTarget:self action:@selector(btnOnSwitchLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lightBtn];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 124+_boxWidth+16, SCREEN_WIDTH, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"将扫描框对准二维码，即可自动识别";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor whiteColor];
    [self.view addSubview:lab];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        // 移除CADisplayLink对象
        [self stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.resultStr = metadataObj.stringValue;
            ELog(@"===扫描--%@",self.resultStr);
            [self okToBack];
            return;
        } else if ([metadataObj.type isEqualToString:AVMetadataObjectTypeEAN13Code] || [metadataObj.type isEqualToString:AVMetadataObjectTypeEAN8Code] || [metadataObj.type isEqualToString:AVMetadataObjectTypeCode128Code]){
            [self handleBarCode:metadataObj.stringValue];
        }
        [NSThread sleepForTimeInterval:0.5];
    }
}

//点击屏幕对焦
- (void)focusGesture:(id)sender{
    CGPoint point = CGPointMake(SCREEN_WIDTH, 124+_boxWidth/2);
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    CGPoint pointOfInterst = CGPointZero;
    pointOfInterst = CGPointMake(point.y / SCREEN_HEIGHT, 1.f - (point.x / SCREEN_WIDTH));
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError* error;
        if ([device lockForConfiguration:&error]) {
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterst];
            }
            
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [device setExposurePointOfInterest:pointOfInterst];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)updataFrame:(CADisplayLink *)sender{
    CGRect frame = self.scanLayer.frame;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (self.scanLayer.frame.origin.y >= self.boxView.layer.frame.size.height) {
        frame.origin.y = 0;

    }else{
        frame.origin.y +=1;
    }
    self.scanLayer.frame = frame;
    [CATransaction commit];
}

// 扫描结果处理(条形码)
- (void)handleBarCode:(NSString *)result{
    if (result) {
        [MKAlertView alertWithTitle:@"条形码扫描" message:result cancelButtonTitle:@"确定" confirmButtonTitle:nil completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self starRuning];
        }];
    }
}

// 扫描成功返回(二维码)
- (void)okToBack{
//    http://download.jianke.cc/?qr_code=xxxxx

    NSString* res = [self.resultStr substringToIndex:4];
    if ([res isEqualToString:@"http"]) {
        NSRange subRange = [self.resultStr rangeOfString:@"qr_code"];
        if (subRange.location == NSNotFound) {
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = self.resultStr;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self stuScanJobQrcode];
        }
    }else{
        // 获取岗位Id
        [self stuScanJobQrcode];
    }
}

- (void)stuScanJobQrcode{
    WEAKSELF
    [[UserData sharedInstance] stuScanJobQrCodeWith:self.resultStr block:^(ResponseInfo *response) {
        
        if (response.success) {
            _lightIsOpen = NO;
            [weakSelf systemLightSwitch:_lightIsOpen];
            
            NSString *jobId = [NSString stringWithFormat:@"%@", response.content[@"job_id"]];
            // 跳转到岗位详情
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.isFromQrScan = YES;
            vc.jobId = jobId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } else {
            [UIHelper showConfirmMsg:response.errMsg title:@"提示" cancelButton:@"知道了" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                [weakSelf starRuning];
            }];
        }
    }];
}

- (void)btnOnSwitchLight:(UIButton*)sender{
    _lightIsOpen = !_lightIsOpen;
    [self systemLightSwitch:_lightIsOpen];
}

//开关闪光灯
- (void)systemLightSwitch:(BOOL)isOpen{
//    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([self.device hasTorch]) {
        [self.device lockForConfiguration:nil];
        if (isOpen) {
            [self.lightBtn setTitle:@"关闭照明" forState:UIControlStateNormal];
            [self.device setTorchMode:AVCaptureTorchModeOn];
        }else{
            [self.lightBtn setTitle:@"打开照明" forState:UIControlStateNormal];
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];
    }
}

- (void)goBack{
    _lightIsOpen = NO;
    [self systemLightSwitch:_lightIsOpen];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc{
    ELog(@"dealloc");
}

@end
