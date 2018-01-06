//
//  MysubscribleCell.h
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPModel, MysubscribleCell;

@protocol MysubscribleCellDelegate <NSObject>

- (void)mysubscribleCell:(MysubscribleCell *)cell atIndexPtah:(NSIndexPath *)indexPath;

@end

@interface MysubscribleCell : UITableViewCell

@property (nonatomic, weak) id<MysubscribleCellDelegate> delegate;
- (void)setEpModel:(id)epModel atIndexPath:(NSIndexPath *)indexPath;

@end
