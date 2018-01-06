//
//  MenuTableViewCell.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "UIView+MKExtension.h"

@interface MenuTableViewCell()
@property (nonatomic, weak) UIImageView *centerSelectedView; /*!< 中间选中的图标 */
@property (nonatomic, weak) UILabel *contentLabel; /*!< 中间的标题 */

@end

@implementation MenuTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"cell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 标题
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentCenter;
//        contentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 左边中间标记选中的图标
        UIImageView *centerSelectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_icon_select_1"]];
        [self.contentView addSubview:centerSelectedView];
        self.centerSelectedView = centerSelectedView;
    }
    return self;
}

- (void)setTableViewCellModel:(TableViewCellModel *)tableViewCellModel
{
    _tableViewCellModel = tableViewCellModel;
    self.contentLabel.text = tableViewCellModel.title;
    self.centerSelectedView.hidden = !tableViewCellModel.isSelected;
    
    if (tableViewCellModel.isSelected) {
        self.contentView.backgroundColor = MKCOLOR_RGB(209, 242, 247);
        self.contentLabel.textColor = MKCOLOR_RGB(27, 180, 205);
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = [UIColor blackColor];
    }
    
    
    if (tableViewCellModel.index == -1) { // 标题
        
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = MKCOLOR_RGB(116, 116, 116);
    } else {
        
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.textColor = MKCOLOR_RGB(51, 51, 51);
    }
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = self.contentView.bounds;
    
    // 中间标记选中的图标
    self.centerSelectedView.width = 12;
    self.centerSelectedView.height = self.centerSelectedView.width;
    self.centerSelectedView.x = 20;
    self.centerSelectedView.y = (self.height - self.centerSelectedView.height) * 0.5;
}


@end
