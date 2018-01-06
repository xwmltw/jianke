//
//  MenuView.h
//  jianke
//
//  Created by fire on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView, MenuBtn;

@protocol MenuViewDelegate <NSObject>
@required
- (void)menuView:(MenuView *)menuView didClickBtn:(MenuBtn *)btn;
@end


@interface MenuView : UIView

@property (nonatomic, weak) id<MenuViewDelegate> delegate;

- (instancetype)initWithModelArray:(NSArray *)modelArray;

@end
