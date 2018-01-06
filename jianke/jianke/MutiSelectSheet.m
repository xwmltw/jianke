//
//  MutiSelectSheet.m
//  jianke
//
//  Created by fire on 15/12/25.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MutiSelectSheet.h"
#import "UIView+MKExtension.h"
#import "UserData.h"
#import "Masonry.h"

@interface MutiSelectSheet() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) MKBlock block;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *title;
@end

@implementation MutiSelectSheet

const CGFloat kMutiSelectSheetCellHeight = 56;
const CGFloat kTitleViewHeight = 40;
const CGFloat kConfireBtnWidth = 90;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items selctedBlock:(MKBlock)block
{
    if (self = [super init]) {
        
        self.items = items;
        self.block = block;
        self.title = title;
        [self setup];
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
    
    // 背景按钮
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [bgBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    // contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    // titleView
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = MKCOLOR_RGB(240, 240, 240);
    [contentView addSubview:titleView];
    self.titleView = titleView;
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = MKCOLOR_RGB(90, 90, 90);
    titleLabel.text = self.title;
    [titleView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MKCOLOR_RGB(200, 200, 200);
    [titleView addSubview:line];
    self.line = line;
    
    // 确定按钮
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    // tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kMutiSelectSheetCellHeight;
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


- (void)show
{
    // 添加到Window
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    
    self.x = 0;
    self.y = 0;
    self.contentView.x = 0;
    self.contentView.y = self.height;
    self.contentView.height = self.items.count * kMutiSelectSheetCellHeight + kTitleViewHeight;
    
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


// 确认按钮点击
- (void)confirmBtnClick
{
    if (self.block) {
        self.block(self.items);
    }
    
    [self removeSelf];
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
    static NSString *ID = @"MutiSelectSheetCell";
    MutiSelectSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[MutiSelectSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    MutiSelectSheetItem *item = self.items[indexPath.row];
    item.selected = !item.selected;
    [tableView reloadData];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // contentView
    self.contentView.width = self.width;
    self.contentView.height = self.items.count * kMutiSelectSheetCellHeight + kTitleViewHeight;
    
    // titleView
    self.titleView.x = 0;
    self.titleView.y = 0;
    self.titleView.width = self.width;
    self.titleView.height = kTitleViewHeight;
    
    // confirmBtn
    self.confirmBtn.width = kConfireBtnWidth;
    self.confirmBtn.height = self.titleView.height;
    self.confirmBtn.x = self.width - self.confirmBtn.width;
    self.confirmBtn.y = 0;
    
    // line
    self.line.width = 1;
    self.line.height = kTitleViewHeight * 0.5;
    self.line.y = kTitleViewHeight * 0.25;
    self.line.x = self.confirmBtn.x;
    
    // titleLabel
    self.titleLabel.x = 26;
    self.titleLabel.y = 0;
    self.titleLabel.width = self.width - self.confirmBtn.width - self.titleLabel.x;
    self.titleLabel.height = self.titleView.height;
    
    // tableView
    self.tableView.width = self.contentView.width;
    self.tableView.height = self.contentView.height;
    self.tableView.x = 0;
    self.tableView.y = self.titleView.height;
}

@end
