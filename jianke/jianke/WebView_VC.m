//
//  WebView_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WebView_VC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "LookupResume_VC.h"
#import "IdentityCardAuth_VC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JobDetail_VC.h"
#import "WDConst.h"
#import "ShareHelper.h"
#import "MKActionSheet.h"
#import "MoneyBag_VC.h"
#import "PersonalList_VC.h"
#import "FenQiLeView.h"
#import "UserData.h"
#import "XZVideoTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WebKit/WebKit.h>
#import "AVPlay_VC.h"

typedef NS_ENUM(NSInteger, GestureStateType) {
    GestureStateType_start = 1,
    GestureStateType_move = 2,
    GestureStateType_end = 3,
};

@interface WebView_VC ()<WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate>{

    NSURLRequest* _request; /*!< 请求连接 */
    
    NSString* _firstRelativePath;   /*!< 首页 */
    NSString* _nowRelativePath;     /*!< 当前页 */
    NSString* _nowRequestUrl;       /*!< 当前的URL 分享用 */
    NSString* _webTitle;            /*!< 标题 */
    
    NSString* _imgURL;              /*!< 图片URL */
    NSString* _shareUrl;            /*!< 分享URl */
    
    BOOL _isLongPress;              /*!< 是否是长按 */
    NSTimer *_timer;                /*!< 定时器-关闭长按状态 */
    CGPoint _prePoint;              /*!< 手势开始的point */
}


@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIButton* btnBack;
@property (nonatomic, strong) UIBarButtonItem* rightItemMShare;
@property (nonatomic, strong) ShareInfoModel *shareModel;
@property (nonatomic, strong) UIProgressView *progressView;

@end

#define kTouchJavaScriptString [NSString stringWithFormat:@"\
                                                JKAPP = new Object();\
                                                JKAPP.WebViewPaySucc = function(){\
                                                document.location=\"myweb:jump:MoneyBag\";};\
                                                window.getAppIntVersion=function(){return %d;};\
                                                window.triggerAppMethod=function(obj1, obj2){\
                                                var json = JSON.stringify({\
                                                    'flg':obj1,\
                                                    'val':obj2\
                                                    });\
                                                    window.webkit.messageHandlers.AppModel.postMessage(json);\
                                                };\
                                                window.appShare=function(share_img_url, share_title, share_url, share_content){\
                                                    var json = JSON.stringify({\
                                                        'share_img_url':share_img_url,\
                                                        'share_title':share_title,\
                                                        'share_url':share_url,\
                                                        'share_content':share_content,\
                                                    });\
                                                    window.webkit.messageHandlers.ShareAppModel.postMessage(json);\
                                                };"\
                                                ,[MKDeviceHelper getAppIntVersion]]

#define ImgJavascriptInjectString(x, y) [NSString stringWithFormat:@"\
                                    var imgaa = document.elementFromPoint(%f, %f); \
                                        imgaa.onclick = function(event){\
                                            if ( event && event.stopPropagation ) {\
                                                event.stopPropagation();\
                                            }\
                                    };"\
                                   ,x, y]

#define ImgJavascriptCancelString(x, y) [NSString stringWithFormat:@"\
                                            var imgaa = document.elementFromPoint(%f, %f); \
                                            imgaa.onclick = function(event){\
                                            };"\
                                        ,x, y]

static NSString* const kZhaiTaskMainUrl = @"zhongbao";
static NSString* const kZhaiTaskUrl = @"/task/";     /*!< 识别宅任务URL */

@implementation WebView_VC

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    
    DLog(@"self.url:%@",self.url);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    NSRange rangeZB = [self.url rangeOfString:kZhaiTaskMainUrl];
    if (rangeZB.location != NSNotFound) {
        self.uiType = WebViewUIType_ZhaiTask;
    }
    
    NSString *jScript = [NSString stringWithFormat:@"%@", kTouchJavaScriptString];
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGes.minimumPressDuration = 1.0f;
    longPressGes.delegate = self;
    [self.webView addGestureRecognizer:longPressGes];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progress = 0;
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor XSJColor_blackBase];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@2);
    }];
    
    if (self.fixednessTitle) {
        self.title = self.fixednessTitle;
    }

    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 36, 44);
    [backBtn setImage:[UIImage imageNamed:@"v3_public_img_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBackOnclick:) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 0, 36, 44);
    [self.btnBack setImage:[UIImage imageNamed:@"v3_public_close"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack];
    
    UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceLeft.width = -14;
    self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft,backItem,closeItem];
    
    if (self.uiType) {
        UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
        [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
        [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [btnShare setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        self.rightItemMShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
        self.navigationItem.rightBarButtonItem = self.rightItemMShare;
    }
  
    if (self.isFenQiLe) {
        if (![[UserData sharedInstance] getIsYetShowFenQLAlertView]) {
            [[UserData sharedInstance] setIsYetShowFenQLAlertView:YES];
            [UserData delayTask:0.5f onTimeEnd:^{
                FenQiLeView *fenQiView = [[FenQiLeView alloc] initWithFrame:SCREEN_BOUNDS];
                [fenQiView show];
            }];
        }
    }
    
    [self loadRequestUrl];
}

- (void)loadRequestUrl{
    NSURL* requestUrl;
    if (self.urlCacheType) {        //显示本地
        switch (self.urlCacheType) {
            case WebViewURLCacheType_JianKeAgreement:
                requestUrl = [[NSBundle mainBundle] URLForResource:@"JianKeAgreement" withExtension:@".rtf"];
                break;
            default:
                break;
        }
    }else{
        NSString *urlStr;
        
        BOOL isNeedToken = NO;
        NSRange rangejk = [self.url rangeOfString:@"shijianke"];
        if (rangejk.location != NSNotFound) {
            isNeedToken = YES;
        }
        if (!isNeedToken) {
            rangejk = [self.url rangeOfString:@"jianke"];
            if (rangejk.location != NSNotFound) {
                isNeedToken = YES;
            }
        }
        
        if (isNeedToken) {
            NSString *user_token;
            NSString *accountType;
            if ([[UserData sharedInstance] isLogin]) {

                    user_token = [XSJNetWork getToken];
                    if (!user_token || user_token.length == 0) {
                        user_token = @"0";
                    }
                    NSNumber *loginType = [[UserData sharedInstance] getLoginType];
                    accountType = loginType.stringValue;
            }else{
                user_token = @"0";
                accountType = @"0";
            }
            
            NSNumber *cityId = [UserData sharedInstance].city.id ? [UserData sharedInstance].city.id : @211;
            NSRange range = [self.url rangeOfString:@"?"];
            if (range.location == NSNotFound){
                urlStr = [NSString stringWithFormat:@"%@?app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
            }else{
                urlStr = [NSString stringWithFormat:@"%@&app_user_token=%@&account_type=%@&is_from_app=1&client=ios&city_id=%@", self.url, user_token, accountType, cityId];
            };
        }else{
            urlStr = self.url;
        }
        
        requestUrl = [NSURL URLWithString:urlStr];
    }
    
    _request = [NSURLRequest requestWithURL:requestUrl];
    
    if (!self.isSocialActivist) {   //如果是人脉王界面 在 viewDidAppear 里请求
        [self.webView loadRequest:_request];
    }
}

- (void)addObserver{
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    if (!self.fixednessTitle) {
        [self.webView addObserver:self
                       forKeyPath:@"title"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    }
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [WDNotificationCenter addObserver:self
                             selector:@selector(payUrlOrderCallBack:)
                                 name:AlipayResponseNotification object:nil];
}

- (void)removeObserver{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (!self.fixednessTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [WDNotificationCenter removeObserver:self name:AlipayResponseNotification object:nil];
}

- (void)addScriptMessageHandler{
    @try {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"ShareAppModel"];
    } @catch (NSException *exception) {
        [self removeScriptMessageHandler];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"ShareAppModel"];
    } @finally {
    }
    
}

- (void)removeScriptMessageHandler{
    @try {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AppModel"];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"ShareAppModel"];
    } @catch (NSException *exception) {
        ELog(@"%@",exception);
    } @finally {
    }
    
}

#pragma mark - view appear

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addObserver];
    [self addScriptMessageHandler];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_request && self.isSocialActivist) {
        [self.webView loadRequest:_request];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self removeScriptMessageHandler];
    [self removeObserver];
}


#pragma mark - *****  按钮事件 ******
/** 分享 按钮 */
- (void)btnShareOnclick:(UIButton*)sender{
    if (self.shareModel) {
        [ShareHelper platFormShareWithVc:self info:self.shareModel block:^(id obj) {
        }];
    }else{
        if (self.uiType == WebViewUIType_ZhaiTask && _nowRequestUrl.length > 0) {    //宅任务
            ShareInfoModel* model = [[ShareInfoModel alloc] init];
            model.share_title = @"足不出户，手机就能秒赚一顿饭钱，数量有限，手慢无，快来抢哦";
            model.share_content = [NSString stringWithFormat:@"我正在看【%@】，分享给你，一起看吧!",_webTitle];
            NSRange range = [self.url rangeOfString:@"?"];
            if (range.location == NSNotFound) {
                model.share_url = [self.url stringByAppendingString:@"?is_share=1"];
            }else{
                model.share_url = [self.url stringByAppendingString:@"&is_share=1"];
            }
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        }else{  //不是宅任务
            if (!_webTitle.length && !self.fixednessTitle.length) {
                _webTitle = @" ";
            }
            ShareInfoModel* model = [[ShareInfoModel alloc] init];
            model.share_title = self.fixednessTitle ? self.fixednessTitle : _webTitle;
            NSRange range = [self.url rangeOfString:@"?"];
            if (range.location == NSNotFound) {
                model.share_url = [self.url stringByAppendingString:@"?is_share=1"];
            }else{
                model.share_url = [self.url stringByAppendingString:@"&is_share=1"];
            }
            
            model.share_content = [NSString stringWithFormat:@"我正在看【%@】，分享给你，一起看吧!",_webTitle];
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        }
    }
    
}

#pragma mark - ***** UIWebView delegate ******

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (_isLongPress) {
        _isLongPress = NO;
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    _nowRequestUrl = [urlStr copy];
    ELog(@"requestURL:%@",urlStr);
    
    NSURL *url = navigationAction.request.URL;
    
    if ([url.scheme isEqualToString:@"tel"])
    {
        [[MKOpenUrlHelper sharedInstance] callWithPhoneUrl:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([url.absoluteString containsString:@"itunes.apple.com"])
    {
        [[MKOpenUrlHelper sharedInstance] openItunesWithUrl:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (!self.uiType && self.rightItemMShare) {
        self.rightItemMShare = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    NSString* relativePathStr = navigationAction.request.mainDocumentURL.relativePath;
    if (!_firstRelativePath) {
        _firstRelativePath = [relativePathStr copy];
    }
    _nowRelativePath = [relativePathStr copy];
    
    //alipay支付
    NSString *orderInfo = [[AlipaySDK defaultService] fetchOrderInfoFromH5PayUrl:urlStr];
    if (orderInfo.length > 0) {
        NSString* fromScheme = @"jiankeapp";
        WEAKSELF
        [[AlipaySDK defaultService] payUrlOrder:orderInfo fromScheme:fromScheme callback:^(NSDictionary *resultDic) {
            [weakSelf handelPayOrderResult:resultDic];
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    //人脉王 认证
    if ([relativePathStr isEqualToString:@"/IDCardAuth"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //岗位详情 跳转 原生界面
    if (relativePathStr.length > 5) {
        NSArray* paramAry = [relativePathStr componentsSeparatedByString:@"/"];
        
        if (paramAry.count >= 3) {
            NSString* funName = [[NSString alloc] initWithString:paramAry[1]];
            if ([funName isEqualToString:@"job"]) {
                NSMutableString* funParam = [[NSMutableString alloc] initWithString:paramAry[2]];
                NSRange subStr;
                subStr = [funParam rangeOfString:@".html"];
                if (subStr.location != NSNotFound) {
                    [funParam deleteCharactersInRange:subStr];
                    ELog(@"funParam:%@",funParam);
                    [self pushToJobDetailWithJobUuid:funParam];
                    decisionHandler(WKNavigationActionPolicyCancel);
                    return;
                }else{
                    ELog(@"=====参数错误");
                }
            }
        }
    }
    if ([urlStr hasPrefix:@"jiankeapp://"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    ELog(@"=====error:%@",error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //    [webView evaluateJavaScript:kTouchJavaScriptString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    //
    //    }];
    //    [self makeJsMothod];
    //    [webView evaluateJavaScript:@"var obj = window.getAppIntVersion();window.location.href= obj;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    //        if (error) {
    //            ELog(@"error:%@", [error localizedDescription]);
    //        }
    //    }];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    ELog(@"*****didReceiveServerRedirectForProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    ELog(@"*****didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"AppModel"]) {
        if (!message.body) {
            return;
        }
        NSDictionary *messagDic = [self convertJsonFromStr:message.body];
        
        NSString *flag = [messagDic objectForKey:@"flg"];
        NSDictionary *jsVal = [self convertJsonFromStr:[messagDic objectForKey:@"val"]];
        NSDictionary *dic = [jsVal objectForKey:@"param"];
        //        NSDictionary *dic = [resultDic objectForKey:@"param"];
        switch (flag.integerValue) {
            case JSFlagType_viewPersonalService:{ //查看个人服务商列表（兼客兼职）
                PersonalList_VC *viewCtrl = [[PersonalList_VC alloc] init];
                viewCtrl.service_type = [dic objectForKey:@"service_type"];
                viewCtrl.cityId = [UserData sharedInstance].city.id;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
                break;
            case JSFlagType_uploadVideo:{
                NSString *method = [dic objectForKey:@"callback_met"];
                [[XZVideoTool sharedInstance] uploadVideoOnVC:self compeleteBlock:^(NSDictionary *callBackDic) {    //成功回调
                    NSString *imgUrl = callBackDic[XZVideoToolImageUrlKey];
                    NSString *videoUrl = callBackDic[XZVideoToolVideoUrlKey];
                    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%@','%@');", method, imgUrl, videoUrl] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                        
                    }];
                } failBlock:^(id result) {  //失败回调
                    [UIHelper toast:@"失败"];
                }];
            }
                break;
            case JSFlagType_getShareContent:{
                if (!self.rightItemMShare) {
                    UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
                    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
                    [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
                    self.rightItemMShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
                    self.navigationItem.rightBarButtonItem = self.rightItemMShare;
                }
                self.shareModel = [ShareInfoModel objectWithKeyValues:dic];
            }
                break;
            case JSFlagType_shareAction:{
                ShareInfoModel *shareModel = [ShareInfoModel objectWithKeyValues:dic];
                [ShareHelper platFormShareWithVc:self info:shareModel block:^(id obj) {
                }];
            }
                break;
            case JSFlagType_acceptMission:{
                MKBlockExec(self.block, nil);
            }
                break;
            case JSFlagType_jkVertifySuccess:{
                [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
            }
                break;
            case JSFlagType_playVideo:{
                [self callJSCallBackWithplayVideo:dic];
            }
                break;
            default:
                break;
        }
        ELog(@"*********JS注入被调用");
    }else if ([message.name isEqualToString:@"ShareAppModel"]){
        if (!message.body) {
            return;
        }
        
        NSDictionary *resultDic = [self convertJsonFromStr:message.body];
        ShareInfoModel* model = [[ShareInfoModel alloc] init];
        
        model.share_img_url = [resultDic objectForKey:@"share_img_url"];
        model.share_title = [resultDic objectForKey:@"share_title"];
        model.share_url = [resultDic objectForKey:@"share_url"];
        model.share_content = [resultDic objectForKey:@"share_content"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
            }];
        });
    }
    
}

#pragma mark - ****** 客户端与web交互 ******

//视频播放
- (void)callJSCallBackWithplayVideo:(NSDictionary *)dic{
    NSString *videoUrlStr = [dic objectForKey:@"video_url"];
    if (!videoUrlStr.length) {
        [UIHelper toast:@"视频无法播放"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlay_VC *avPlayerVC = [[AVPlay_VC alloc] init];
        avPlayerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoUrlStr]];
        
        [self presentViewController:avPlayerVC animated:YES completion:^{
            
        }];
    });
}

- (NSDictionary *)convertJsonFromStr:(NSString *)jsonStr{
    if (!jsonStr.length) {
        return nil;
    }
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        ELog(@"解析错误:%@", [error localizedDescription]);
    }
    return dic;
}

///** 长按触发 */
//- (void)handleLongTouch {
//    if (_imgURL && _gesState == GestureStateType_start) {
//        [self.webView stopLoading];
//        NSString *imgUrl = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
//        DLog(@"_imgURL:%@  \n  image url:%@", _imgURL, imgUrl);        
//        [MKActionSheet sheetWithTitle:@"保存图片" buttonTitleArray:@[@"保存图片"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
//            if (buttonIndex == 0) {
//                [[MKCommonHelper sharedInstance] saveImageToPhotoLibWithImageUrl:imgUrl];
//            }
//        }];
//    }
//}

#pragma mark - ******支付宝支付相关*******
- (void)loadWithUrlStr:(NSString *)urlStr{
    if (!urlStr.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:30];
        [self.webView loadRequest:webRequest];
    });
}

//app支付回调通知
- (void)payUrlOrderCallBack:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *resultDic = notification.userInfo;
        [self handelPayOrderResult:resultDic];
    });
}

//支付结果处理
- (void)handelPayOrderResult:(NSDictionary *)resultDic{
    if ([resultDic[@"isProcessUrlPay"] boolValue] && [resultDic[@"resultCode"] isEqualToString:@"9000"]) {
        // returnUrl 代表 第三方App需要跳转的成功页URL
        //        [UIHelper toast:@"支付成功"];
        //        [self.navigationController popViewControllerAnimated:NO];
        //        MKBlockExec(self.block, nil);
        NSString* urlStr = resultDic[@"returnUrl"];
        [self loadWithUrlStr:urlStr];
        
    }else{
//        [UIHelper toast:@"支付失败"];
        //        [self.navigationController popViewControllerAnimated:YES];
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        ELog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        _webTitle = self.webView.title;
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        ELog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }else{
        self.progressView.alpha = 1;
    }
}

#pragma mark - ***** 长按保存图片业务 ******

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)ges{

    if (ges.state == UIGestureRecognizerStateBegan) {
        
        UIView *view = [ges view];
        if (![view isKindOfClass:[WKWebView class]]) {
            return;
        }
        
        CGPoint point = [ges locationInView:view];
        _prePoint = point;
        NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
        NSString *imgJsStr = ImgJavascriptInjectString(point.x, point.y);
        [self.webView evaluateJavaScript:imgJsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            ELog(@"%@", [error localizedDescription]);
        }];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(NSString* _Nullable imgUrlStr, NSError * _Nullable error) {
            if (imgUrlStr.length) {
                _isLongPress = YES;
                [self presentActionSheetWithImgUrl:imgUrlStr];
            }
        }];
        
    }
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        UIView *view = [ges view];
        if (![view isKindOfClass:[WKWebView class]]) {
            return;
        }
        if (_isLongPress) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(resetLongPressStatus) userInfo:nil repeats:NO];
        }
        
    }
}

- (void)presentActionSheetWithImgUrl:(NSString *)imgUrlStr{
    [[MKCommonHelper sharedInstance] detectQRCodeWithImageUrl:imgUrlStr resultBlock:^(NSString *urlStr) {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:@"保存图片"];
        if (urlStr) {
            [items addObject:@"识别二维码"];
        }
        [MKActionSheet sheetWithTitle:nil buttonTitleArray:[items copy] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:{
                    [[MKCommonHelper sharedInstance] saveImageToPhotoLibWithImageUrl:imgUrlStr];
                }
                    break;
                case 1:{
                    if (urlStr.length && [urlStr hasPrefix:@"http"]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }else{
                        [UIHelper toast:@"未发现二维码"];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }];
}

- (void)resetLongPressStatus{
    _isLongPress = NO;
    [_timer invalidate];
    _timer = nil;
    
    [self.webView evaluateJavaScript:ImgJavascriptCancelString(_prePoint.x, _prePoint.y) completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

#pragma mark - ***** 跳转原生岗位详情业务 *****
- (void)pushToJobDetailWithJobUuid:(NSString*)jobUuid{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobUuid = jobUuid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark - ***** 返回 关闭 按钮 ******
- (void)btnBackOnclick:(UIButton*)sender{
    if (![self.webView canGoBack]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
}


#pragma mark - ***** dealloc ******
- (void)dealloc{
    DLog(@"*** dealloc webView");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
