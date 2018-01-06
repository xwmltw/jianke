//
//  BtnView.h
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DataType) {
    
    DataTypeJobClass = 0,
    DataTypeTopic
};

@class BtnView, DataBtn;

@protocol BtnViewDelegate <NSObject>

- (void)btnView:(BtnView *)btnView didClickBtn:(DataBtn *)btn;

@end



@interface BtnView : UIView

@property (nonatomic, weak) id<BtnViewDelegate> delegate;

- (instancetype)initWithWidth:(CGFloat)width dataType:(DataType)type dataArray:(NSArray *)dataArray;

@end
