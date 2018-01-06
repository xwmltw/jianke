//
//  EditQuickReplyCell.h
//  jianke
//
//  Created by xiaomk on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EQRMsgModel.h"

@protocol EditQuickReplyDelegate <NSObject>

- (void)eqrCell_btnDelOnclickWithIndexPath:(NSIndexPath*)indexPath;
- (void)eqrCell_editMsgWithIndexPath:(NSIndexPath*)indexPath msg:(NSString*)msg;

@end

@interface EditQuickReplyCell : UITableViewCell
@property (nonatomic, assign) id <EditQuickReplyDelegate> deletate;
- (void)refreshWithData:(NSString*)msg andIndexPath:(NSIndexPath*)indexPath;
@end
