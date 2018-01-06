//
//  LookupResumeHeaderView.h
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LookupResumeHeaderViewActionType) {
    LookupResumeHeaderViewActionType_compete,
    LookupResumeHeaderViewActionType_break,
};

@class LookupResumeHeaderView;
@protocol LookupResumeHeaderViewDelegate <NSObject>

- (void)LookupResumeHeaderView:(LookupResumeHeaderView *)headerView actionType:(LookupResumeHeaderViewActionType)actionType;

@end

@interface LookupResumeHeaderView : UIView

@property (nonatomic, weak) id<LookupResumeHeaderViewDelegate> delegate;
- (void)setModel:(id)model isLookOther:(BOOL)isLookOther;

@end
