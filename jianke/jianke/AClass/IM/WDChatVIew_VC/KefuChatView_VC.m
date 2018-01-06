//
//  KefuChatView_VC.m
//  jianke
//
//  Created by xiaomk on 15/10/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "KefuChatView_VC.h"
#import "ImConst.h"
#import "WDConst.h"
#import "XHAudioPlayerHelper.h"
#import "EmojiStore.h"
#import "XHEmotion.h"
#import "ImUserInfo.h"
#import "ImDataManager.h"
#import "XHPopMenu.h"
#import "ImTextWrapper.h"
#import "JobModel.h"
#import "EPModel.h"
#import "WebView_VC.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHDisplayTextViewController.h"
#import "UserData.h"
#import "ConversationModel.h"
#import "DataBaseTool.h"
#import "ImDataManager.h"

@interface KefuChatView_VC()<XHAudioPlayerHelperDelegate>{
    long f_oldestMsgId;

}

@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, strong) NSArray* emotionManagers;
@property (nonatomic, strong) RCConversation* conversation;

@property (nonatomic, strong) ImUserInfo* selfInfo;
@property (nonatomic, strong) ImUserInfo* targetInfo;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;


@end

@implementation KefuChatView_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.targetInfo) {
        self.title = KEFU_NAME;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    __unused BOOL bSuccess = [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:self.conversation.conversationType targetId:self.conversation.targetId];
    ELog(@"======清除未读消息:%@",bSuccess ? @"成功" : @"失败");
}

- (void)dealloc{
    self.emotionManagers = nil;
    [WDNotificationCenter removeObserver:self];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.selfInfo = [ImDataManager sharedInstance].selfInfo;

    
    if (([MKDeviceHelper getSysVersion] > 7.0)) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }

    self.loginType = [[UserData sharedInstance] getLoginType].integerValue;
    
    f_oldestMsgId = 0;
    
    ImUserInfo* info = [[ImUserInfo alloc] init];
    info.uuid = KeFuMMId;
//    info.kefuImg = @"msg_type_2_1";
    info.kefuImg = KEFU_IMG;
    info.accountName = KEFU_NAME;
//    info.nickname = KEFU_NAME;
    
    self.targetInfo = info;
    
    [self setUpChatUI];
}

- (void)setUpChatUI{
    self.conversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_CUSTOMERSERVICE targetId:self.targetInfo.uuid];
    if (self.conversation == nil) {
        self.conversation = [[RCConversation alloc] init];
        self.conversation.targetId = self.targetInfo.uuid;
        self.conversation.conversationType = ConversationType_CUSTOMERSERVICE;
    }
    
    self.title = [self.targetInfo getShowName];
    
    
    NSMutableArray* shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"chat_camera", @"chat_photo"];
    NSArray *plugTitle = @[@"拍照", @"图片"];
    
    for (int i = 0; i < plugIcons.count; i++) {
        XHShareMenuItem* shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcons[i]] title:plugTitle[i]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray* emotionManagers = [NSMutableArray array];
    XHEmotionManager* emotionManager = [[XHEmotionManager alloc] init];
    emotionManager.emotionName = [NSString stringWithFormat:@"经典"];
    
    NSMutableArray* emotions = [NSMutableArray array];
    NSArray* emotionArray = [[EmojiStore sharedInstance] allEmoticons];
    
    UIImage* delImage = [UIImage imageNamed:@"emoji_btn_delete"];
    int i = 0;
    for (NSString* name in emotionArray) {
        XHEmotion* emotion = [[XHEmotion alloc] init];
        emotion.emotionPath = name;
        emotion.emotionType = EmotionType_Emoji;
        [emotions addObject:emotion];
        
        if (++i >= EmotionPageCount - 1) {
            i = 0;
            XHEmotion* deleteIcon = [[XHEmotion alloc] init];
            deleteIcon.emotionConverPhoto = delImage;
            deleteIcon.emotionType = EmotionType_Delete;
            [emotions addObject:deleteIcon];
        }
    }
    if (i != 0) {
        XHEmotion* deleteIcon = [[XHEmotion alloc] init];
        deleteIcon.emotionConverPhoto = delImage;
        deleteIcon.emotionType = EmotionType_Delete;
        [emotions addObject:deleteIcon];
    }
    emotionManager.emotions = emotions;
    [emotionManagers addObject:emotionManager];
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    self.emotionManagerView.delegate = self;
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    self.messageTableView.backgroundColor = [UIColor XSJColor_grayDeep];
//    self.messageTableView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    
    [self loadDataSource];
    
    [WDNotificationCenter addObserver:self selector:@selector(onNewRcMessage:) name:OnNewRCMessageNotify object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 导航栏右边按钮
    UIView *rightBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 72, 44)];
    
    // 静音按钮
    UIButton *quietBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 36, 36)];
    [quietBtn setImage:[UIImage imageNamed:@"v3_msg_ring_1"] forState:UIControlStateNormal];
    [quietBtn setImage:[UIImage imageNamed:@"v3_msg_ring_0"] forState:UIControlStateSelected];
    [quietBtn addTarget:self action:@selector(quietBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:quietBtn];
    
    // 设置静音按钮状态
    BOOL isQuiet = [[UserData sharedInstance] getUserImNoticeQuietState];
    quietBtn.selected = isQuiet;
    
    // 帮助中心按钮
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, 3, 36, 36)];
    [helpBtn setImage:[UIImage imageNamed:@"v260_icon_help"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:helpBtn];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)quietBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    ConversationModel* lcModel = [DataBaseTool conversationModelWithLocalConversationId:[[ImDataManager sharedInstance] getKefuLocalConversationId]];
    if (lcModel) {
        lcModel.isSoundOff = btn.selected;
        [DataBaseTool saveImConversation:lcModel];
    }
}


- (void)helpBtnClick
{
    // 跳转帮助中心
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_helpCenter];
    vc.title = @"帮助中心";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 从 rc 获取消息列表
- (void)loadDataSource{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_CUSTOMERSERVICE targetId:self.conversation.targetId count:PageNum];
        ELog(@"====array:%lu",(unsigned long)array.count);
        if (self.messages == nil) {
            self.messages = [[NSMutableArray alloc] init];
        }
        for (id msg in array.reverseObjectEnumerator) {
            WdMessage* obj = [self messageFromRcMsg:msg];
            [self.messages addObject:obj];
        }
        
        if (self.messages.count == 0) {
            WdMessage* obj = [[WdMessage alloc] init];
            obj.bShowTimeLine = NO;
            obj.shouldShowUserName = NO;
            obj.sender = self.targetInfo.accountName;
            obj.timestamp = [NSDate date];
            obj.messageMediaType = XHBubbleMessageMediaTypeText;
            obj.bubbleMessageType = XHBubbleMessageTypeReceiving;
            obj.text = kefuFistText;
            obj.avatar = [UIImage imageNamed:self.targetInfo.kefuImg];
            RCMessageContent* msgContent = [[RCMessageContent alloc] init];
            RCMessage* rcMessage = [[RCMessage alloc] initWithType:ConversationType_CUSTOMERSERVICE targetId:KeFuMMId direction:MessageDirection_RECEIVE messageId:0 content:msgContent];
            obj.rcMsg = rcMessage;
            
            [self.messages addObject:obj];
        }
        [self judgeShowTime:NO];
        MKDispatch_main_async_safe(^{
            [self.messageTableView reloadData];
            [self scrollToBottomAnimated:NO];
        });
    });
}

#pragma mark - 融云来消息处理
- (void)onNewRcMessage:(NSNotification *)note{
    if (!note.object) {
        return;
    }
    RCMessage* message = note.object;
    if ([message.targetId isEqualToString:self.targetInfo.uuid]) {
        [self addMessageToView:message];
    }
}

- (void)addMessageToView:(RCMessage*)rcmsg{
    WdMessage* obj = [self messageFromRcMsg:rcmsg];
    if (obj) {
        [self addMessage:obj withReload:YES];
    }
}

- (WdMessage*)messageFromRcMsg:(RCMessage*)rcmsg{
    WdMessage* obj = [ImDataManager getMessageByRCMessage:rcmsg];
    if (obj) {
        switch (obj.rcMsg.messageDirection) {
            case MessageDirection_SEND:
            {
                obj.avatarUrl = [self.selfInfo getHead];
//                obj.sender = [self.selfInfo getShowName];
            }
                break;
            case MessageDirection_RECEIVE:
            {
                obj.avatarUrl = [self.targetInfo getHead];
//                obj.sender = [self.targetInfo getShowName];
            }
            default:
                break;
        }
//        ELog(@"========obj:%@",[obj simpleJsonString]);
        return obj;
    }
    return nil;
}
                   
#pragma mark - RCSendMessageDelegate 发送消息结果回调
#pragma mark - XHMessageTableViewControllerDelegate
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date{
    
    NSString *msgStr = text;
    if (self.selfInfo.account_type.integerValue == 1) {
        msgStr = [msgStr stringByAppendingString:@"   → 雇主"];
    }else if (self.selfInfo.account_type.integerValue == 2){
        msgStr = [msgStr stringByAppendingString:@"   → 兼客"];
    }
    
//    ImTextMessage* message = [[ImTextMessage alloc] init];
//    message.message = msgStr;

    RCTextMessage* messageContent = [RCTextMessage messageWithContent:msgStr];
    WEAKSELF
    RCMessage* rcMsg = [[RCIMClient sharedRCIMClient] sendMessage:self.conversation.conversationType targetId:self.targetInfo.uuid content:messageContent pushContent:msgStr pushData:@"" success:^(long messageId) {
        ELog(@"======发送文本消息  成功 messageId:%ld  msgStr:%@",messageId , msgStr);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        ELog(@"======发送文本消息  失败 messageId:%ld",messageId);
    }];

//    RCMessage* rcMsg = [[RCIMClient sharedRCIMClient] sendMessage:self.conversation.conversationType targetId:self.targetInfo.uuid content:messageContent pushContent:text success:^(long messageId) {
//        ELog(@"======发送文本消息  成功 messageId:%ld",messageId);
//    } error:^(RCErrorCode nErrorCode, long messageId) {
//        ELog(@"======发送文本消息  失败 messageId:%ld",messageId);
//    }];
    
//    rcMsg.content = [RCTextMessage messageWithContent:text];
    [weakSelf addMessageToView:rcMsg];
    [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [self changeSendBtnState];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date{
//    NSString* dataStr = [NSNumber numberWithLongLong:date.timeIntervalSince1970*1000].stringValue;
    RequestInfo* request = [[RequestInfo alloc] init];
    
    WEAKSELF
    [request uploadImage:photo andBlock:^(NSString* imageUrl) {
        ImPhotoMessage* msg = [[ImPhotoMessage alloc]init];
        msg.url = imageUrl;

        RCImageMessage* messageContent = [RCImageMessage messageWithImage:photo];
        messageContent.imageUrl = imageUrl;
        messageContent.thumbnailImage = photo;
   
        RCMessage* selfMsg = [[RCIMClient sharedRCIMClient] insertMessage:self.conversation.conversationType targetId:self.targetInfo.uuid senderUserId:self.selfInfo.uuid sendStatus:SentStatus_SENT content:messageContent];
        [weakSelf addMessageToView:selfMsg];
        [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];

        __unused RCMessage* rcMsg = [[RCIMClient sharedRCIMClient] sendImageMessage:weakSelf.conversation.conversationType targetId:self.targetInfo.uuid content:messageContent pushContent:@"图片" pushData:nil progress:^(int progress, long messageId) {
            ELog(@"======progress:%dd",progress);
        } success:^(long messageId) {
            DLog(@"======发送消息  成功 messageId:%ld",messageId);
        } error:^(RCErrorCode errorCode, long messageId) {
            DLog(@"======发送消息  失败 messageId:%ld",messageId);
        }];
//        [self addMessageToView:selfMsg];
    }];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
//    if (self.messages.count <= indexPath.row) {
//        return NO;
//    }
//    WdMessage* msg = [self.messages objectAtIndex:indexPath.row];
//    if (msg.messageMediaType == XHBubbleMessageMediaTypeSystem || msg.messageMediaType == XHBubbleMessageMediaTypeText) {
//        return YES;
//    }
//    return NO;
//    //    if (self.messages.count <= indexPath.row) {
//    //        return YES;
//    //    }
//    //
//    //    WdMessage* msg = [self.messages objectAtIndex:indexPath.row];
//    //    return msg.bShowTimeLine;
}

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop{
    return YES;
}


/**
 *  下拉加载更多消息，只有在支持下拉加载更多消息的情况下才会调用。
 */
- (void)loadMoreMessagesScrollTotop{
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            long oldestMsgId = -1;
            if (weakSelf.messages.count > 0) {
                WdMessage* msg = weakSelf.messages.firstObject;
                oldestMsgId = msg.rcMsg.messageId;
            }
            
            if (f_oldestMsgId == oldestMsgId) {
//                ELog(@"======f_oldestMsgId请求重复：%ld", f_oldestMsgId);
                weakSelf.loadingMoreMessage = NO;
                return;
            }
            if (oldestMsgId <= 1) {
                weakSelf.loadingMoreMessage = NO;
                return;
            }
            
            int count = (int)(PageNum <= oldestMsgId-1 ? PageNum : oldestMsgId - 1);
//            ELog(@"正在请求历史记录，oldestMsgId=%ld，请求数量：%d", oldestMsgId, count);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray* array = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:self.conversation.targetId oldestMessageId:oldestMsgId count:count];
                if (array.count < 1) {
                    weakSelf.loadingMoreMessage = NO;
                    return;
                }
                
                NSMutableArray* messages = [[NSMutableArray alloc] initWithCapacity:array.count];
                for (id msg in array.reverseObjectEnumerator) {
                    //====下拉刷新区分 兼客 雇主 类型
                    id obj = [self messageFromRcMsg:msg];
                    if (obj) {
                        [messages addObject:obj];
                    }else{
                        ELog(@"=====消息解析失败！！！！");
                    }
                }
                //                [weakSelf insertOldMessages:message];
                [weakSelf insertOldMessages:messages];
                weakSelf.loadingMoreMessage = NO;
                f_oldestMsgId = oldestMsgId;
            });
        });
    }
}



/**
 *  发送第三方表情消息的回调方法
 *`
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date{
    ELog(@"=======emotionPath:%@",emotionPath)
    if (emotionPath) {
        NSAssert(NO, @"不支持第三方表情消息");
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
    }
}

#pragma mark - XHMessageTableViewCell delegate

- (void)playVoice:(id<XHMessageModel>)message onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    // Mark the voice as read and hide the red dot.
    message.isRead = YES;
    messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
    
    ((XHAudioPlayerHelper*)[XHAudioPlayerHelper shareInstance]).delegate = self;
    if (_currentSelectedCell) {
        [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    }
    if (_currentSelectedCell == messageTableViewCell) {
        [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        self.currentSelectedCell = nil;
    } else {
        self.currentSelectedCell = messageTableViewCell;
        [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
    }
}

- (NSString *)getVoicePath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    return recorderPath;
}
//统一语音路径
- (NSString*)getRecorderPath{
    NSString* recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDate* now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"/%@.wav",[dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark - 点击消息 事件处理
/**
 *  点击多媒体消息的时候统一触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 *  @param messageTableViewCell 目标消息在该Cell上
 */
- (void)multiMediaMessageDidSelectedOnMessage:(WdMessage*)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeImgText:
        {
            DLog(@"==============点击了图文消息");
//            
//            //            "type" :  int,  // 类型，1：跳转网页类型，2：app内跳转
//            //            "code" :  " app内跳转code定义",  //type=2时，此参数必须有值
//            //            “app_param”: {}, // app内跳转的参数，type=2时必须有值，值的内容根据code不同而不同
//            //            "linkUrl" : "点击图片后跳转的URL,type=1时此参数必须有值"
//            //            NSString *url=[NSString stringWithFormat:@"%@/wap/entPromise", @"http://api.jianke.cc"];
//            
//            NSNumber* type = message.type;
//            NSString* linkUrl = message.linkUrl;
//            
//            NSNumber* code = message.code;
//            NSString* app_param = message.app_param;
//            
//            DLog(@"====type:%@",type);
//            DLog(@"====linkUrl:%@",linkUrl);
//            DLog(@"====code:%@",code);
//            DLog(@"====app_param:%@",app_param);
//            
//            if (type.intValue == 1) {
//                WebView_VC* vc = [UIHelper getVCFromStoryboard:@"Common_hlw" identify:@"sid_web_view"];
//                vc.url = linkUrl;
//                vc.title = message.title;
//                [self.navigationController pushViewController:vc animated:YES];
//                
//            }else if (type.intValue == 2){
//                DLog(@" type = 2     没做处理");
//            }
//            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        {
            // Create image info
            JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
            XHBubblePhotoImageView* view = messageTableViewCell.messageBubbleView.bubblePhotoImageView;
            
            imageInfo.imageURL = [NSURL URLWithString:message.originPhotoUrl];
            imageInfo.placeholderImage = view.messagePhoto;
            
            // Setup view controller
            JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                                   initWithImageInfo:imageInfo
                                                   mode:JTSImageViewControllerMode_Image
                                                   backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
            
            // Present the view controller.
            [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        }
            break;
        case XHBubbleMessageMediaTypeVideo: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
        }
            break;
        case XHBubbleMessageMediaTypeVoice:
            break;
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        case XHBubbleMessageMediaTypeJob:
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:
            break;
        default:
            break;
    }
    
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

#pragma mark - 双击文本消息，触发这个回调
- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    return;
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHEmotionManagerView Delegate

- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    
    NSString* str = self.messageInputView.inputTextView.text;
    if (emotion.emotionType == EmotionType_Delete) {
        if(str.length < 1)
            return;
        
        str = [str substringToIndex:str.length > 1 ? str.length - 2 : 1];
        self.messageInputView.inputTextView.text = str;
        [self changeSendBtnState];
        return;
    }
    
    if (emotion.emotionType == EmotionType_Emoji) {
        self.messageInputView.inputTextView.text = [NSString stringWithFormat:@"%@%@",str, emotion.emotionPath];
    }
    [self changeSendBtnState];
}

#pragma mark - XHEmotionManagerView DataSource
- (NSInteger)numberOfEmotionManagers{
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column{
    return [self.emotionManagers objectAtIndex:column];
}

-(NSArray*)emotionManagersAtManager{
    return self.emotionManagers;
}

#pragma mark - XHAudioPlayerHelperDelegate
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer *)audioPlayer{
    
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer{
    if (!_currentSelectedCell) {
        return;
    }
    [self.currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

- (void)didAudioPlayerPausePlay:(AVAudioPlayer *)audioPlayer{
    
}

#pragma mark - XHShareMenuView Delegate
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    ELog(@"title:%@  index:%ld", shareMenuItem.title, (long)index);
    //    @[@"分享兼职",@"分享企业", @"位置", @"拍照", @"图片", @"拨打电话"]
    
    switch (index) {
        case 0:
        case 1:
        {
            [super didSelecteShareMenuItem:shareMenuItem atIndex:index];
        }
            break;
        default:
            break;
    }
}


//@property (nonatomic, copy) NSString* accountId;            //“和兼客的accountId一致,String”
//@property (nonatomic, copy) NSNumber* account_type;         //账户类型,<整形数字> , 1雇主,2学生 3功能号 4兼客雇主
//@property (nonatomic, copy) NSString* headUrl;              //“头像地址，String”,
//@property (nonatomic, copy) NSString* telephone;            //“电话号码，String”,
//@property (nonatomic, copy) NSString* uuid;                 //“好友的UUID，用来通过融云发送单聊消息给对方，String”,
//@property (nonatomic, copy) NSString* accountName;          //用户名
//@property (nonatomic, copy) NSString* remarkName;           // “备注名称，String”,
//@property (nonatomic, copy) NSNumber* remind;               //“消息提醒方式，int, 1:提醒 2:不提醒”,
//@property (nonatomic, copy) NSNumber* addTime;              //“好友新增时间,long格式时间”
//@property (nonatomic, copy) NSNumber* accountEntInfoId;     //企业id
//@property (nonatomic, copy) NSNumber* resumeId;             //简历ID，add by chenw @ 2015.4.2
//@property (nonatomic, copy) NSNumber* version;              //“冗余信息版本,int”
//@property (nonatomic, copy) NSNumber* priVersion;




//- (ImUserInfo*)kfInfo{
//    if (!_kfInfo) {
//        _kfInfo = [[ImUserInfo alloc] init];
//        _kfInfo.accountId = KeFuMMId;
//        _kfInfo.nickname = @"MM客服";
//        _kfInfo.headUrl =
//    }
//    return _kfInfo;
//}

@end


