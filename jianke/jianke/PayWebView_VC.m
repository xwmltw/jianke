//
//  PayWebView_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PayWebView_VC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WDConst.h"
#import "MoneyBag_VC.h"

@interface PayWebView_VC ()<UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSURLRequest* _request; /*!< 请求连接 */
    
    NSURLConnection* _connection;
    BOOL _authenticated;
    
    NSMutableArray *_requestArray;

}

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* btnBack;
@end

@implementation PayWebView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestArray = [[NSMutableArray alloc] init];
    
    if (self.fixednessTitle) {
        self.title = self.fixednessTitle;
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadRequestUrl];
}

- (void)loadRequestUrl{

    NSString *urlStr;
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
    
    NSRange range = [self.url rangeOfString:@"?"];
    if (range.location == NSNotFound){
        urlStr = [NSString stringWithFormat:@"%@?app_user_token=%@&account_type=%@&is_from_app=1&client=ios",self.url,user_token,accountType];
    }else{
        urlStr = [NSString stringWithFormat:@"%@&app_user_token=%@&account_type=%@&is_from_app=1&client=ios",self.url,user_token,accountType];
    };
    //        urlStr = @"http://192.168.2.9/index.html";
    //        urlStr = @"http://119.29.248.95";
    ELog(@"self.url:%@",self.url);
    ELog(@"_request:%@",urlStr);

    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:_request];

}



#pragma mark - ***** UIWebView delegate ******
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    ELog(@"Did start loading: %@ auth:%d", [[request URL]absoluteString],_authenticated);
    
    
    NSString* scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
    //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        NSString *curRequest = request.URL.host;
        
        _authenticated = NO;

        for (NSString *req in _requestArray) {
            if ([req isEqualToString:curRequest]) {
                _authenticated = YES;
            }
        }

        if (!_authenticated) {
            [_requestArray addObject:curRequest];
            _request = request;
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [_connection start];
            [_webView stopLoading];
            return NO;
        }
    }
    
    NSString* relativePathStr = request.mainDocumentURL.relativePath;
    
    /** 支付完成回调 URL */
    if ([relativePathStr isEqualToString:@"/iosDestroyPageUrl"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isFromPostJob) {
                MKBlockExec(self.block, @(1));
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                MoneyBag_VC* vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
                vc.isFromWebView = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
   
        });
        return NO;
    }
    
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr hasPrefix:@"jiankeapp://"]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    ELog(@"=====webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    ELog(@"***********error:%@, errorcode=%ld, errormessage:%@",error.domain,(long)error.code,error.description);
}

//#pragma mark - ***** NSURLConnectionDataDelegate ******
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    if ([challenge previousFailureCount] == 0) {
//        _authenticated = YES;
//    }
//    //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
//    NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//    [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
//}
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
//    ELog(@"request:%@",request);
//    return request;
//}


#pragma mark - ***** NSURLConnectionDelegate ******
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    ELog(@"WebController received response via NSURLConnection");
    
    _authenticated = YES;
    //webview 重新加载请求。
    [_webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [connection cancel];
}

//===========
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;{
    ELog(@"WebController Got auth challange via NSURLConnection");
    if ([challenge previousFailureCount] == 0){
        _authenticated = YES;
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender]cancelAuthenticationChallenge:challenge];
    }
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


#pragma mark - ***** 返回 关闭 按钮 ******
- (void)btnBackOnclick:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
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
