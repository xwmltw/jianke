//
//  XZDatePickerView.m
//  jianke
//
//  Created by 徐智 on 2017/5/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "XZDatePickerView.h"

@interface XZDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation XZDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"superview" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.array.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *array = [self.array objectAtIndex:component];
    return array.count;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    id model = [change objectForKey:NSKeyValueChangeNewKey];
    if (model) {
        self.delegate = self;
    }
}

#pragma mark - lazy
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"superview"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
