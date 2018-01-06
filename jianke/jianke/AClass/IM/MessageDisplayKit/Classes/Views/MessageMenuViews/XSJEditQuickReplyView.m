//
//  XSJEditQuickReplyView.m
//  jianke
//
//  Created by xiaomk on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJEditQuickReplyView.h"
#import "WDConst.h"
#import "EQRMsgModel.h"
#import "XSJEQRTableViewCell.h"

#pragma mark - XSJEditQuickReplyView
@interface XSJEditQuickReplyView () <UITableViewDataSource, UITableViewDelegate>{
    EQRMsgModel* _eqrMsgModel;
    NSArray* _datasArray;
}

@property (nonatomic, strong) UITableView* msgTableView;
@property (nonatomic, strong) UIButton* btnAddMsg;
@end

@implementation XSJEditQuickReplyView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    if (!_msgTableView) {
        CGFloat xMargin = 0;
        _msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(xMargin, 0, CGRectGetWidth(self.bounds) - xMargin*2, CGRectGetHeight(self.bounds))];
        _msgTableView.delegate = self;
        _msgTableView.dataSource = self;
        _msgTableView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//        _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_msgTableView];
    }
    
    if (!_btnAddMsg) {
        UIButton* btnAdd = [[UIButton alloc] initWithFrame:CGRectZero];
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"v240_edit_0"] forState:UIControlStateNormal];
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"v240_edit_1"] forState:UIControlStateHighlighted];
        [btnAdd addTarget:self action:@selector(btnAddMsgOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAdd];
        [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_msgTableView.mas_right).offset(-12);
            make.bottom.equalTo(_msgTableView.mas_bottom).offset(-12);
        }];
        _btnAddMsg = btnAdd;
    }
    
    
//    [self refreshWithData];
}


- (void)refreshWithData{
    if (_msgTableView && _btnAddMsg) {
        [[UserData sharedInstance] getEqrMsgModelWithBlock:^(EQRMsgModel* obj) {
            if (obj) {
                _datasArray = nil;
                _eqrMsgModel = obj;
                NSInteger loginType = [[UserData sharedInstance] getLoginType].integerValue;
                if (loginType == WDLoginType_JianKe) {
                    _datasArray = [[NSArray alloc] initWithArray:_eqrMsgModel.student_quick_reply];
                }else if (loginType == WDLoginType_Employer){
                    _datasArray = [[NSArray alloc] initWithArray:_eqrMsgModel.ent_quick_reply];
                }
            }
            
            [_msgTableView reloadData];
        }];
    }else{
        [self setup];
    }
  
}

#pragma mark - tableView delegate

AddTableViewLineAdjust
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier = @"msgCell";
    XSJEQRTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XSJEQRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    }
    if (_datasArray.count <= indexPath.row) {
        return cell;
    }
    NSString* msg = [_datasArray objectAtIndex:indexPath.row];
    [cell refreshWithData:msg];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* msg = [_datasArray objectAtIndex:indexPath.row];
    [self.delegate eqr_didSelecteMsg:msg];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasArray ? _datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - 点击编辑按钮
- (void)btnAddMsgOnclick:(UIButton*)sender{
    [self.delegate eqr_btnEditOnclick];
}
@end
