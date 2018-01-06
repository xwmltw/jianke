//
//  RequestInfo.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "RequestInfo.h"
#import "NetHelper.h"
#import "WDConst.h"
#import "WDRequestMgr.h"
#import "GZIP.h"
#import "UIHelper.h"
#import "NSData+CommonCrypto.h"
#import "TLV.h"
#import "AFNetworking.h"
#import "XSJSessionMgr.h"
#import "XSJNetWork.h"


@implementation RequestInfo

- (instancetype)initWithService:(NSString*)service andContent:(NSString*)content{
    self = [super init];
    if (self) {
        self.service = service;
        self.content = content;
        self.isContentContainBracket = NO;
        self.isShowErrorMsg = YES;
        self.isShowLoading = NO;
        self.isShowErrorMsgAlertView = NO;
        self.isShowNetworkErrorMsg = NO;
    }
    return self;
}

- (void)sendRequestToImServer:(OnResponseBlock)block{
    [self sendRequestToServer:URL_IMServer withResponseBlock:block];
}

- (void)sendRequestWithResponseBlock:(OnResponseBlock)block{
    AFNetworkReachabilityStatus networkStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (self.isShowNetworkErrorMsg && (networkStatus == AFNetworkReachabilityStatusUnknown || networkStatus == AFNetworkReachabilityStatusNotReachable)){
        dispatch_async(dispatch_get_main_queue(), ^{
            ELog(@"*****request:%@",self.service);
            [UIHelper showMsg:@"网络异常，请检查您的网络是否打开"];
            if (block) {
                block(nil);
            }
        });
    }else{
        if (self.isToStackServer) {
            [self sendRequestToServer:URL_TscServer withResponseBlock:block];
        }else{
            [self sendRequestToServer:URL_Server withResponseBlock:block];
        }
    }
}

- (void)sendRequestToServer:(NSString*)strServerUrl withResponseBlock:(OnResponseBlock)block{
    self.url = strServerUrl;
    self.resBlock = block;
    
//    [self fillData];
    [[WDRequestMgr sharedInstance] addRequest:self];
}

- (void)fillData{
    NSString* dataStr;
    if (self.isToStackServer) {
        dataStr = self.stackParam;
    }else{
        self.type = 3;
        dataStr = [self getRequestParam];
    }
    
    //  ELog(@"type ============ %d", self.type);
    //  ELog(@"url ============= %@", self.url);
    //  ELog(@"resBlock ======== %@", self.resBlock);
    //  ELog(@"service ========= %@", self.service);
    //  ELog(@"seq ============= %ld", self.seq);
    //  ELog(@"isToStackServer = %d", self.isToStackServer);
    //  ELog(@"forceSeq ======== %d", self.forceSeq);
    //  ELog(@"dataStr ========= %@", dataStr);
    
#if G_ENCTYPE == 0
    NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#elif G_ENCTYPE == 1
    NSData* data = [[dataStr dataUsingEncoding:NSUTF8StringEncoding] gzippedData];
#elif G_ENCTYPE == 2
    NSData* data = [[[dataStr dataUsingEncoding:NSUTF8StringEncoding] gzippedData] encryptTextUsingKey:[XSJNetWork getAESKey]];
#endif
    
    self.data = data;
}

- (NSString*)getRequestParam{
    
    NSString *token = [XSJNetWork getToken];
    NSString *sessionId = [[XSJSessionMgr sharedInstance] getLatestSessionId];
    NSString *jsonString;

    NSString *platformStr = [NSString stringWithFormat:@"\"access_channel_code\":\"%@\",\"client_type\":\"%@\",\"app_version_code\":\"%d\",\"package_name\":\"%@\"", JKAPP_PLATFORM, [XSJUserInfoData getClientType],[MKDeviceHelper getAppIntVersion], [MKDeviceHelper getBundleIdentifier]];
    
    NSMutableString *contenStr;
    if (self.content && ![self.content isEqualToString:@""]) {
        contenStr = [NSMutableString stringWithFormat:@"%@",self.content];
        if (self.isContentContainBracket) {
            [contenStr insertString:[NSString stringWithFormat:@"%@,",platformStr] atIndex:1];
        }else{
            [contenStr insertString:[NSString stringWithFormat:@"%@,",platformStr] atIndex:0];
        }
    }else{
        contenStr = [NSMutableString stringWithString:@""];
        if (self.isContentContainBracket) {
            [contenStr insertString:platformStr atIndex:1];
        }else{
            [contenStr insertString:platformStr atIndex:0];
        }
    }

    if (self.isContentContainBracket) {
        jsonString = [NSString stringWithFormat:@"{\"service\":\"%@\",\"sessionId\":\"%@\",\"user_token\":\"%@\",\"content\":%@}",self.service, sessionId ? sessionId : @"", token?token:@"" ,contenStr];
    }else{
        jsonString = [NSString stringWithFormat:@"{\"service\":\"%@\",\"sessionId\":\"%@\",\"user_token\":\"%@\",\"content\":{%@}}", self.service, sessionId ? sessionId : @"", token?token:@"" ,contenStr];
    }
    
    ELog(@"*****向服务端发送：\n%@", jsonString);
    return jsonString;
}


#pragma mark - ***** send multimedia ******
- (void)sendImageWithData:(NSData*)tlvData andBlock:(OnResponseBlock)block {
    
    self.type = 4;
    self.url = URL_PicServer;
    self.resBlock = block;
    self.data = tlvData;
    
    [[WDRequestMgr sharedInstance] addRequest:self];
}

- (void)uploadImage:(UIImage*)image andBlock:(OnResponseBlock)block{
    [self uploadImage:image isShowLoding:YES andBlock:block];
}

- (void)uploadImage:(UIImage*)image isShowLoding:(BOOL)isShowLoading andBlock:(OnResponseBlock)block{
    NSData* dataObj = UIImageJPEGRepresentation(image, 0);
    self.isShowLoading = isShowLoading;
    self.loadingMessage = @"正在上传图片";
    [self uploadData:dataObj andBlock:block suffix:@".jpg"];
}

- (void)uploadVideo:(NSData *)video isShowLoding:(BOOL)isShowLoading andBlock:(OnResponseBlock)block{
    self.isShowLoading = isShowLoading;
    self.loadingMessage = @"正在上传视频";
    [self uploadData:video andBlock:block suffix:@".mp4"];
}

- (void)uploadVoice:(NSData *)data andBlock:(OnResponseBlock)block{
    [self uploadData:data andBlock:block suffix:@".amr"];
}

- (void)uploadData:(NSData *)upLoadData andBlock:(OnResponseBlock)block suffix:(NSString*)suffix{
    NSMutableData* data = [[NSMutableData alloc] init];
    [self addCString:suffix.UTF8String toData:data type:0x11];
    [self addCString:"platform_idc_FileUploadService" toData:data type:0x01];
    [self addCString:"shijianke" toData:data type:0x13];
    
    NSData* dataObj = upLoadData;
    int type = 0x10;
    unsigned long length = dataObj.length;
    unsigned long nllength = htonl(length);
    [data appendBytes:&type length:1];
    [data appendBytes:&nllength length:4];
    [data appendData:dataObj];
    
#if G_ENCTYPE == 2
    NSData* data_final = [[data gzippedData] encryptTextUsingKey:[XSJNetWork getAESKey]];
#else
    NSData* data_final = data;
#endif

    [self sendImageWithData:data_final andBlock:^(NSData* response) {
        if (response) {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            
            long totalLength = response.length;
            long curLength = 0;
            NSRange range = NSMakeRange(0, 1);
            while (totalLength > curLength) {
                long type = 0;
                [response getBytes:&type range:range];
                
                range.location += range.length;
                range.length = 4;
                long length = 0;
                [response getBytes:&length range:range];
                
                length = ntohl(length);
                range.location += range.length;
                range.length = length;
                
                NSData* valueData = [response subdataWithRange:range];
                
                range.location += range.length;
                range.length = 1;
                
                TLV* tlv = [[TLV alloc] init];
                tlv.type = type;
                tlv.length = length;
                tlv.value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
                [array addObject:tlv];
                
                curLength += length + 5;
                
                ELog(@"*****tag：%ld,value：%@,server：%@", (long)tlv.type, tlv.value, response);
                
                // 目前只处理一个tlv
                if (block) {
                    block(tlv.value);
                    break;
                }
            }
        }
    }];
}

- (void)addCString:(const char*)cstring toData:(NSMutableData*)data type:(int)type {
    unsigned long length = strlen(cstring);
    unsigned long nllength = htonl(length);
    [data appendBytes:&type length:1];
    [data appendBytes:&nllength length:4];
    [data appendBytes:cstring length:length];
}



+ (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName andBlock:(OnResponseBlock)block{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString* fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
//        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        if (block) {
            block(fileName);
        }
        return;
    }
    
    //创建附件存储目录
    if (![fileManager fileExistsAtPath:aSavePath]) {
        [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //下载附件
    NSURL* url = [[NSURL alloc] initWithString:aUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithURL:url];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    
    //下载进度控制
    /*
     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
     NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
     }];
     */
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(fileName);
        }
    //  NSData *audioData = [NSData dataWithContentsOfFile:fileName];
    //设置下载数据到res字典对象中并用代理返回下载数据NSData
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [fileManager removeItemAtPath:fileName error:nil];
        //下载失败
        if (block) {
            block(nil);
        }
    }];
    
    [operation start];
}


@end
