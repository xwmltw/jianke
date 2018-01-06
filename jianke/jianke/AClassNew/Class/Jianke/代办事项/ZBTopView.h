//
//  ZBTopView.h
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class ZBTopView;
@protocol ZBTopViewDelegate <NSObject>

- (void)zbTopView:(ZBTopView *)view btnAction:(BtnOnClickActionType)actionType;

@end

@interface ZBTopView : UIView

@property (nonatomic, weak) id<ZBTopViewDelegate> delegate;
- (void)setModel:(id)model;

@end
