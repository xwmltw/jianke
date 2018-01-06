//
//  ImChatListCell.h
//  jianke
//
//  Created by xiaomk on 15/10/22.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImConst.h"
#import "ConversationModel.h"

@interface ImChatListCell : UITableViewCell


@property (weak, nonatomic) RCConversation* conversation;

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;  //头像
@property (weak, nonatomic) IBOutlet UILabel *labDateTime;  //时间
@property (weak, nonatomic) IBOutlet UILabel *labName;      //名字
@property (weak, nonatomic) IBOutlet UILabel *labContent;   //最后一条消息
@property (weak, nonatomic) IBOutlet UILabel *labUnRead;    //未读数量

@property (weak, nonatomic) IBOutlet UIImageView *imgLingdang; //静音铃铛
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgLingdangWidth;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data;

//- (void)handleSelect:(UIViewController*)vc;
- (void)handleSelect:(UIViewController*)vc andConversationModel:(ConversationModel*)lcModel;


@end
