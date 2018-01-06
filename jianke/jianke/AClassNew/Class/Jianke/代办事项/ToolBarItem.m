//
//  ToolBarItem.m
//  jianke
//
//  Created by yanqb on 2016/11/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ToolBarItem.h"
#import "WDConst.h"

@interface ToolBarItem ()

@property (nonatomic, strong) UIButton *button;


@end

@implementation ToolBarItem

- (void)setButtonTag:(NSInteger)tag{
    self.button.tag = tag;
}

- (void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    [self.button setTitle:itemTitle forState:UIControlStateNormal];
}

- (void)setItemTag:(NSInteger)tag{
    self.tag = tag;
    self.button.tag = tag;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self.button setTitleColor:color forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    [self.button setTitleColor:selectedColor forState:UIControlStateNormal];
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_button addTarget:self action:@selector(toolBarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _button;
}

- (UIView *)budgeView{
    if (!_budgeView) {
        _budgeView = [[UIView alloc] init];
        [_budgeView setCornerValue:5.0f];
        _budgeView.backgroundColor = [UIColor XSJColor_middelRed];
        _budgeView.hidden = YES;
        [self addSubview:_budgeView];
        [_budgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@10);
            make.bottom.equalTo(_button.titleLabel.mas_top).offset(5);
            make.left.equalTo(_button.titleLabel.mas_right);
        }];
    }
    return _budgeView;
}

- (void)toolBarBtnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolBarItem:selecedIndex:)]) {
        [self.delegate toolBarItem:self selecedIndex:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
