//
//  DaySelectView.m
//  jianke
//
//  Created by xiaomk on 16/5/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "DaySelectView.h"
#import "WDConst.h"

@interface DaySelectView (){
    CGFloat _butWidth;
    CGFloat _butHeight;
    NSMutableArray* _modelArray;
    NSMutableArray* _btnArray;
}

@end

@implementation DaySelectView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBorderColor:[UIColor XSJColor_grayLine]];
        _butWidth = frame.size.width/8;
        _butHeight = frame.size.height/4;
        _btnArray = [[NSMutableArray alloc] init];

    }
    return self;
    
}

- (void)initUIWithDaySelectModelArray:(NSMutableArray*)array{
    if (!array || array.count == 0) {
        return ;
    }
    _modelArray = array;
    
    if (_btnArray.count == 0) {
        for (NSInteger i = 0; i < _modelArray.count; i++) {
            UIButton* btn = [self creatBtnWithIndex:i];
            [self addSubview:btn];
            [_btnArray addObject:btn];
        }
    }else{
        for (NSInteger i = 0; i < _btnArray.count; i++) {
            if (_modelArray.count > i) {
                UIButton* btn = [_btnArray objectAtIndex:i];
                DaySelectModel* model = [_modelArray objectAtIndex:i];
                btn.selected = model.isSelect;
            }
        }
    }
   

}

- (UIButton*)creatBtnWithIndex:(NSInteger)index{
    
    DaySelectModel* model = [_modelArray objectAtIndex:index];
    
    NSInteger row = index % 4;
    NSInteger list = index / 4;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_butWidth*list, _butHeight*row, _butWidth, _butHeight);
    [btn setBorderWidth:0.7 andColor:[UIColor XSJColor_grayLine]];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor XSJColor_tGray] forState:UIControlStateNormal];
    
    if (model.title && model.title.length > 0) {
        [btn setTitle:model.title forState:UIControlStateNormal];
    }

    if (model.value && model.value > 0) {
        [btn setBackgroundImage:[UIImage imageNamed:@"public_bg_select"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"public_bg_select"] forState:UIControlStateHighlighted];
        
        [btn setImage:[UIImage imageNamed:@"public_icon_select"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"public_icon_select"] forState:UIControlStateHighlighted];
    }
    btn.selected = model.isSelect;
    
    btn.enabled = model.isEnable;
    btn.tag = index;
    
    [btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnOnclick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    DaySelectModel* model = [_modelArray objectAtIndex:sender.tag];
    model.isSelect = sender.selected;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


@implementation DaySelectModel


- (void)setDiselect;{
    _isSelect = NO;
}

//- (instancetype)init{
//    ELog(@"===DaySelectModel");
//    self = [super init];
//    if (self) {
//        self.isEnable = YES;
//    }
//    return self;
//}
@end
