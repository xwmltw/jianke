//
//  EditQuickReplyCell.m
//  jianke
//
//  Created by xiaomk on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "EditQuickReplyCell.h"
#import "WDConst.h"
#import "TVAlertView.h"

@interface EditQuickReplyCell(){
    NSIndexPath* _indexPath;
    NSString* _message;
}

@property (nonatomic, strong) UILabel* labText;
@property (nonatomic, strong) UIButton* btnDel;
@property (nonatomic, strong) UIButton* btnEditText;
@end

@implementation EditQuickReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labText = [[UILabel alloc] init];
        _labText.textAlignment = NSTextAlignmentLeft;
        _labText.numberOfLines = 0;
        _labText.font = [UIFont systemFontOfSize:16];
        [self addSubview:_labText];
        _labText.textColor = MKCOLOR_RGB(80, 80, 80);
        
        _btnDel = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnDel setImage:[UIImage imageNamed:@"v240_msg_del_0"] forState:UIControlStateNormal];
        [_btnDel setImage:[UIImage imageNamed:@"v240_msg_del_1"] forState:UIControlStateHighlighted];
        [self addSubview:_btnDel];
        [_btnDel addTarget:self action:@selector(btnDelOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnEditText = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnEditText];
        [_btnEditText addTarget:self action:@selector(btnEditTextOnclick:) forControlEvents:UIControlEventTouchUpInside];

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = MKCOLOR_RGB(228, 228, 228);
        [self addSubview:lineView];
        
        WEAKSELF
        [_btnDel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.right.equalTo(weakSelf.mas_right).offset(-48);
            make.width.mas_equalTo(@44);
        }];
        
        [_labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(16);
            make.left.equalTo(weakSelf.mas_left).offset(16);
            make.right.equalTo(weakSelf.mas_right).offset(-104);
        }];
        
        [_btnEditText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labText.mas_left);
            make.right.equalTo(_labText.mas_right);
            make.top.equalTo(_labText.mas_top).offset(-8);
            make.bottom.equalTo(_labText.mas_bottom).offset(8);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)refreshWithData:(NSString *)msg andIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _message = msg;
    self.labText.text = msg;
    
    CGRect cellFrame = self.frame;

    CGSize labSize = [UIHelper getSizeWithString:self.labText.text width:SCREEN_WIDTH-104-16 font:[UIFont systemFontOfSize:16]];
    if (labSize.height > 52-32) {
        cellFrame.size.height = labSize.height + 32;
    }else{
        cellFrame.size.height = 52;
    }
    self.frame = cellFrame;

}

- (void)btnDelOnclick:(UIButton*)sender{
    WEAKSELF
    [UIHelper showConfirmMsg:@"确定删除这条短消息吗？" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf.deletate eqrCell_btnDelOnclickWithIndexPath:_indexPath];
        }
    }];
}

- (void)btnEditTextOnclick:(UIButton*)sender{
    WEAKSELF
    [[TVAlertView sharedInstance] showWithTitle:@"编辑常用语" content:_message placeholder:@"长度限制120字" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex, NSString *content) {
        ELog(@"=====buttonIndex:%ld",(long)buttonIndex);
        if (buttonIndex == 1) {
            if (content.length > 0) {
                [weakSelf.deletate eqrCell_editMsgWithIndexPath:_indexPath msg:content];
            }
        }
    }];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
