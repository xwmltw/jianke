//
//  ConditionSheet.m
//  jianke
//
//  Created by fire on 15/11/19.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ConditionSheet.h"
#import "UIView+MKExtension.h"
#import "UserData.h"

@interface ConditionSheet () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) SelctedBlock block;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UITableView *tableView;

@end

const CGFloat kConditionCellHeight = 56;

@implementation ConditionSheet


- (instancetype)initWithItems:(NSArray *)items complentBlock:(SelctedBlock)block
{
    if (self = [super init]) {
        
        [self setup];
        
        self.items = items;
        self.block = block;
    }
    
    return self;
}



- (instancetype)init
{
    if (self = [super init]) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    // 遮罩
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
//    [self addGestureRecognizer:pan];
    
    
    // 背景按钮
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [bgBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    
    // contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    // tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kConditionCellHeight;
    tableView.separatorInset = UIEdgeInsetsMake(0, 24, 0, 0);
    [self.contentView  addSubview:tableView];
    self.tableView = tableView;
    self.tableView.scrollEnabled = NO;
}



- (void)removeSelf
{
    // 动画
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = self.height;
    }];
    
    [UserData delayTask:0.2 onTimeEnd:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        
    }];
    
}



- (void)showWithItems:(NSArray *)items complentBlock:(SelctedBlock)block
{
    self.items = items;
    self.block = block;
    
    [self show];
}


- (void)show
{
    // 添加到Window
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    
    self.x = 0;
    self.y = 0;
    self.contentView.x = 0;
    self.contentView.y = self.height;
    self.contentView.height = self.items.count * kConditionCellHeight;
    
    [window addSubview:self];
    
    // 刷新数据
    [self.tableView reloadData];
    
    // 动画
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = self.height - self.contentView.height;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}



#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.items) {
        return self.items.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ConditionSheetCell";
    ConditionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[ConditionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.item = self.items[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConditionSheetItem *item = self.items[indexPath.row];
    
    for (ConditionSheetItem *item in self.items) {
        item.selected = NO;
    }
    
    item.selected = YES;
    
    if (self.block) {
        self.block(indexPath.row, item.arg);
    }
    
    [self removeSelf];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.width = self.width;
    self.contentView.height = self.items.count * kConditionCellHeight;
    
    self.tableView.width = self.contentView.width;
    self.tableView.height = self.contentView.height;
    self.tableView.x = 0;
    self.tableView.y = 0;
}


@end
