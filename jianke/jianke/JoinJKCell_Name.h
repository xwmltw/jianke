//
//  JoinJKCell_Name.h
//  jianke
//
//  Created by yanqb on 2016/12/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JoinJKCell_Name;
@protocol JoinJKCell_NameDelegate <NSObject>

- (void)joinJKCell:(JoinJKCell_Name *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface JoinJKCell_Name : UITableViewCell

@property (nonatomic, weak) id<JoinJKCell_NameDelegate> delegate;

- (void)setModel:(id)model;

@end
