//
//  EditResumeCell_name.h
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKModel, EditResumeCell_name;

@protocol EditResumeCell_nameDelegate <NSObject>

- (void)EditResumeCell_name:(NSUInteger )tag;

@end

@interface EditResumeCell_name : UITableViewCell

@property (nonatomic, weak) id<EditResumeCell_nameDelegate> delegate;
- (void)setModel:(JKModel *)model;

@end
