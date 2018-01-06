//
//  BusCourseView.m
//  jianke
//
//  Created by fire on 15/11/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "BusCourseView.h"
#import "BusCourseCell.h"
#import "UIView+MKExtension.h"

const CGFloat kHeaderViewHeight = 30;
const CGFloat kCellHeight = 60;
const CGFloat kHeaderBtnWidth = 120;

@interface BusCourseView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) MKBlock itemClickBlock;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL isPop;

@end


@implementation BusCourseView

- (instancetype)initWithItems:(NSArray *)items itemClick:(MKBlock)itemClickBlock
{
    if (self = [super init]) {
        
        self.isPop = NO;
        self.itemClickBlock = itemClickBlock;
        self.items = items;
        
        // 底部的View
        CGFloat containterViewHeight = items.count > 5 ? 5 * kCellHeight + kHeaderViewHeight : items.count * kCellHeight + kHeaderViewHeight;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - kHeaderViewHeight - kCellHeight, SCREEN_WIDTH, containterViewHeight);
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.image = [UIImage imageNamed:@"v220_map_expand_bg"];
        [self addSubview:bgImgView];
        
        // 头部Button
        UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kHeaderBtnWidth) * 0.5, 0, kHeaderBtnWidth, kHeaderViewHeight)];
        [headerBtn setImage:[UIImage imageNamed:@"v220_map_expand"] forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headerBtn];
        headerBtn.layer.cornerRadius = 5;
        headerBtn.layer.masksToBounds = YES;
        
        // tableView
        CGFloat tableViewHeight = items.count > 5 ? 5 * kCellHeight : items.count * kCellHeight;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, SCREEN_WIDTH, tableViewHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        tableView.rowHeight = kCellHeight;
        [tableView registerNib:[UINib nibWithNibName:@"BusCourseCell" bundle:nil] forCellReuseIdentifier:@"BusCourseCell"];
        tableView.scrollEnabled = NO;
        self.tableView = tableView;
    }
    
    return self;
}


- (void)headerBtnClick:(UIButton *)btn
{
    if (self.isPop) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.y = SCREEN_HEIGHT - 64 - (kHeaderViewHeight + kCellHeight);
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI);
        }];
        
        self.tableView.scrollEnabled = NO;
        self.isPop = NO;
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.y = SCREEN_HEIGHT - 64 - self.height;
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI);
        }];
        
        if (self.items.count > 5) {
            self.tableView.scrollEnabled = YES;
        }
        self.isPop = YES;
    }
}


#pragma mark - UITableViewDelegate && UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.itemClickBlock) {
        self.itemClickBlock(indexPath);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusCourseCell"];
    
    cell.transit = self.items[indexPath.row];
    
    return cell;
}


@end
