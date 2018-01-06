//
//  WDChatView_VC.m
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "WDChatView_VC.h"
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
#import "LookupResume_VC.h"
#import "EpProfile_VC.h"
#import "JobDetail_VC.h"
#import "IQKeyboardManager.h"
#import "UIHelper.h"

#import "IdentityCardAuth_VC.h"
#import "MoneyBag_VC.h"
#import "LocateManager.h"
#import "LocalModel.h"
#import "MoneyDetail_VC.h"

#import "ConversationModel.h"
#import "DataBaseTool.h"
#import "WorkHistoryController.h"
#import "JobDetailModel.h"
#import "IMGroupDetailModel.h"
#import "GroupChatMember_VC.h"
#import "SocialActivist_VC.h"
#import "MainTabBarCtlMgr.h"
#import "JobQA_VC.h"
#import "IntristJob_VC.h"
#import "PersonServiceDetail_VC.h"
#import "MainTabBarCtlMgr.h"
#import "JobQAAlertView.h"

@interface WDChatView_VC ()<XHAudioPlayerHelperDelegate,JobQAAlertDelegate>{
    NSDate* _lastTimeLineDate;
    BOOL _isRequest;   //防止打卡重复请求两次
    BOOL _ishanvLocalConversationId;    //是否保存了本地会话ID;
    NSString* _localConversationId;     //本地会话ID
    
    BOOL _isSoundOff;                   //是否开启声音
    IMGroupDetailModel* _groupDetail;   //群组信息
    RCConversationType _conversationType;   //会话类型
    
    NSArray* _crmMenuArray;
    JobQAAlert *alert;
    NSString  *alertJobId;
}

@property (nonatomic, assign) BOOL isBackToRootView;

@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, strong) ImUserInfo* selfInfo;
@property (nonatomic, strong) ImUserInfo* targetInfo;
@property (nonatomic, strong) RCConversation* conversation;

@property (nonatomic, strong) NSArray* emotionManagers;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) XHPopMenu* morePopMenu;
@property (nonatomic, strong) UIWebView *phoneWebView;
//@property (nonatomic, strong) UIButton* notifyBtn;

@property (nonatomic, strong) UIView* viewCRMBottom;
@end

@implementation WDChatView_VC
#pragma mark - 初始化类方法

+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId resumeId:(NSString *) resumeId hideTabBar:(BOOL)isHideTabBar{
    if (!accountId || !accountType) {
        return;
    }
    WDChatView_VC* chatVC = [[WDChatView_VC alloc] init];
    chatVC.accountId = accountId;
    chatVC.accountType = accountType;
    chatVC.jobTitle = jobTitle;
    chatVC.jobId = jobId;
    chatVC.resumeId = resumeId;
    if (isHideTabBar) {
        chatVC.hidesBottomBarWhenPushed = YES;
    }
    [vc.navigationController pushViewController:chatVC animated:YES];
}

+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId{
    [self openPrivateChatOn:vc accountId:accountId withType:accountType jobTitle:jobTitle jobId:jobId hideTabBar:NO];
}

+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId hideTabBar:(BOOL)isHideTabBar{
    [self openPrivateChatOn:vc accountId:accountId withType:accountType jobTitle:jobTitle jobId:jobId resumeId:nil hideTabBar:isHideTabBar];
}


/** 打开群组聊天界面并分享岗位 */
+ (void)shareJob:(JobModel *)jobModel toImGroupVc:(UIViewController*)vc IMGroupModel:(IMGroupModel*)model isBackToRootView:(BOOL)isBackToRootView{
    
    if (!model) {
        return;
    }
    
    WDChatView_VC* chatVC = [[WDChatView_VC alloc] init];
    chatVC.accountId = model.groupId;
    chatVC.accountType = WDImUserType_Group;
    
    chatVC.isGroupChat = YES;
    chatVC.isShareJob = YES;
    chatVC.jobModel = jobModel;
    chatVC.shouldShowShareJobAlertView = YES;
    chatVC.isBackToRootView = isBackToRootView;
    [vc.navigationController pushViewController:chatVC animated:YES];
}

- (void)backToLastView{
    if (self.isBackToRootView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - dealloc
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    //清除未读标记
    __unused BOOL bSuccess = [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:self.conversation.conversationType targetId:self.conversation.targetId];
    ELog(@"======清除未读消息:%@",bSuccess ? @"成功" : @"失败");
}

- (void)dealloc{
    DLog(@"===WDChatView_VC dealloc");
    self.emotionManagers = nil;
    [WDNotificationCenter removeObserver:self];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor XSJColor_grayDeep];
    self.loginType = [[UserData sharedInstance] getLoginType].integerValue;
    self.selfInfo = [ImDataManager sharedInstance].selfInfo;

    //加载消息时 显示的View
//    CGRect frame = [UIScreen mainScreen].bounds;
//    UIView* view = [[UIView alloc]init];
//    view.frame = frame;
//    view.backgroundColor = [UIColor XSJColor_grayDeep];
//    [self.view addSubview:view];
//    [self initWithNoDataViewWithStr:@"正在获取消息中..." onView:view];
//    self.viewWithNoData.hidden = NO;
    
    //获取对方 基础信息
    if (self.isGroupChat) { //群组
        WEAKSELF
        [[UserData sharedInstance] imGetGroupInfoWithGroupId:self.accountId isSimple:YES block:^(IMGroupDetailModel* groupDetail) {
            if (groupDetail) {
//                [view removeFromSuperview];
                weakSelf.targetInfo = [[ImUserInfo alloc] init];
                weakSelf.targetInfo.account_type = @(WDImUserType_Group);
                weakSelf.targetInfo.accountId = weakSelf.accountId; //群的 ID
                weakSelf.targetInfo.headUrl = groupDetail.groupProrileUrl;
                weakSelf.targetInfo.uuid = groupDetail.groupUuid;
                weakSelf.targetInfo.accountName = groupDetail.groupName;    //群的名字
                if (!groupDetail.groupId) {
                    groupDetail.groupId = weakSelf.accountId;
                }
                _groupDetail = groupDetail;
                if (_groupDetail.groupOwnerEnt.integerValue == weakSelf.selfInfo.accountId.integerValue || _groupDetail.groupOwnerBd.integerValue == weakSelf.selfInfo.accountId.integerValue) {
                    _localConversationId = [weakSelf makeupLocalConversationIdWithType:WDImUserType_Employer];
                }else{
                    _localConversationId = [weakSelf makeupLocalConversationIdWithType:WDImUserType_Jianke];
                }
                [weakSelf setupChatUI];
            }
        }];
    }else{
        WEAKSELF
//        BOOL allowCache = self.accountType == WDImUserType_Func;
        BOOL allowCache = YES;
        [ImDataManager getUserInfoById:self.accountId withType:self.accountType allowCache:allowCache completion:^(id userInfo) {
//            [view removeFromSuperview];
            if (userInfo) {
                weakSelf.targetInfo = userInfo;
                if (weakSelf.accountType == 3 && [userInfo isKindOfClass:[GlobalFeatureInfo class]]) {  //gongnenghao
                    GlobalFeatureInfo* info = (GlobalFeatureInfo*)userInfo;
                    weakSelf.targetInfo.accountName = info.funName;
                    if ([info.accountId isEqualToString:CRMUserId]) {
                        _crmMenuArray = [MenuJsonModel objectArrayWithKeyValuesArray:info.menuJson];
                    }
                    
                }
                _localConversationId = [weakSelf makeupLocalConversationId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setupChatUI];
                });
            }
        }];
        [ImDataManager getUserInfoById:self.accountId withType:self.accountType allowCache:NO completion:nil];

    }
}

#pragma mark - setupGroutUI
- (void)setupChatUI{
    //初始化 声音 控制
    [DataBaseTool clearUnreadMessageWithLocalConversationId:_localConversationId];
    ConversationModel* lcModel = [DataBaseTool conversationModelWithLocalConversationId:_localConversationId];
    if (lcModel) {
        _isSoundOff = lcModel.isSoundOff;
    }else{
        _isSoundOff = NO;
    }
    
    if (self.isGroupChat) {
        _conversationType = ConversationType_GROUP;
        
        NSString* str = _groupDetail.groupName;
//        if (_groupDetail.groupName.length > 7) {
//            str = [NSString stringWithFormat:@"%@...", [_groupDetail.groupName substringToIndex:7]];
//        }else{
//            str = _groupDetail.groupName;
//        }
        self.title = [NSString stringWithFormat:@"%@(%@)",str,_groupDetail.memberNums];
        self.conversation = [[RCIMClient sharedRCIMClient] getConversation:_conversationType targetId:_groupDetail.groupUuid];

    }else{
        _conversationType = ConversationType_PRIVATE;
        self.title = [self.targetInfo getShowName];
        self.conversation = [[RCIMClient sharedRCIMClient] getConversation:_conversationType targetId:self.targetInfo.uuid];
    }
    //自己构造融云 会话
    if (self.conversation == nil) {
        self.conversation = [[RCConversation alloc] init];
        self.conversation.targetId = self.targetInfo.uuid;
        self.conversation.conversationType = _conversationType;
    }
    
//    //添加第三方接入数据  如果又有用到 查看2.3.6之前版本
    //加载 emotion=================
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
    
    self.messageTableView.backgroundColor = [UIColor XSJColor_grayDeep];
//    self.messageTableView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];

    //获取聊天消息========================================
    [self loadDataSource];
    //初始化 CRM 底部按钮
    ELog(@"=====self.selfInfo.accountType:%d",self.accountType);
    if (self.accountType == WDImUserType_Func) {
        self.messageInputView.hidden = YES;
//        self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if ([self.accountId isEqualToString:CRMUserId]) {
            if (_crmMenuArray.count > 0) {
                CGFloat btnWidth = SCREEN_WIDTH/_crmMenuArray.count;
                CGFloat btnHeight = 60;
                self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, btnHeight, 0);
                self.viewCRMBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-btnHeight, self.view.bounds.size.width, btnHeight)];
                [self.view addSubview:self.viewCRMBottom];
                self.viewCRMBottom.backgroundColor = [UIColor whiteColor];
                
                for (NSInteger i = 0; i < _crmMenuArray.count; i++) {
                    MenuJsonModel* model = [_crmMenuArray objectAtIndex:i];
                    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i;
                    [btn setTitle:model.menu_name forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
                    [self.viewCRMBottom addSubview:btn];
                    [btn addTarget:self action:@selector(btnCRMBotOnclick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 12, 1, btnHeight-24)];
                    line.backgroundColor = [UIColor XSJColor_grayDeep];
                    [btn addSubview:line];
                }
            }
        }
    }else{
        self.messageInputView.hidden = NO;
    }
    
    if (!self.messageInputView.hidden) {
        UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMore setImage:[UIImage imageNamed:@"msg_icon_more"] forState:UIControlStateNormal];
        [btnMore setImage:[UIImage imageNamed:@"msg_icon_more"] forState:UIControlStateHighlighted];
        btnMore.frame = CGRectMake(0, 0, 36, 44);
        [btnMore addTarget:self action:@selector(btnMoreOnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnMore];
        UIButton* btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhone.frame = CGRectMake(0, 0, 36, 44);
        
        if (self.isGroupChat) {
            [btnPhone setImage:[UIImage imageNamed:@"v240_btn_group"] forState:UIControlStateNormal];
            [btnPhone setImage:[UIImage imageNamed:@"v240_btn_group"] forState:UIControlStateHighlighted];
            [btnPhone addTarget:self action:@selector(btnGroupInfoOnclick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btnPhone setImage:[UIImage imageNamed:@"v201_img_per_0"] forState:UIControlStateNormal];
            [btnPhone setImage:[UIImage imageNamed:@"v201_img_per_0"] forState:UIControlStateHighlighted];
            [btnPhone addTarget:self action:@selector(btnTargetInfoOnclick:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnPhone];
        self.navigationItem.rightBarButtonItems = @[rightBarItem1,rightBarItem2];
    }
    
    [WDNotificationCenter addObserver:self selector:@selector(onNewRcMessage:) name:OnNewRCMessageNotify object:nil];

    // 弹出分享岗位提示框
    [self shareJob];
}

/** CRM 跳转 */
- (void)btnCRMBotOnclick:(UIButton*)sender{
    MenuJsonModel* model = [_crmMenuArray objectAtIndex:sender.tag];
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 业务方法
/** 弹出分享岗位提示框 */
- (void)shareJob{
    if (!self.isGroupChat || !self.isShareJob || !self.shouldShowShareJobAlertView) {
        return;
    }
    self.shouldShowShareJobAlertView = NO;
    DLAVAlertView *shareJobAlertView = [[DLAVAlertView alloc] initWithTitle:@"提示" message:@"确定将岗位分享到这个群组吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    WEAKSELF
    [shareJobAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf didSendJob:weakSelf.jobModel fromSender:weakSelf.selfInfo.accountName onDate:[NSDate date]];
        }
    }];
}


#pragma mark - 按钮事件
- (XHPopMenu*)morePopMenu{
    if (!_morePopMenu) {
        XHPopMenuItem* popMenuLingdang = [[XHPopMenuItem alloc] initWithImage:nil title:@"开关铃声"];
        XHPopMenuItem* popMenuJuban = [[XHPopMenuItem alloc] initWithImage:nil title:@"举报"];
        XHPopMenu* popMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuLingdang, popMenuJuban]];
        
        WEAKSELF
        popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem* menuItem){
            if (index == 0) {
                [UserData delayTask:0.3 onTimeEnd:^{
                    [weakSelf btnNotifiOnclick2];
                }];
            }else if (index == 1){
                [UserData delayTask:0.3 onTimeEnd:^{
                    [UIHelper toast:@"举报成功"];
                }];
            }
        };
        _morePopMenu = popMenu;
    }
    return _morePopMenu;
}

- (void)checkEpInfo{
    EmployerInfo* epInfoModel;
    epInfoModel = (EmployerInfo*)self.targetInfo;
    if (epInfoModel.entInfoId.integerValue) {
        EpProfile_VC *vc = [[EpProfile_VC alloc] init];
        vc.isLookForJK = YES;
        vc.enterpriseId = [NSString stringWithFormat:@"%@",epInfoModel.entInfoId];
        vc.isfromIM = self.isFromIM;
        [self.navigationController pushViewController:vc animated:YES];;
    }
}

- (void)checkJkInfo{
    if (self.targetInfo.resumeId.integerValue) {
        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
        vc.isLookOther = YES;
        vc.resumeId = self.targetInfo.resumeId;
        [self.navigationController pushViewController:vc animated:YES];;
    }else if (self.resumeId){
        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
        vc.isLookOther = YES;
        vc.resumeId = self.resumeId;
        [self.navigationController pushViewController:vc animated:YES];;
    }
}

- (void)btnMoreOnClick:(UIButton*)sender{
    [self.morePopMenu showMenuAtPoint:CGPointMake(self.view.width - 130, 55)];
}

- (void)btnNotifiOnclick2{
    ELog(@"声音提示 开/关");
    
    ConversationModel* lcModel = [DataBaseTool conversationModelWithLocalConversationId:_localConversationId];
    if (lcModel) {
        _isSoundOff = !lcModel.isSoundOff;
        lcModel.isSoundOff = _isSoundOff;
        [DataBaseTool saveImConversation:lcModel];
    }else{
        _isSoundOff = !_isSoundOff;
    }
    
    if (_isSoundOff) { // 开 -> 关
        [UIHelper toast:@"声音提示已关闭"];
    } else {
        [UIHelper toast:@"声音提示已开启"];
    }
}

- (void)btnTargetInfoOnclick:(UIButton*)sender{
    [self hideAllMenu];
    if (self.targetInfo.account_type.intValue == WDImUserType_Employer){
        [self checkEpInfo];
    }else if (self.targetInfo.account_type.intValue == WDImUserType_Jianke){
        [self checkJkInfo];
    }
}

- (void)btnGroupInfoOnclick:(UIButton*)sender{
    [self hideAllMenu];
    GroupChatMember_VC* vc = [[GroupChatMember_VC alloc] init];
    vc.groupLocalConversationIdSign = [[ImDataManager sharedInstance] makeGroupLocalConversationIdSignWithUuid:_groupDetail.groupUuid];
    vc.groupId = self.accountId;
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma mark - 从 rc 获取消息列表
- (void)loadDataSource{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从 RC 获取消息 列表
        NSArray* array = [[RCIMClient sharedRCIMClient] getLatestMessages:_conversationType targetId:weakSelf.conversation.targetId count:PageNum];
        if (weakSelf.messages == nil) {
            weakSelf.messages = [[NSMutableArray alloc] init];
        }
        
#pragma mark - 判断消息类型，过滤需要显示的消息；
        for (id msg in array.reverseObjectEnumerator) {
            ImPacket* packet = [ImDataManager packetFromRCMessage:msg];
            if (!packet) {
                continue;
            }
            //          ELog(@"===pack:%@",[packet.dataObj simpleJsonString]);
            if (weakSelf.isGroupChat) {
                WdMessage* obj = [weakSelf messageFromRcMsg:msg];
                if (obj) {
                    [weakSelf.messages addObject:obj];
                    if ([packet.dataObj.fromUser isEqualToString:_groupDetail.groupOwnerEnt.stringValue]) { // 群主
                        obj.bIsGroupManagerOwner = YES;
                    } else if ([packet.dataObj.fromUser isEqualToString:_groupDetail.groupOwnerBd.stringValue]) { // BD
                        obj.bIsGroupManagerBD = YES;
                    }
                }
            }else{
                if ([[packet.dataObj getMessageContent] isKindOfClass:[ImSystemMsg class]]) {
                    ImSystemMsg *message = (ImSystemMsg *)[packet.dataObj getMessageContent];
                    if (message.notice_type.integerValue == WdSystemNoticeType_noticeBoardMessage) {
                        continue;
                    }
                }
                
                //          如果接收消息的 id 和 loginType 与自己现在的状态相同
                if ((packet.dataObj.fromUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.fromType.intValue == weakSelf.selfInfo.account_type.intValue)
                    || (packet.dataObj.toUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.toType.intValue == weakSelf.selfInfo.account_type.intValue)
                    || (packet.dataObj.toUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.toType.intValue == WDImUserType_EpJk)
                    || (packet.dataObj.fromType.intValue == WDImUserType_Func && (packet.dataObj.toType.intValue == weakSelf.selfInfo.account_type.intValue || packet.dataObj.toType.intValue == WDImUserType_EpJk))
                    ){
                    WdMessage* obj = [weakSelf messageFromRcMsg:msg];
                    if (obj) {
                        // 如果是打卡消息就做本地存储
                        [weakSelf savePunchMessage:obj];
                        [weakSelf.messages addObject:obj];
                    }
                }
            }
        }
        
        // 对self.messages数据进行重新排序
        if (!weakSelf.isGroupChat) {
            [weakSelf sortMessages];
        }
        [weakSelf judgeShowTime:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.messageTableView reloadData];
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}


/** 对self.messages数据进行重新排序 */
- (void)sortMessages{
    NSMutableArray *newMessages = [NSMutableArray arrayWithArray:self.messages];
    self.messages = [NSMutableArray array];
    
    for (WdMessage *obj in newMessages) {
        [self addMessage:obj withReload:NO];
    }
}

/** 如果是打卡消息就做本地存储 */
- (void)savePunchMessage:(WdMessage *)obj{
    if (obj.messageMediaType == XHBubbleMessageMediaTypeSystem) {
        ImSystemMsg *sysMsg = obj.obj_id;
        if (sysMsg.notice_type.integerValue == WdSystemNoticeType_JKReceiveReportRequest) {
            
            NSString *key = [NSString stringWithFormat:@"%@_%@", sysMsg.apply_job_id ,sysMsg.punch_the_clock_request_id];
            NSNumber *value = [WDUserDefaults objectForKey:key];
            
            if (!value) {
                [WDUserDefaults setObject:@(0) forKey:key];
                [WDUserDefaults synchronize];
                sysMsg.isPunched = @(0);
            }
        }
    }
}


#pragma mark - 融云来消息处理
- (void)onNewRcMessage:(NSNotification *)note{
    if (!note.object) {
        return;
    }

    ELog(@"=============WDChatView_VC 融云来消息了");
    //获取 本地 会话ID  清楚会话未读数量
    if (!_localConversationId) {
        DLog(@"====error");
    }
    [DataBaseTool clearUnreadMessageWithLocalConversationId:_localConversationId];
    
    RCMessage* message = note.object;
    
    //区分发给 兼客还是雇主的如果  不是现在的状态 就不提示 声音和振动
//    ImPacket* packet = [ImDataManager packetFromRCMessage:message];
//
//    if (packet.dataObj.toType.intValue == self.selfInfo.account_type.intValue || packet.dataObj.toType.intValue == WDImUserType_EpJk) {
//        [[ImDataManager sharedInstance] checkPlaySoundOfMessage:message];
//    }
    
    if ([message.targetId isEqualToString:self.targetInfo.uuid]) {
        [self addMessageToView:message];
    }
}

- (void)addMessageToView:(RCMessage*)rcmsg{
    WdMessage* obj = [self messageFromRcMsg:rcmsg];
    ImPacket* packet = [ImDataManager packetFromRCMessage:rcmsg];
    if (self.isGroupChat) {
        if (obj) {
            // 判断是否是群主或BD
            if ([packet.dataObj.fromUser isEqualToString:_groupDetail.groupOwnerEnt.stringValue] ) { // 群主
                obj.bIsGroupManagerOwner = YES;
            } else if ([packet.dataObj.fromUser isEqualToString:_groupDetail.groupOwnerBd.stringValue]) { // BD
                obj.bIsGroupManagerBD = YES;
            }
        }
    }
    
    // 如果是打卡消息就做本地存储
    [self savePunchMessage:obj];
    [self addMessage:obj withReload:YES];
}

- (WdMessage*)messageFromRcMsg:(RCMessage*)rcmsg{
    WdMessage* obj = [ImDataManager getMessageByRCMessage:rcmsg];
    
    ImPacket* packet = [ImDataManager packetFromRCMessage:rcmsg];
//    ImMessage *imMessage = [packet.dataObj getMessageContent];
    
    if (obj) {
        if (packet.dataObj.fromUser.integerValue == self.selfInfo.accountId.integerValue) {
            obj.avatarUrl = [self.selfInfo getHead];
            obj.sender = [self.selfInfo getShowName];
        }else if (packet.dataObj.fromUser.integerValue == self.targetInfo.accountId.integerValue){
            obj.avatarUrl = [self.targetInfo getHead];
            obj.sender = [self.targetInfo getShowName];
            if (self.isGroupChat) {
                obj.bShowUserName = YES;
            }
        }else if (packet.dataObj.toType.integerValue == 5){  //群组消息
            ImMessage* imMsg = [packet.dataObj getMessageContent];
            obj.avatarUrl = imMsg.headUrl;
            obj.bShowUserName = YES;
            obj.sender = imMsg.name;
        }
        return obj;
        
//        switch (obj.rcMsg.messageDirection) {
//            case MessageDirection_SEND:
//            {
//                obj.avatarUrl = [self.selfInfo getHead];
////                obj.sender = [self.selfInfo getShowName];
//            }
//                break;
//            case MessageDirection_RECEIVE:
//            {
//                obj.avatarUrl = imMessage.headUrl;
//                obj.sender = imMessage.name;
//                if (self.isGroupChat) {
//                    obj.bShowUserName = YES;
//                }
//            }
//            default:
//                break;
//        }
////        ELog(@"========obj:%@",[obj simpleJsonString]);
//        return obj;
    }
    return nil;
}



#pragma mark - 发送消息的公用方法
- (void)sendMsgToServer:(ImBizType)bizType message:(ImMessage *)message fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    ImTextWrapper* wrapper = [[ImTextWrapper alloc] init];
    ConversationModel* localConModel = [DataBaseTool conversationModelWithLocalConversationId:_localConversationId];
    
    if (localConModel && localConModel.jobId) {
        wrapper.job_id = localConModel.jobId;
    }
    if (self.jobId) {
        wrapper.job_id = self.jobId;
    }
    if (wrapper.job_id) {
        message.job_id = @(wrapper.job_id.integerValue);
    }
    if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
        message.headUrl = [[UserData sharedInstance] getJkModelFromHave].profile_url;
        message.name = [[UserData sharedInstance] getJkModelFromHave].true_name;
    }else{
        message.headUrl = [[UserData sharedInstance] getEpModelFromHave].profile_url;
        message.name = [[UserData sharedInstance] getEpModelFromHave].true_name;
    }
    if (self.isGroupChat) {
        message.groupName = _groupDetail.groupName;
    }
    
    ImPacket* packet = [[ImPacket alloc] init];
    
    if (self.isGroupChat) {
        packet.type = @"3"; //群消息 类型
    }
    packet.msgUuid = [UIDeviceHardware getUUIDString];
    
    packet.dataObj = [[ImBusiDataObject alloc] init];
    packet.dataObj.fromUser = self.selfInfo.accountId;
    packet.dataObj.fromType = self.selfInfo.account_type;
    packet.dataObj.toUser = self.targetInfo.accountId;
    packet.dataObj.toType = self.targetInfo.account_type;
    packet.dataObj.bizType = [NSNumber numberWithInt:bizType];
    packet.dataObj.sendTime = [NSNumber numberWithLongLong:date.timeIntervalSince1970*1000];
    packet.dataObj.content = [message simpleJsonString];
    
    switch (bizType) {
        case ImBizType_TextMessage:
        {
            packet.dataObj.notifyContent = ((ImTextMessage*)message).message;
            [self checkJobQutionMessage:message];
        }
            break;
        case ImBizType_ImageMessage:
            packet.dataObj.notifyContent = @"[图片]";
            break;
        case ImBizType_VoiceMessage:
            packet.dataObj.notifyContent = @"[语音]";
            break;
        case ImBizType_LocationMessage:
            packet.dataObj.notifyContent = ((ImLocationMessage*)message).address;
            break;
        case ImBizType_ShareCompMessage:
            packet.dataObj.notifyContent = ((ImShareCompMessage*)message).entName;
            break;
        case ImBizType_SharePostMessage:
            packet.dataObj.notifyContent = ((ImShareJobMessage*)message).title;
            break;
        case ImBizType_ServerNotifyMessage:
            packet.dataObj.notifyContent = ((ImSystemMsg*)message).message;
            break;
        case ImBizType_ImageAndTextMessage:
            packet.dataObj.notifyContent = @"[图文消息]";
            break;
        default:
            break;
    }
    
    ELog(@" packet:%@",[packet simpleJsonString]);
    if (!self.targetInfo.uuid || !self.targetInfo.uuid.length) {
        [UIHelper toast:@"暂时无法和该雇主聊天!"];
        return;
    }
    
    NSString* strPacket = [packet getRequestStrWithSignKey:self.targetInfo.uuid];
    
    wrapper.fromUser = packet.dataObj.fromUser;
    wrapper.fromType = packet.dataObj.fromType;
    wrapper.fromUuid = self.selfInfo.uuid;
    wrapper.toUser = packet.dataObj.toUser;
    wrapper.toType = packet.dataObj.toType;
    wrapper.toUuid = self.targetInfo.uuid;
    wrapper.packet = strPacket;
    wrapper.pushData = packet.dataObj.notifyContent;
    
    NSString* content = [wrapper simpleJsonString];
    //    ELog(@"======send content:%@",content);
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_sendMessage" andContent:content];
    request.isContentContainBracket = YES;
    WEAKSELF
    [request sendRequestToImServer:^(ResponseInfo* response) {
        if (response && [response success]) {
            //保存自己这方的消息，服务端那边没有发自己的
            NSString* strPacketExtra = [packet getRequestStrWithSignKey:weakSelf.selfInfo.uuid];
            RCTextMessage* rcMsg = [RCTextMessage messageWithContent:packet.dataObj.notifyContent];
            //            RCTextMessage* rcMsg = [[RCTextMessage alloc] init];
            //            rcMsg.content = packet.dataObj.notifyContent;
            rcMsg.extra = strPacketExtra;
            
            RCMessage* selfMsg = [[RCIMClient sharedRCIMClient] insertMessage:weakSelf.conversation.conversationType targetId:weakSelf.targetInfo.uuid senderUserId:weakSelf.selfInfo.uuid sendStatus:SentStatus_SENT content:rcMsg];
            [weakSelf addMessageToView:selfMsg];
            
            //保存会话
            ELog(@"=====localConversationId");
            ConversationModel* lcModel = [DataBaseTool conversationModelWithLocalConversationId:_localConversationId];
            
            if (!lcModel) {
                lcModel = [[ConversationModel alloc] init];
                lcModel.userId = packet.dataObj.fromUser;
                lcModel.userType = packet.dataObj.fromType.integerValue;
                lcModel.targetId = packet.dataObj.toUser;
                lcModel.targetType = packet.dataObj.toType.integerValue;
                
                lcModel.rcConversationId = weakSelf.conversation.targetId;
                lcModel.localConversationId = _localConversationId;
            }
            lcModel.targetShowName = self.targetInfo.accountName;
            lcModel.targetHeadUrl = self.targetInfo.headUrl;
            lcModel.jobId = wrapper.job_id;
            lcModel.unReadMsgCount = @(0);
            lcModel.conversation = weakSelf.conversation;
            lcModel.lastModifiedTime = packet.dataObj.sendTime.stringValue;
            lcModel.isSoundOff = _isSoundOff;
            
            
            if (weakSelf.isGroupChat) {
                lcModel.isGroupManage = NO;
                if (_groupDetail.groupOwnerEnt) {
                    if ([[NSString stringWithFormat:@"%@",_groupDetail.groupOwnerEnt] isEqualToString:weakSelf.selfInfo.accountId]) {
                        lcModel.isGroupManage = YES;
                    }
                }
                if (_groupDetail.groupOwnerBd){
                    if ([[NSString stringWithFormat:@"%@",_groupDetail.groupOwnerBd] isEqualToString:weakSelf.selfInfo.accountId]) {
                        lcModel.isGroupManage = YES;
                    }
                }
                
                lcModel.isGroupConversation = YES;
                lcModel.groupConversationId = [[ImDataManager sharedInstance] makeGroupLocalConversationIdSignWithUuid:weakSelf.targetInfo.uuid];
                lcModel.groupName = _groupDetail.groupName;
                lcModel.localConversationType = lcModel.isGroupManage ? @"1" : @"2";
            }else{
                lcModel.isGroupConversation = NO;
            }
            [DataBaseTool saveImConversation:lcModel];
            
            //保存消息
            [[ImDataManager sharedInstance] saveLocalMsgWithRCMsg:selfMsg andUnRead:NO andLocalConversationId:_localConversationId];
            
            ELog(@"发送 保存消息到数据库 成功");
        }
    }];
}



/** 检测是否为岗位问答消息 */
- (void)checkJobQutionMessage:(ImMessage *)message{
    if (!self.messages || !self.messages.lastObject) {
        return;
    }
    
    WdMessage *wdMsg = self.messages.lastObject;
    ImPacket *imPkg = [ImDataManager packetFromRCMessage:wdMsg.rcMsg];
    ImBusiDataObject *imObj = imPkg.dataObj;
    
    if (imObj.bizType.intValue == ImBizType_ServerNotifyMessage) {
        ImSystemMsg *sysMsg = [imObj getMessageContent];
        if (sysMsg.notice_type.intValue == WdSystemNoticeType_JopAnswerQuestion) {
            DLog(@"上一条是岗位问答消息...");
            [[UserData sharedInstance] entJobAnswerWithJobId:sysMsg.job_id.stringValue quesitonId:sysMsg.question_id answer:((ImTextMessage*)message).message block:nil];
        }
    }
}


#pragma mark - RCSendMessageDelegate 发送消息结果回调 XHMessageTableViewControllerDelegate
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date{
    ImTextMessage* message = [[ImTextMessage alloc] init];
    message.message = text;
    
    // 添加title
    [self addTip:message];
    [self sendMsgToServer:ImBizType_TextMessage message:message fromSender:sender onDate:date];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [self changeSendBtnState];
}

/** 添加title上下文 */
- (void)addTip:(ImTextMessage *)message{
    // 判断是否需要添加title
    if (!self.jobTitle || !self.jobTitle.length) {
        return;
    }
    
    NSString *lastTitle = nil;
    NSInteger count = self.messages.count;
    for (NSInteger i = count -1; i >= 0; i--) {
        
        WdMessage *wdMsg = self.messages[i];
        if (wdMsg.messageMediaType == XHBubbleMessageMediaTypeText) {
            ImTextMessage * textMessage = wdMsg.obj_id;
            if (textMessage.MsgTip && ![textMessage.MsgTip isEqualToString:self.jobTitle] && !lastTitle) {
                message.MsgTip = self.jobTitle;
                return;
            }
            if (textMessage.MsgTip) {
                lastTitle = textMessage.MsgTip;                
            }
        }
    }
    if (!lastTitle) {
        message.MsgTip = self.jobTitle;
    }
    
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date{
    
    RequestInfo* request = [[RequestInfo alloc] init];
    WEAKSELF
    [request uploadImage:photo andBlock:^(NSString* imageUrl) {
        ImPhotoMessage* msg = [[ImPhotoMessage alloc]init];
        msg.url = imageUrl;
        [weakSelf sendMsgToServer:ImBizType_ImageMessage message:msg fromSender:sender onDate:date];
        [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];

    }];
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


/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date{
    NSDate* dateNow = [NSDate date];
    //转格式
    NSData* dataWav = [NSData dataWithContentsOfFile:voicePath];
    NSData* dataAmr = [[RCAMRDataConverter sharedAMRDataConverter] decodeAMRToWAVE:dataWav];
    __unused NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:dateNow];
    ELog(@"==========wav转amr，花了时间：%f", interval);
    
    RequestInfo* request = [[RequestInfo alloc] init];
    WEAKSELF
    [request uploadVoice:dataAmr andBlock:^(NSString* imageUrl) {
        ImVoiceMessage* msg = [[ImVoiceMessage alloc] init];
        msg.voicePath = voicePath;
        msg.VoiceLong = [NSNumber numberWithFloat:voiceDuration.floatValue*1000];
        msg.url = imageUrl;
        msg.VoiceName = [NSString stringWithFormat:@"%.0f.amr", [NSDate date].timeIntervalSince1970*1000];
        [weakSelf sendMsgToServer:ImBizType_VoiceMessage message:msg fromSender:sender onDate:date];
    }];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

/**
 *  发送地理位置的回调方法
 *
 *  @param geoLocationsPhoto 目标显示默认图
 *  @param geolocations      目标地理信息
 *  @param location          目标地理经纬度
 *  @param sender            发送者
 *  @param date              发送时间
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date{
    ImLocationMessage* msg = [[ImLocationMessage alloc] init];
    msg.address = geolocations;
    msg.lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    msg.lon = [NSNumber numberWithDouble:location.coordinate.longitude];
    [self sendMsgToServer:ImBizType_LocationMessage message:msg fromSender:sender onDate:date];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date{
    ELog(@"=====videoPath");
    NSAssert(NO, @"不支持视频消息");
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送岗位消息
 *
 *  @param jobInfo  岗位消息
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendJob:(JobModel *)jobModel fromSender:(NSString *)sender onDate:(NSDate *)date{
    ImShareJobMessage* msg = [[ImShareJobMessage alloc] init];
    msg.jobId = jobModel.job_id.stringValue;
    msg.title = jobModel.job_title;
    msg.desc = [NSString stringWithFormat:@"工作地址:%@",jobModel.working_place];
    msg.jobIcon = jobModel.job_classfie_img_url;
    [self sendMsgToServer:ImBizType_SharePostMessage message:msg fromSender:sender onDate:date];
}

/**
 *  发送企业消息
 *
 *  @param EpModel 企业消息
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEpInfo:(EPModel *)epModel fromSender:(NSString *)sender onDate:(NSDate *)date{
    ImShareCompMessage* msg = [[ImShareCompMessage alloc] init];
    msg.entName = [NSString stringWithFormat:@"给你推荐了一个企业【%@】点击查看哦！",epModel.enterprise_name];
    msg.desc = @"";
    msg.headUrl = epModel.img_url;
    msg.accountId = epModel.enterprise_id;
    [self sendMsgToServer:ImBizType_ShareCompMessage message:msg fromSender:sender onDate:date];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.messages.count <= indexPath.row) {
        return NO;
    }
    
    WdMessage* msg = [self.messages objectAtIndex:indexPath.row];
    
    if (msg.messageMediaType == XHBubbleMessageMediaTypeText) {
        
        ImTextMessage *textMessage = msg.obj_id;
        if (textMessage.MsgTip) {
            return YES;
        }
    }
    
    return NO;
    
    
//    if (self.messages.count <= indexPath.row) {
//        return YES;
//    }
//    
//    WdMessage* msg = [self.messages objectAtIndex:indexPath.row];
//    return msg.bShowTimeLine;
}

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop{
    return YES;
}

long f_oldestMsgId = 0;
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
            NSArray* array = [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType targetId:weakSelf.conversation.targetId oldestMessageId:oldestMsgId count:count];
            if (array.count < 1) {
                weakSelf.loadingMoreMessage = NO;
                return;
            }
            
            if (_conversationType == ConversationType_GROUP) {
                NSMutableArray *newMessages = [[NSMutableArray alloc] initWithCapacity:array.count];
                for (id msg in array.reverseObjectEnumerator) {
                    ImPacket* packet = [ImDataManager packetFromRCMessage:msg];
                    if (!packet) {
                        continue;
                    }
                    id obj = [weakSelf messageFromRcMsg:msg];
                    if (obj) {
                        [newMessages addObject:obj];
                    }else{
                        ELog(@"=====消息解析失败！！！！");
                    }
                    f_oldestMsgId = oldestMsgId;
                }
                [weakSelf insertOldMessages:newMessages];
                
            }else if (_conversationType == ConversationType_PRIVATE) {
                NSMutableArray* message = [[NSMutableArray alloc] initWithCapacity:array.count];
                for (id msg in array.reverseObjectEnumerator) {
                    ImPacket* packet = [ImDataManager packetFromRCMessage:msg];
                    if (!packet) {
                        continue;
                    }
                    //====下拉刷新区分 兼客 雇主 类型
                    if ((packet.dataObj.fromUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.fromType.intValue == weakSelf.selfInfo.account_type.intValue)
                        || (packet.dataObj.toUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.toType.intValue == weakSelf.selfInfo.account_type.intValue)
                        || (packet.dataObj.toUser.intValue == weakSelf.selfInfo.accountId.intValue && packet.dataObj.toType.intValue == WDImUserType_EpJk)
                        || (packet.dataObj.fromType.intValue == WDImUserType_Func && (packet.dataObj.toType.intValue == weakSelf.selfInfo.account_type.intValue || packet.dataObj.toType.intValue == WDImUserType_EpJk))
                        ){
                        
                        id obj = [weakSelf messageFromRcMsg:msg];
                        if (obj) {
                            [message addObject:obj];
                        }else{
                            ELog(@"=====消息解析失败！！！！");
                        }
                    }
                }
                //                [weakSelf insertOldMessages:message];
                
                // 插入数据
                NSMutableArray *newMessages = [NSMutableArray arrayWithArray:weakSelf.messages];
                weakSelf.messages = [NSMutableArray array];
                [weakSelf.messages addObjectsFromArray:message];
                [weakSelf.messages addObjectsFromArray:newMessages];
                
                // 对self.messages数据进行重新排序
                [weakSelf sortMessages];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.messageTableView reloadData];
                });
                
                f_oldestMsgId = oldestMsgId;
            }
            weakSelf.loadingMoreMessage = NO;

        });
    }
    
}

/**
 *  配置TableViewCell高度的方法，如果你想定制自己的Cell样式，那么你必须要实现DataSource中的方法
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message;
 *
 *  @param tableView 目标TableView
 *  @param indexPath 目标IndexPath
 *  @param message   目标消息Model
 *
 *  @return 返回计算好的Cell高度
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message;


#pragma mark - XHMessageTableViewController Delegate
/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
//- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 4) {
//        cell.messageBubbleView.displayTextView.textColor = [UIColor colorWithRed:0.106 green:0.586 blue:1.000 alpha:1.000];
//    } else {
//        cell.messageBubbleView.displayTextView.textColor = [UIColor blackColor];
//    }
//}

#pragma mark - XHMessageTableViewCell delegate


- (void)playVoice:(id<XHMessageModel>)message onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell{
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
    }else{
        self.currentSelectedCell = messageTableViewCell;
        [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
    }
}

- (NSString*)getVoicePath{
    NSString* recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
- (void)multiMediaMessageDidSelectedOnMessage:(WdMessage*)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell{
    UIViewController* disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypePhoto:
        {
            [self hideAllMenu];
            // Create image info
            JTSImageInfo* imageInfo = [[JTSImageInfo alloc] init];
            XHBubblePhotoImageView* view = messageTableViewCell.messageBubbleView.bubblePhotoImageView;
            
            imageInfo.imageURL = [NSURL URLWithString:message.originPhotoUrl];
            imageInfo.placeholderImage = view.messagePhoto;
            
            //setup view controller
            JTSImageViewController* imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
            
            //present the view controller
            [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
            
            break;
        }
        case XHBubbleMessageMediaTypeVideo: {
            ELog(@"==========message : %@", message.photo);
            ELog(@"==========message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
        }
            break;
        case XHBubbleMessageMediaTypeVoice:
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (message.voicePath) {
                if (![fileManager fileExistsAtPath:message.voicePath]) {
                    message.voicePath = nil;
                }
            }
            if (message.voicePath == nil) {
                if (message.voiceUrl == nil) {
                    return;
                }
                __block WdMessage* msg_block = (WdMessage*)message;
                
                NSRange range = [message.voiceUrl rangeOfString:@".amr"];
                NSString* afileName = [message.voiceUrl substringToIndex:range.location + range.length];
                afileName = [afileName lastPathComponent];
                
                [RequestInfo downloadFileURL:message.voiceUrl savePath:[self getVoicePath] fileName:afileName andBlock:^(NSString* fileName) {
                    if (!fileName) {
                        ELog(@"======消息已过期");
//                        [self.view makeToast:@"消息已过期"];
                        return;
                    }
                    
                    NSString* wavName = [fileName stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
                    if (![fileManager fileExistsAtPath:wavName]) {
                        NSDate *date = [NSDate date];
                        NSData* dataAmr = [NSData dataWithContentsOfFile:fileName];
                        NSData* dataWav = [[RCAMRDataConverter sharedAMRDataConverter] decodeAMRToWAVE:dataAmr];
                        [dataWav writeToFile:wavName atomically:YES];
                        
//                        [VoiceConverter amrToWav:fileName wavSavePath:wavName];
                        __unused NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
                        ELog(@"arm转换成wav，花了时间：%f", interval);
                    }
                    
                    msg_block.voicePath = wavName;
                    [self playVoice:message onMessageTableViewCell:messageTableViewCell];
                }];
                return;
            }
            [self playVoice:message onMessageTableViewCell:messageTableViewCell];
        }
            break;
        case XHBubbleMessageMediaTypeEmotion:
            ELog(@"=======facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            ELog(@"========facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        case XHBubbleMessageMediaTypeJob:
        {
            ELog(@"===========XHBubbleMessageMediaTypeJob");
            WdMessage *msgBlock = (WdMessage*)message;
            ImPacket* packet = [ImDataManager packetFromRCMessage:msgBlock.rcMsg];
            ImShareJobMessage *shareJobMsg = [packet.dataObj getMessageContent];
            
            // 跳转到岗位详情页面
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = shareJobMsg.jobId;
//            vc.userType = WDLoginType_JianKe;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case XHBubbleMessageMediaTypeEnterprise:
        {
            ELog(@"===========XHBubbleMessageMediaTypeEnterprise");
//            WdMessage* msg_block = (WdMessage*)message;
//            VC_CompanyDetails* vc = [UIHelper getVCFromStoryboard:@"Common" identify:@"sid_companydetails"];
//            vc.enterprise_info_id = msg_block.obj_id;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case XHBubbleMessageMediaTypeSystem:
        {
            WdMessage* msgBlock = (WdMessage*)message;
            ImSystemMsg* sysMsg = msgBlock.obj_id;
            ELog(@"=====noticiType:%d",sysMsg.notice_type.intValue);
            [self systemTypeMediaOnclickEventWith:msgBlock andImSysteMsg:(ImSystemMsg*)sysMsg];
        }
            break;
        case XHBubbleMessageMediaTypeImgText:
        {
            ELog(@"=======点击了图文消息");
            //            "type" :  int,  // 类型，1：跳转网页类型，2：app内跳转
            //            "code" :  " app内跳转code定义",  //type=2时，此参数必须有值
            //            “app_param”: {}, // app内跳转的参数，type=2时必须有值，值的内容根据code不同而不同
            //            "linkUrl" : "点击图片后跳转的URL,type=1时此参数必须有值"
            //            NSString *url=[NSString stringWithFormat:@"%@/wap/entPromise", @"http://api.jianke.cc"];
            
            NSNumber* type = message.type;
            NSString* linkUrl = message.linkUrl;
            __unused NSNumber* code = message.code;
            __unused NSString* app_param = message.app_param;
            ELog(@"====type:%@",type);
            ELog(@"====linkUrl:%@",linkUrl);
            ELog(@"====code:%@",code);
            ELog(@"====app_param:%@",app_param);
            if (type.intValue == 1) {               //跳到网页
                WebView_VC* vc = [[WebView_VC alloc] init];
                vc.url = linkUrl;
                vc.title = message.title;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (type.intValue == 2){
                ELog(@"=== type = 2     没做处理");
            }
            break;
        }

        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

// 系统通知类型 跳转处理
- (void)systemTypeMediaOnclickEventWith:(WdMessage*)message andImSysteMsg:(ImSystemMsg*)sysMsg{
    ELog(@"===========点击系统消息，如果需要跳转跳转  XHBubbleMessageMediaTypeSystem");
    ELog(@"=====noticiType:%d",sysMsg.notice_type.intValue);
    alertJobId = sysMsg.job_id.stringValue;
    switch (sysMsg.notice_type.intValue) {
            
        case WdSystemNoticeType_PersonPoolPush:         // = 46   人才库推送通知
        case WdSystemNoticeType_JobVerifySuccess :      // = 14   岗位审核通过
        case WdSystemNoticeType_JobApplyComplain:       // = 16   岗位申请被投诉
        case WdSystemNoticeType_JkWorkTomorrow :        // = 22   系统提醒兼客明天上岗
        case WdSystemNoticeType_JobBackouted :          // = 36   岗位被下架
        case WdSystemNoticeType_activistJobBroadcast:   // = 83   人脉王岗位推送
        case WdSystemNoticeType_GzAgree:                // = 3    雇主同意申请
        {
            // 兼客跳转到岗位详情页面
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",sysMsg.job_id];
            vc.userType = WDLoginType_JianKe;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WdSystemNoticeType_jobVasPushMessage:     // =85    岗位付费推送通知
        case WdSystemNoticeType_JobVerifyFail:{         // = 15   岗位审核未通过
            // 雇主跳转到岗位详情页面
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@",sysMsg.job_id];
            vc.userType = WDLoginType_JianKe;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WdSystemNoticeType_QyrzVerifyFaild: // 10              //雇主认证失败
        case WdSystemNoticeType_IdAuthFail :         // = 26        //身份认证失败
        case WdSystemNoticeType_JkrzVerifyFaild: // 12              //兼客认证失败
        case WdSystemNoticeType_UnAuthLeaderGetMoney:       // 61: 未认证兼客获取领队薪资通知
        {
            IdentityCardAuth_VC *vc = [[IdentityCardAuth_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    
        case WdSystemNoticeType_EpPayNotification :  // = 20        //系统给雇主发送付款提醒
        {
           
        }
            break;
        case WdSystemNoticeType_GetApplyFitst :      // = 27        //获得首个报名
        case WdSystemNoticeType_GetSnagFitst :       // = 28        //获得首个抢单
        case WdSystemNoticeType_JobApplyFull :       // = 29        //岗位已报满
        case WdSystemNoticeType_JobSnagEnd :         // = 30        //岗位已抢完
        case WdSystemNoticeType_JkApply_Ep:          // 48：兼客申请岗位(雇主)
        {
            
        }
            break;
        case WdSystemNoticeType_RechargeMoneySuccess :      // = 34 //充值成功
        case WdSystemNoticeType_GetMoneySuccess :           // = 35 //取现成功
        case WdSystemNoticeType_PaySuccess :                // = 37 //付款成功
        case WdSystemNoticeType_AlipayGetMoneySuccess:      // 51：支付宝取现成功
        case WdSystemNoticeType_JkMoneyAdd :         // = 21        //系统给兼客发的到账提醒
        {
            MoneyBag_VC *vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
            [self.navigationController pushViewController:vc animated:YES];
            //钱袋子
        }
            break;
        case WdSystemNoticeType_EpCheckJobOver :            // = 39 //雇主确认工作完成
        case WdSystemNoticeType_GzHasEvaluation:            // 8,  //雇主已评介申请岗位
        {
            WorkHistoryController *vc = [[WorkHistoryController alloc] init];
            vc.isFromInfoCenter = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            //工作经历
        }
            break;
                    
        // 跳转到待办事项
//        case WdSystemNoticeType_JkApply:                // 1 兼客申请岗位
        case WdSystemNoticeType_confirWork:             // 80 确认上岗  跳转到待办事项
        {
            [[MainTabBarCtlMgr sharedInstance] showMyApplyCtrlOnCtrl:self];
        }
            break;
        // 人脉王跳转到赏金详情页
        case WdSystemNoticeType_Reward:                // 54：人脉王跳赏金页面广播消息
        { 
            MoneyDetail_VC *vc = [[MoneyDetail_VC alloc] init];
            vc.jobId = sysMsg.job_id.stringValue;
            vc.moneyDetailID = sysMsg.account_money_detail_list_id.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 人脉王跳人脉王页面
        case WdSystemNoticeType_SocialActivistBroadcast:     // 53：人脉王跳人脉王页面广播消息
        {
            JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
            SocialActivist_VC *vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_SocialActivist"];
            vc.jkModel = jkModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        // 跳转委托招聘页面
        case WdSystemNoticeType_SuccessOpenBDService:       // 64: 成功开通委托招聘服务
        {
            NSString *user_token = [XSJNetWork getToken];
            if (!user_token) {
                return;
            }
            
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_HttpServer,kUrl_entrustEmpory];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.title = @"委托招聘";
            vc.url = url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WdSystemNoticeType_EPZaiTaskVerifyPast:           // 71: 雇主通过宅任务审核提醒
        case WdSystemNoticeType_EPZaiTaskVerifyFail:         // 72: 雇主未通过宅任务审核提醒
        case WdSystemNoticeType_missionTimeoutRemind:       // 73: 兼客提交任务截止时间前通知兼客提交任务
        {
            WebView_VC* vc = [[WebView_VC alloc] init];
            NSString* urlStr = [NSString stringWithFormat:@"%@%@",URL_HttpServer,sysMsg.open_url];
            vc.url = urlStr;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WdSystemNoticeType_openUrlMessage:               // 78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
        {
            if (sysMsg.open_url.length && [sysMsg.open_url rangeOfString:@"toMoneyBagPage"].location != NSNotFound) {
                MoneyBag_VC *vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
                [self.navigationController pushViewController:vc animated:YES];
                //钱袋子
                return;
            }
            WebView_VC* vc = [[WebView_VC alloc] init];
            NSRange range = [sysMsg.open_url rangeOfString:@"http"];
            if (range.location == NSNotFound) {
                NSString* urlStr = [NSString stringWithFormat:@"%@%@",URL_HttpServer,sysMsg.open_url];
                vc.url = urlStr;
            }else{
                vc.url = sysMsg.open_url;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case WdSystemNoticeType_interestJob:            //81 意向岗位跳转
        {
//            [UIHelper openInsterJobVCWithRootVC:self];
            IntristJob_VC *viewCtrl = [[IntristJob_VC alloc] init];
            [self.navigationController pushViewController:viewCtrl animated:YES];
            break;
        }
        case WdSystemNoticeType_advanceSalary:               // 82、预支工资推送通知
        {
            WEAKSELF
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                if (globalModel && globalModel.borrowday_advance_salary_url) {
                    WebView_VC *vc = [[WebView_VC alloc] init];
                    NSString *urlStr;
                    NSRange range = [globalModel.borrowday_advance_salary_url rangeOfString:@"?"];
                    if (range.location == NSNotFound){
                        urlStr = [NSString stringWithFormat:@"%@?loginCode=%@",globalModel.borrowday_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@&loginCode=%@",globalModel.borrowday_advance_salary_url,[[XSJUserInfoData sharedInstance] getUserInfo].userPhone];
                    };
                    vc.url = urlStr;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;
        case WdSystemNoticeType_textMessage:                 // 79: 纯文本消息，客户端只是展示下发的message消息即可
            break;
        case WdSystemNoticeType_JopAnswerQuestion:{
//            JobQA_VC *viewCtrl = [[JobQA_VC alloc] init];
//            viewCtrl.jobId = sysMsg.job_id.stringValue;
//            [self.navigationController pushViewController:viewCtrl animated:YES];
            alert = [[JobQAAlert alloc]initWithFrame:[UIScreen mainScreen].bounds];
            alert.alertView.delegate = self;
            [self.view addSubview:alert];
        }
            break;
        
        case WdSystemNoticeType_ServicePersonalInvite:{ //雇主个人服务邀约（跳转服务订单详情）
            [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = NO;
            if (![[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
                [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
            }
            [WDNotificationCenter postNotificationName:ClearPersonaServiceJobNotification object:nil];
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            viewCtrl.url = [NSString stringWithFormat:@"%@%@/%@?entrance=2", URL_HttpServer, KUrl_getServicePersonalJobDetail, sysMsg.service_personal_job_id];
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        case WdSystemNoticeType_ServicePersonalImpoveWorkExperienceNotice:       // 93:个人服务更新案例消息提醒
        {
            WEAKSELF
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalRM) {
                if (globalRM && globalRM.service_personal_apply_url.length) {
                    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                    NSRange range = [globalRM.service_personal_apply_url rangeOfString:@"?"];
                    if (range.location == NSNotFound) {
                        viewCtrl.url = [NSString stringWithFormat:@"%@?service_type_id=%@", globalRM.service_personal_apply_url, sysMsg.service_type_id];
                    }else{
                        viewCtrl.url = [NSString stringWithFormat:@"%@&service_type_id=%@", globalRM.service_personal_apply_url, sysMsg.service_type_id];
                    }
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];
        }
            break;
        case WdSystemNoticeType_InsuranceOrderFail:       // 94:兼职保险存在失败保单
        {
        WEAKSELF
        [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
            if (globalModel && globalModel.wap_url_list.jianke_welfare_salary_url) {
                WebView_VC *vc = [[WebView_VC alloc] init];
                vc.url = globalModel.wap_url_list.jianke_welfare_salary_url;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        }
            break;
        case WdSystemNoticeType_PersonalServiceBackouted:       // 95:个人服务被下架
        {
            WEAKSELF
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                if (globalModel && globalModel.service_personal_apply_url) {
                    WebView_VC *vc = [[WebView_VC alloc] init];
                    vc.url = globalModel.service_personal_url;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;
        case WdSystemNoticeType_PersonalServiceOrderBackouted:       // 96:个人服务需求被下架
        {
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = [NSString stringWithFormat:@"%@%@?service_personal_job_id=%@", URL_HttpServer, KUrl_toServicePersonalJobDetailPage, sysMsg.service_personal_job_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WdSystemNoticeType_ServicePersonalAuditFail:{  // 88:个人服务申请审核不通过
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                if (globalModel && globalModel.service_personal_apply_url) {
                    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                    NSRange range = [globalModel.service_personal_apply_url rangeOfString:@"?"];
                    if (range.location == NSNotFound) {
                        viewCtrl.url = [NSString stringWithFormat:@"%@?service_type_id=%@", globalModel.service_personal_apply_url, sysMsg.service_type_id];
                    }else{
                        viewCtrl.url = [NSString stringWithFormat:@"%@&service_type_id=%@", globalModel.service_personal_apply_url, sysMsg.service_type_id];
                    }
                    [self.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];

        }
            break;
        default:
            break;
    }
}
- (void)alertDelegate:(NSInteger)tag{
    if (tag == 100) {
        alert.hidden = YES;
        [alert.alertView.contentField resignFirstResponder];
    }
    if (tag == 101) {
        if (alert.alertView.contentField.text.length < 1) {
            [UIHelper toast:@"提问内容不能为空"];
            return;
        }
        
        WEAKSELF
        [[UserData sharedInstance] stuJobQuestionWithJobId:alertJobId quesiton:alert.alertView.contentField.text block:^(id obj) {
            [UIHelper toast:@"发送成功"];
            alert.hidden = YES;
            [alert.alertView.contentField resignFirstResponder];
        }];
    }
}
#pragma mark - 双击文本消息，触发这个回调
/**
 *  双击文本消息，触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
//    ELog(@"=====text:%@", message.text);
//    XHDisplayTextViewController* displayTextViewController = [[XHDisplayTextViewController alloc] init];
//    displayTextViewController.message = message;
//    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

/**
 *  点击消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
//点击消息发送者头像
- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
    ELog(@"========点击头像 indexPath : %@", indexPath);
    if (self.messageInputView.hidden) {
        return;
    }
    [self hideAllMenu];
    [self showUserInfoByType:[message bubbleMessageType] andTargetInfo:self.targetInfo];
 
}

//显示用户简历  or 显示雇主简历
- (void)showUserInfoByType:(XHBubbleMessageType)type andTargetInfo:(ImUserInfo*)targetInfo{
    //点击自己的头像不处理
    if (type == XHBubbleMessageTypeSending) {
        ELog(@"=====点击自己的头像：%@", self.selfInfo.accountId);
        return;
    }
    ELog(@"=======targetInfo.accout_type:%@",targetInfo.account_type);
    ELog(@"=======targetInfo.resumeId:%@",targetInfo.resumeId);
    ELog(@"=======targetInfo.accountEntInfoId:%@",targetInfo.accountEntInfoId);
    
    if (targetInfo.account_type.intValue == WDImUserType_Jianke) {
        [self checkJkInfo];
    }else if (targetInfo.account_type.intValue == WDImUserType_Employer){
        [self checkEpInfo];
    }
}

/**
 *  Menu Control Selected Item
 *
 *  @param bubbleMessageMenuSelecteType 点击item后，确定点击类型
 */
- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType{
    ELog(@"=======")
}


/** 查看详情按钮点击事件 */
- (void)xhMessageTableViewCell:(XHMessageTableViewCell *)cell didClickLookupDetailBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath message:(id<XHMessageModel>)message
{
    DLog(@"查看详情");
    [self multiMediaMessageDidSelectedOnMessage:message atIndexPath:indexPath onMessageTableViewCell:cell];
}

/** 打卡按钮点击事件 */
- (void)xhMessageTableViewCell:(XHMessageTableViewCell *)cell didClickReportBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath message:(id<XHMessageModel>)message{
    DLog(@"打卡");
    _isRequest = NO;
    
    WdMessage *wdMessage = (WdMessage *)message;
    ImSystemMsg *sysMsg = wdMessage.obj_id;
    
    NSString *jobId = sysMsg.apply_job_id;
    NSNumber *punchId = sysMsg.punch_the_clock_request_id;
    NSString *punchTime = @([[NSDate date] timeIntervalSince1970] * 1000).description;


    [UIHelper showLoading:YES withMessage:@"正在定位"];
    [[LocateManager sharedInstance] locateWithBlock:^(LocalModel *local) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIHelper showLoading:NO withMessage:@"正在定位, 请稍候"];
            if (!local) {
                [UIHelper showMsg:@"定位失败"];
                return;
            }
            if (_isRequest) {
                return;
            }
            _isRequest = YES;
            NSString *punchLat = local.latitude;
            NSString *punchLng = local.longitude;
            NSString *punchLocation = local.subAddress;
            
            [[UserData sharedInstance] stuPunchTheClockWithJobId:jobId punchId:punchId.description punchTime:punchTime punchLat:punchLat punchLng:punchLng punchLocation:punchLocation block:^(ResponseInfo *response) {

                if (response.success) {
                    [UIHelper toast:@"打卡成功"];
                    sysMsg.isPunched = @(1);
                    btn.enabled = NO;
                    [btn setTitle:@"已完成" forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"v210_lg"] forState:UIControlStateNormal];
                    
                    // 本地存储
                    [WDUserDefaults setObject:@(1) forKey:[NSString stringWithFormat:@"%@_%@", jobId, punchId]];
                    [WDUserDefaults synchronize];
                }
            }];
        });
    }];
}


#pragma mark - XHEmotionManagerView Delegate
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath{
    NSString* str = self.messageInputView.inputTextView.text;
    if (emotion.emotionType == EmotionType_Delete) {
        if (str.length < 1) {
            return;
        }
        str = [str substringToIndex:str.length > 1 ? str.length - 2 : 1];
        self.messageInputView.inputTextView.text = str;
        [self changeSendBtnState];
        return;
    }
    
    if (emotion.emotionType == EmotionType_Emoji) {
        self.messageInputView.inputTextView.text = [NSString stringWithFormat:@"%@%@",str,emotion.emotionPath];
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

#pragma mark - 拼凑会话ID
- (NSString*)makeupLocalConversationId{
    if (self.selfInfo && self.targetInfo) {
        return [self makeupLocalConversationIdWithType:self.selfInfo.account_type.intValue];
    }
    return nil;
}

- (NSString*)makeupLocalConversationIdWithType:(WDImUserType)type{
    if (self.selfInfo && self.targetInfo) {
        NSString* localConversationId = [NSString stringWithFormat:@"%@_%d_%@_%@", self.selfInfo.accountId,type,self.targetInfo.accountId,self.targetInfo.account_type];
        return localConversationId;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
