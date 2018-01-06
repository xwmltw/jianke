//
//  EditeResumeCell_position.h
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKModel, EditeResumeCell_position;

@protocol EditeResumeCell_positionDelegate <NSObject>

- (void)EditeResumeCell_position:(EditeResumeCell_position *)cell;

@end

@interface EditeResumeCell_position : UITableViewCell

@property (nonatomic, weak) id<EditeResumeCell_positionDelegate> delegate;
@property (nonatomic, strong) JKModel *jkModel;

@end
