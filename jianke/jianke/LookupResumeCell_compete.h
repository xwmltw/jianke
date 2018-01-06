//
//  LookupResumeCell_compete.h
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LookupResumeCell_compete;
@protocol LookupResumeCell_competeDelegate <NSObject>

- (void)LookupResumeCell_compete:(NSInteger )tag;

@end

@interface LookupResumeCell_compete : UITableViewCell

@property (nonatomic, weak) id<LookupResumeCell_competeDelegate> delegate;
- (void)setModel:(id)model;

@end
