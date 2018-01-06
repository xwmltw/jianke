//
//  TableView_handleOtherTouch.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollView_handleOtherTouch.h"

@interface TableView_handleOtherTouch : UITableView

@property (assign, nonatomic) id<HandleOtherTouchDelegate> touch_delegate;

@end
