//
//  IMImgTextFunc_VC.m
//  jianke
//
//  Created by xiaomk on 15/12/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "IMImgTextFunc_VC.h"
#import "WDConst.h"
#import "IMImgTextFuncCell.h"
#import "ImUserInfo.h"
#import "ImDataManager.h"

@interface IMImgTextFunc_VC ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray* _datasArray;
}

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) ImUserInfo* targetInfo;
@property (nonatomic, strong) RCConversation* conversation;

@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation IMImgTextFunc_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor XSJColor_grayDeep];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 370;
    self.tableView.backgroundColor = [UIColor XSJColor_grayDeep];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    if (self.targetInfo) {
        self.accountId = self.targetInfo.accountId;
        self.accountType = self.targetInfo.account_type.intValue;
    }
    WEAKSELF
    [ImDataManager getUserInfoById:self.accountId withType:self.accountType allowCache:YES completion:^(ImUserInfo *userInfo) {
        if (userInfo) {
            weakSelf.targetInfo = userInfo;
            ELog(@"====targetInfo:%@", [userInfo simpleJsonString]);
            [weakSelf setUpChatUI];
        }
    }];
    [ImDataManager getUserInfoById:self.accountId withType:self.accountType allowCache:NO completion:nil];
}

- (void)setUpChatUI{
    self.conversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:self.targetInfo.uuid];
    if (self.conversation == nil) {
        self.conversation = [[RCConversation alloc] init];
        self.conversation.targetId = self.targetInfo.uuid;
        self.conversation.conversationType = ConversationType_PRIVATE;
    }
    self.title = [self.targetInfo getShowName];
    
    [self loadDataSource];
}

#pragma mark - 从 rc 获取消息列表
- (void)loadDataSource{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //从 RC 获取消息 列表
        NSArray* array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:self.conversation.targetId count:PageNum];
        if (weakSelf.messages == nil) {
            weakSelf.messages = [[NSMutableArray alloc] init];
        }
        
        for (RCMessage* msg in array.reverseObjectEnumerator) {
            
            //                ImPacket* packet = [ImDataManager packetFromRCMessage:msg];
            //                if (!packet) {
            //                    continue;
            //                }
            //                ELog(@"==消息解析=pack:%@",[packet simpleJsonString]);
            
            if (msg.conversationType != ConversationType_CUSTOMERSERVICE) {
                ImPacket* packet = [ImDataManager packetFromRCMessage:msg];
                if (!packet) {
                    continue;
                }
                ELog(@"==消息解析=pack:%@",[packet simpleJsonString]);
                
                if (packet.dataObj.toType == [ImDataManager sharedInstance].selfInfo.account_type || packet.dataObj.toType.integerValue == 4) {
//                    NSDate* date = [NSDate dateWithTimeIntervalSince1970:packet.dataObj.sendTime.longLongValue/1000];
                    ImMessage* imMsg = [packet.dataObj getMessageContent];
                    imMsg.sendTime = packet.dataObj.sendTime;
                    if ([imMsg isKindOfClass:[ImImgAndTextMessage class]]) {
                        ImImgAndTextMessage* msg = (ImImgAndTextMessage*)imMsg;
                        [weakSelf.messages addObject:msg];
                    }
                    
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

//- (WdMessage*)messageFromRcMsg:(RCMessage*)rcmsg{
//    WdMessage* obj = [ImDataManager getMessageByRCMessage:rcmsg];
//    if (obj) {
//        obj.avatarUrl = [self.targetInfo getHead];
//        return obj;
//    }
//    return nil;
//}

- (void)scrollToBottomAnimated:(BOOL)animated {
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
//    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IMImgTextFuncCell* cell = [IMImgTextFuncCell cellWithTableView:tableView];
    if (self.messages.count <= indexPath.row) {
        return cell;
    }
    ImImgAndTextMessage* model = [self.messages objectAtIndex:indexPath.row];
    [cell refreshWithData:model and:self];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ImImgAndTextMessage* model = [self.messages objectAtIndex:indexPath.row];
//    return model.cellHeight;
    
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        return 0;
    }else{
        return cell.frame.size.height;
    }//    return 284;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages ? self.messages.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
