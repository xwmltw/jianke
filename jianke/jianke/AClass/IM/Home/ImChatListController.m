//
//  IMChatListController.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "IMChatListController.h"
#import "TableView_handleOtherTouch.h"
#import "ImDataManager.h"
#import "ImChatListCell.h"
#import "WDChatView_VC.h"
#import "KefuChatView_VC.h"
#import "DataBaseTool.h"
#import "ConversationModel.h"
#import "WebView_VC.h"

@interface IMChatListController(){
    UIView* _noDataView;
    NSMutableArray* _arrayRealShow;
    BOOL _haveKefu;

}

@property (nonatomic, strong) ImUserInfo* selfInfo;
@end

@implementation IMChatListController

- (void)viewWillAppear{
    [super viewWillAppear];
    [self reloadData];
    [WDNotificationCenter addObserver:self selector:@selector(onNewRcMessage:) name:OnNewRCMessageNotify object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(updateConversation) name:IMNotification_updateConversationList object:nil];
    [[ImDataManager sharedInstance] reloadUnReadCount];
}

- (void)setupListView{
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    self.tableView = [[TableView_handleOtherTouch alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    _arrayRealShow = [[NSMutableArray alloc] init];
    
    
    BOOL isHideHelpView = [[UserData sharedInstance] getUserHideHelpState];
    if (isHideHelpView) {
        return;
    }
    
    UIView* helpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    helpView.backgroundColor = MKCOLOR_RGBA(0, 118, 255, 0.03);
    
    UIButton* btnHeadBx = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [btnHeadBx setBackgroundColor:[UIColor clearColor]];
    [btnHeadBx addTarget:self action:@selector(btnBxOnclick) forControlEvents:UIControlEventTouchUpInside];
    [helpView addSubview:btnHeadBx];
    
    // 关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"v3_public_close_blue"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(-6, 6, 6, 0);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [helpView addSubview:closeBtn];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = MKCOLOR_RGB(222, 236, 251);
    [helpView addSubview:lineView];
    
    UILabel* bxLab = [[UILabel alloc] init];
    bxLab.textAlignment = NSTextAlignmentLeft;
    bxLab.numberOfLines = 1;
    bxLab.font = [UIFont systemFontOfSize:16];
    bxLab.adjustsFontSizeToFitWidth = YES;
    bxLab.minimumScaleFactor = 12;
    bxLab.textColor = MKCOLOR_RGBA(0, 118, 255, 1);
    
    NSNumber *loginType = [[UserData sharedInstance] getLoginType];
    if (loginType.integerValue == 1) { // 雇主
        bxLab.text = @"想招人不知道怎么做？戳这里！";
    } else { // 兼客
        bxLab.text = @"想找兼职不知道怎么做？戳这里!";
    }
    [helpView addSubview:bxLab];
    self.tableView.tableHeaderView = helpView;

    [bxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(helpView.mas_centerY);
        make.left.equalTo(helpView.mas_left).offset(16);
        make.right.equalTo(helpView.mas_right).offset(8);
    }];
}

#pragma mark - ***** 跟新会话列表 ******
- (void)updateConversation{
    WEAKSELF
    [UserData delayTask:0.1 onTimeEnd:^{
        [weakSelf reloadData];
    }];
}

#pragma mark - ***** 融云新消息来的时候 ******
- (void)onNewRcMessage:(NSNotification*)note{
    ELog(@"====im 您有新的消息，请注意查收");
    if (!note.object) {
        return;
    }
    WEAKSELF
    [UserData delayTask:0.1 onTimeEnd:^{
        [weakSelf reloadData];
    }];
}

#pragma mark - ***** 加载数据 ******
- (void)reloadData{
    if (![[ImDataManager sharedInstance] isUserLogin]) {
        return;
    }
    self.selfInfo = [ImDataManager sharedInstance].selfInfo;
    //跟新会话列表
    WEAKSELF
    [[ImDataManager sharedInstance] updateLocalMsgDataWithRCConversation:^(BOOL isSuccess) {
        //从数据库中获取会话列表
        NSArray* rccArray = [DataBaseTool conversationArrayWithUserId:weakSelf.selfInfo.accountId userType:weakSelf.selfInfo.account_type.integerValue withQueryParam:nil];
        weakSelf.arrayData = rccArray;
        [weakSelf reloadList];
    }];
}

- (void)reloadList{
    _arrayRealShow = [self.arrayData mutableCopy];
    WEAKSELF
    
    [ImDataManager getUserInfoById:CRMUserId withType:WDImUserType_Func allowCache:YES completion:^(GlobalFeatureInfo *userInfo) {
        if (weakSelf.selfInfo.account_type.integerValue == WDLoginType_Employer) {
            EPModel* epModel = [[UserData sharedInstance] getEpModelFromHave];
            //如果是BD 账号
            if (epModel.is_bd_bind_account.integerValue == 1) {
                [ImDataManager getUserInfoById:CRMUserId withType:WDImUserType_Func allowCache:YES completion:^(GlobalFeatureInfo *userInfo) {
                    
                    if (userInfo) {
                        NSString* sign = [NSString stringWithFormat:@"%@_%ld_%@_%d",self.selfInfo.accountId,(long)WDLoginType_Employer,CRMUserId,WDImUserType_Func];
                        ConversationModel* cModel = [DataBaseTool conversationModelWithLocalConversationId:sign];
                        if (!cModel) {
                            ConversationModel* lcModel = [[ConversationModel alloc] init];
                            lcModel.userId = weakSelf.selfInfo.accountId;
                            lcModel.userType = WDLoginType_Employer;
                            lcModel.targetId = CRMUserId;
                            lcModel.targetType = WDImUserType_Func;
                            lcModel.targetShowName = userInfo.funName;
                            lcModel.targetHeadUrl = userInfo.headUrl;
                            lcModel.unReadMsgCount = @(0);
                            
                            lcModel.rcConversationId = userInfo.uuid;
                            lcModel.lastModifiedTime = [NSString stringWithFormat:@"%lld",[DateHelper getTimeStamp]];
                            lcModel.isHide = NO;
                            lcModel.localConversationId = sign;
                            
                            RCTextMessage* lastMsg = [[RCTextMessage alloc] init];
                            lastMsg.content = userInfo.desc;
                            
                            RCConversation* crmRCC = [[RCConversation alloc] init];
                            crmRCC.unreadMessageCount = 0;
                            crmRCC.conversationType = ConversationType_PRIVATE;
                            crmRCC.targetId = CRMUserId;
                            crmRCC.objectName = @"RC:TxtMsg";
                            crmRCC.sentTime = [DateHelper getTimeStamp];
                            crmRCC.lastestMessage = lastMsg;
                            
                            lcModel.conversation = crmRCC;
                            
                            [DataBaseTool saveImConversation:lcModel];
                            [_arrayRealShow addObject:lcModel];
                            
                        }
                        MKDispatch_main_async_safe(^{
                            [weakSelf.tableView reloadData];
                        });

                    }
                    
                }];
                return;
            }
        }
        MKDispatch_main_async_safe(^{
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - ***** tableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImChatListCell* cell = [ImChatListCell cellWithTableView:tableView];

    if (indexPath.row >= _arrayRealShow.count) {
        return cell;
    }
    ConversationModel* data = [_arrayRealShow objectAtIndex:indexPath.row];
    [cell refreshWithData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConversationModel* lcModel = [_arrayRealShow objectAtIndex:indexPath.row];
    RCConversation* conversation = lcModel.conversation;
    
    if (conversation.conversationType == ConversationType_CUSTOMERSERVICE ) {
        NSString* JKkefuLocalConversationId = [[ImDataManager sharedInstance] getKefuLocalConversationIdwhitUsertype:WDLoginType_JianKe];
        NSString* EPkefuLocalConversationId = [[ImDataManager sharedInstance] getKefuLocalConversationIdwhitUsertype:WDLoginType_Employer];
        [DataBaseTool clearUnreadMessageWithLocalConversationId:JKkefuLocalConversationId];
        [DataBaseTool clearUnreadMessageWithLocalConversationId:EPkefuLocalConversationId];
        KefuChatView_VC *chatViewController = [ImDataManager getKeFuChatVC];
        chatViewController.hidesBottomBarWhenPushed = YES;
        [self.home.navigationController pushViewController:chatViewController animated:YES];
        return;
    }else if (conversation.conversationType == ConversationType_PRIVATE || conversation.conversationType == ConversationType_GROUP){
        [DataBaseTool clearUnreadMessageWithLocalConversationId:lcModel.localConversationId];
        ImChatListCell* cell = (ImChatListCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell handleSelect:self.home andConversationModel:(ConversationModel*)lcModel];    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayRealShow.count ? _arrayRealShow.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 82, 0, 0)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 82, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 82, 0, 0)];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除该聊天";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel* lcModel = [_arrayRealShow objectAtIndex:indexPath.row];
    if ([self isKefuConversation:lcModel]) {
        [UIHelper toast:@"该聊天无法被删除"];
        [self.tableView setEditing:NO animated:YES];
    }else{
        if ([DataBaseTool deletePrivateConversationWithId:lcModel.localConversationId]) {
            [[ImDataManager sharedInstance] reloadUnReadCount];
            [_arrayRealShow removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//            [self.tableView reloadData];
        }else{
            [UIHelper toast:@"删除失败,请重试!"];
        }
    }
}


#pragma mark - 删除业务

- (void)deleteConversation{
    
}

#pragma mark - ***** 操作 处理 ******
/** 关闭 帮助 条 */
- (void)closeBtnClick{
    [[UserData sharedInstance] setUserHideHelpState:YES];
    self.tableView.tableHeaderView = nil;
}

/** 帮助 跳转 */
- (void)btnBxOnclick{
    NSString *uri;
    NSNumber *loginType = [[UserData sharedInstance] getLoginType];
    if (loginType.integerValue == 1) { // 雇主
        uri = kUrl_epHelper;
    } else { // 兼客
        uri = kUrl_jkHelper;
    }
    
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, uri];
    vc.hidesBottomBarWhenPushed = YES;
    [self.home.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isKefuConversation:(ConversationModel *)lcModel{
    return [lcModel.rcConversationId isEqualToString:KeFuMMId];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [WDNotificationCenter removeObserver:self];
}

@end
