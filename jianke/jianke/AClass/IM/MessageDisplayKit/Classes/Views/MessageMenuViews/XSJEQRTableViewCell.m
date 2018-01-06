//
//  XSJEQRTableViewCell.m
//  jianke
//
//  Created by xiaomk on 16/1/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJEQRTableViewCell.h"
#import "WDConst.h"

@interface XSJEQRTableViewCell()

@property (nonatomic, strong) UILabel* labMsg;
@property (nonatomic, strong) UIFont* labFont;
@end

@implementation XSJEQRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _labFont = [UIFont systemFontOfSize:16];
        
        _labMsg = [[UILabel alloc] init];
        _labMsg.numberOfLines = 0;
        _labMsg.font = _labFont;
        _labMsg.textColor = [UIColor darkGrayColor];
        [self addSubview:_labMsg];
        
        WEAKSELF
        [_labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(16);
            make.left.equalTo(weakSelf.mas_left).offset(16);
            make.width.mas_equalTo(SCREEN_WIDTH-32);
        }];
    }
    return self;
}

- (void)refreshWithData:(NSString *)msg{
    
    self.labMsg.text = msg;
    
    CGSize labSize = [UIHelper getSizeWithString:self.labMsg.text width:SCREEN_WIDTH-24 font:self.labFont];
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = labSize.height + 32;
    self.frame = cellFrame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
