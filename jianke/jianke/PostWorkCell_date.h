//
//  PostWorkCell_date.h
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class PostWorkCell_date;

@protocol PostWorkCell_dateDelegate <NSObject>

- (void)PostWorkCell_date:(PostWorkCell_date *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface PostWorkCell_date : UITableViewCell

@property (nonatomic, weak) id<PostWorkCell_dateDelegate> delegate;
- (void)setModel:(id)model;

@end
