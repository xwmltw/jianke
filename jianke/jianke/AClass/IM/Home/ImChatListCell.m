//
//  ImChatListCell.m
//  jianke
//
//  Created by xiaomk on 15/10/22.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ImChatListCell.h"
#import "DateHelper.h"
#import "ImDataManager.h"
#import "WDConst.h"
#import "WDChatView_VC.h"
#import "IMImgTextFunc_VC.h"
#import "DataBaseTool.h"


@interface ImChatListCell(){
    UIImage* _imgNewFriend;
}
@property (nonatomic, strong) ImBusiDataObject* dataObj;
@property (nonatomic, strong) ImUserInfo* selfInfo;

@end

@implementation ImChatListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"ImChatListCell";
    ImChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"ImChatListCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)refreshWithData:(ConversationModel*)lcModel{
    if (lcModel) {
        self.labDateTime.text = [DateHelper getTimeRangeWithSecond:@(lcModel.lastModifiedTime.longLongValue * 0.001)];
        
        LocalMessageModel* lastMsgModel = [DataBaseTool lastMessageOfConversationWithLocalConversationId:lcModel.localConversationId];
        
        switch (lcModel.conversation.conversationType) {
            case ConversationType_GROUP:
            {
                self.labName.text = lcModel.groupName;
                RCMessage* rcMsg = lastMsgModel.RcMessage;
                ImPacket* packet = [ImDataManager packetFromRCMessage:rcMsg];
                if (packet) {
                    self.dataObj = packet.dataObj;
                    self.labContent.text = self.dataObj.notifyContent;
                    self.imgHead.image = [UIImage imageNamed:GROUP_IMG];
                }
            }
                break;
            case ConversationType_PRIVATE:
            {
                RCMessage* rcMsg = lastMsgModel.RcMessage;
                if ([lcModel.targetId isEqualToString:CRMUserId] && !rcMsg) {
                    self.labContent.text = @"欢迎使用兼客CRM系统";
                }
                ImPacket* packet = [ImDataManager packetFromRCMessage:rcMsg];
                if (packet) {
                    self.dataObj = packet.dataObj;
                    if ([self.dataObj.notifyContent hasPrefix:@"兼客团队"]) {
                        NSMutableString *attStr = [self.dataObj.notifyContent mutableCopy];
                        [attStr replaceCharactersInRange:[self.dataObj.notifyContent rangeOfString:@"兼客团队"] withString:@"系统通知"];
                        self.dataObj.notifyContent = [attStr copy];
                    }
                    self.labContent.text = self.dataObj.notifyContent;
                }
                if (lcModel.targetShowName && lcModel.targetHeadUrl.length > 0) {
                    if ([lcModel.targetShowName isEqualToString:@"兼客团队"]) {
                        lcModel.targetShowName = @"系统通知";
                    }
                    self.labName.text = lcModel.targetShowName;
                    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:lcModel.targetHeadUrl] placeholderImage:[UIHelper getDefaultHead]];
                }else{
                    WEAKSELF
                    [ImDataManager getUserInfoById:lcModel.targetId withType:(int)lcModel.targetType allowCache:YES completion:^(ImUserInfo *targetInfo) {
                        if (targetInfo) {
                            weakSelf.labName.text = [targetInfo getShowName];
                            [weakSelf.imgHead sd_setImageWithURL:[NSURL URLWithString:targetInfo.headUrl] placeholderImage:[UIHelper getDefaultHead]];
                        }
                    }];
                }
            }
                break;
            case ConversationType_CUSTOMERSERVICE:
            {
                RCMessageContent* content;
                NSArray* msgAry = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_CUSTOMERSERVICE targetId:lcModel.rcConversationId count:1];
                if (msgAry && msgAry.count > 0) {
                    RCMessage* kefuLastMsg = [msgAry objectAtIndex:0];
                    content = kefuLastMsg.content;
                    self.labDateTime.text = [DateHelper getTimeRangeWithSecond:@(kefuLastMsg.sentTime * 0.001)];
                }else if (lastMsgModel){
                    content = lastMsgModel.RcMessage.content;
                }
                if (content) {
                    if ([content isKindOfClass:[RCTextMessage class]]) {
                        RCTextMessage* textMsg = (RCTextMessage*)content;
                        if (textMsg) {
                            NSMutableString *msgStr = [[NSMutableString alloc] initWithString:textMsg.content];
                            
                            NSRange range1 = [msgStr rangeOfString:@"   → 雇主"];
                            NSRange range2 = [msgStr rangeOfString:@"   → 兼客"];
                            if (range1.location != NSNotFound) {
                                [msgStr deleteCharactersInRange:range1];
                            }else if (range2.location != NSNotFound){
                                [msgStr deleteCharactersInRange:range2];
                            }
                            NSString *nameKefu = @"客服MM";
                            if ([msgStr rangeOfString:nameKefu].location != NSNotFound) {
                                [msgStr replaceCharactersInRange:[msgStr rangeOfString:nameKefu] withString:@"客服牛傲天"];
                            }
                            self.labContent.text = msgStr;
                        }
                       
                    }else if ([content isKindOfClass:[RCVoiceMessage class]]){
                        self.labContent.text = @"[语音]";
                    } else if ([content isKindOfClass:[RCImageMessage class]]) {
                        self.labContent.text = @"[图片]";
                    } else if ([content isKindOfClass:[RCLocationMessage class]]) {
                        self.labContent.text = @"[位置]";
                    }
                }else{
                    self.labContent.text = kefuFistText;
                }
                self.labName.text = KEFU_NAME;
                self.imgHead.image = [UIImage imageNamed:KEFU_IMG];
            }
                break;
            case ConversationType_SYSTEM:
            {
                ELog(@"====会有这种类型的吗 --- ConversationType_SYSTEM");
            }
            default:
                break;
        }
        
        [self.imgHead setCornerValue:25.0f];

        //禁止收消息  铃铛图标
        self.imgLingdang.hidden = YES;
        self.layoutImgLingdangWidth.constant = 0;
        if (lcModel.isSoundOff) {
            self.imgLingdang.hidden = NO;
            self.layoutImgLingdangWidth.constant = 16;
        }else{
            self.imgLingdang.hidden = YES;
            self.layoutImgLingdangWidth.constant = 0;
        }
        
        //未读数量
        self.labUnRead.hidden = YES;
        if (lcModel.unReadMsgCount.intValue > 0) {
            self.labUnRead.hidden = NO;
        }
        [self.labUnRead setCornerValue:9];

        if (lcModel.unReadMsgCount.intValue > 0) {
            NSString* numStr;
            if (lcModel.unReadMsgCount.intValue > 99) {
                numStr = @"99+";
            }else{
                numStr = [NSString stringWithFormat:@"%@",lcModel.unReadMsgCount];
            }
            self.labUnRead.text = numStr;
        }
//        //无未读数量 置灰
//        if (lcModel.unReadMsgCount.intValue <= 0) {
//            self.labName.textColor = MKCOLOR_RGB(154, 154, 154);
//            self.labContent.textColor = MKCOLOR_RGB(154, 154, 154);
//        }
        self.labContent.textColor = MKCOLOR_RGB(154, 154, 154);
    }
}

- (void)clearUnreadNum{
    self.labUnRead.text = @"";
    self.labUnRead.hidden = YES;
}

- (void)handleSelect:(UIViewController*)vc andConversationModel:(ConversationModel*)lcModel{
    ELog(@"====self.dataObj.bizType.intValue:%i",self.dataObj.bizType.intValue);
    
    lcModel.unReadMsgCount = @(0);
    [self clearUnreadNum];
    
//    if (lcModel.conversation.conversationType == ConversationType_CUSTOMERSERVICE) {
    if (lcModel.conversation.conversationType == ConversationType_PRIVATE || lcModel.conversation.conversationType == ConversationType_GROUP){
        if (self.dataObj.bizType.intValue == ImBizType_ImageAndTextMessage) {
            ELog(@"====图文消息");
            IMImgTextFunc_VC* chatVC = [[IMImgTextFunc_VC alloc] init];
            [self handleOthersInfoWithCompletion:^(ImUserInfo *info) {
                chatVC.accountId = info.accountId;
                chatVC.accountType = info.account_type.intValue;
                chatVC.hidesBottomBarWhenPushed = YES;
                [vc.navigationController pushViewController:chatVC animated:YES];
            }];
        }else{
            ELog(@"=========进入 对话界面");
            WDChatView_VC* chatVC = [[WDChatView_VC alloc] init];
            if ([self.dataObj isSystemMessage]) {
                ELog(@"=====系统消息");
                chatVC.messageInputView.hidden = YES;
                
                ImSystemMsg* sysMsg = [self.dataObj getMessageContent];
                ImUserInfo* sysInfo = [[ImUserInfo alloc] init];
                sysInfo.accountId = self.dataObj.fromUser;
                sysInfo.headUrl = sysMsg.headUrl;
                sysInfo.accountName = sysMsg.name;
                sysInfo.uuid = self.conversation.targetId;
                
                [ImDataManager sharedInstance].systemInfo = sysInfo;
                chatVC.accountId = sysInfo.accountId;
                chatVC.accountType = self.dataObj.fromType.intValue;
                chatVC.hidesBottomBarWhenPushed = YES;
                [vc.navigationController pushViewController:chatVC animated:YES];
                return;
            }
            
            chatVC.accountId = lcModel.targetId;
            chatVC.accountType = (int)lcModel.targetType;
            
            if (lcModel.conversation.conversationType == ConversationType_GROUP) {
                chatVC.isGroupChat = YES;
                chatVC.accountId = lcModel.targetId;
                chatVC.accountType = (int)lcModel.targetType;
            }
            chatVC.isFromIM = YES;
            chatVC.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:chatVC animated:YES];
        }
    }
    
}

- (void)handleOthersInfoWithCompletion:(void(^)(ImUserInfo* info))completion {
    NSString* accountId;
    int type;
    NSString* accountIdSelf = [ImDataManager sharedInstance].selfInfo.accountId;
    if ([self.dataObj.fromUser isEqualToString:accountIdSelf]) {
        accountId = self.dataObj.toUser;
        type = self.dataObj.toType.intValue;
    } else {
        accountId = self.dataObj.fromUser;
        type = self.dataObj.fromType.intValue;
    }
    
    [ImDataManager getUserInfoById:accountId withType:type allowCache:YES completion:^(ImUserInfo *userInfoNew) {
        MKBlockExec(completion,userInfoNew)
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
