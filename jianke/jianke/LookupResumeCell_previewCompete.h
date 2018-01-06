//
//  LookupResumeCell_previewCompete.h
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LookupResumeCell_previewCompete;
@protocol LookupResumeCell_previewCompeteDelegate <NSObject>

- (void)LookupResumeCell_previewCompete:(LookupResumeCell_previewCompete *)cell;

@end

@interface LookupResumeCell_previewCompete : UITableViewCell

@property (nonatomic, weak) id<LookupResumeCell_previewCompeteDelegate> delegate;  
- (void)setModel:(id)model;

@end
