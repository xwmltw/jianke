//
//  MutiSelectSheetCell.m
//  jianke
//
//  Created by fire on 15/12/25.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MutiSelectSheetCell.h"
#import "Masonry.h"

@interface MutiSelectSheetCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *selectedBtn;

@end


@implementation MutiSelectSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = MKCOLOR_RGB(51, 51, 51);
        titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        UIButton *selectedBtn = [[UIButton alloc] init];
        [selectedBtn setImage:[UIImage imageNamed:@"v240_checkbox_0"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"v240_checkbox_1"] forState:UIControlStateSelected];
        self.selectedBtn = selectedBtn;
        [self.contentView addSubview:selectedBtn];
        selectedBtn.userInteractionEnabled = NO;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(26);
            make.top.mas_equalTo(17);
        }];
        
        
        [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-26);
            make.top.mas_equalTo(17);
        }];
        
    }
    return self;
}


- (void)setItem:(MutiSelectSheetItem *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    
    self.selectedBtn.selected = item.selected;
    
    self.userInteractionEnabled = item.enable;
    
    if (item.enable) {
        self.titleLabel.textColor = MKCOLOR_RGB(51, 51, 51);
    } else {
        self.titleLabel.textColor = MKCOLOR_RGB(236, 236, 236);
    }
}
@end
