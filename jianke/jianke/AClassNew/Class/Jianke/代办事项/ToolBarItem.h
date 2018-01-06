//
//  ToolBarItem.h
//  jianke
//
//  Created by yanqb on 2016/11/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XZRedPointTag 200

@class ToolBarItem;
@protocol ToolBarItemDelegate <NSObject>

- (void)toolBarItem:(ToolBarItem *)item selecedIndex:(NSInteger)selectedIndex;

@end

@interface ToolBarItem : UIView

@property (nonatomic, weak) id<ToolBarItemDelegate> delegate;
@property (nonatomic, strong) UIView *budgeView;
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *selectedColor;

- (void)setItemTag:(NSInteger)tag;

@end
