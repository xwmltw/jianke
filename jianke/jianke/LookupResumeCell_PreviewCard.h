//
//  LookupResumeCell_PreviewCard.h
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupResumeCell_Info.h"

@interface LookupResumeCell_PreviewCard : UITableViewCell

@property (nonatomic, assign) LookupResumeCellType cellType;
- (void)setModel:(id)model;

@end
