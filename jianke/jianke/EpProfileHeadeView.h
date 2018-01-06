//
//  EpProfileHeadeView.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class EpProfileHeadeView;
@protocol EpProfileHeadeViewDelegate <NSObject>

- (void)epProfileHeadeView:(EpProfileHeadeView *)headerView actionType:(BtnOnClickActionType)actionType;
- (void)viewHeadImg:(UIImageView *)imageView;

@end

@interface EpProfileHeadeView : UIView

@property (nonatomic, weak) id<EpProfileHeadeViewDelegate> delegate;
@property (nonatomic, weak) UILabel *labName;
- (void)setEpModel:(id)epModel;

@end
