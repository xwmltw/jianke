//
//  XHPopMenuItemView.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenuItemView.h"
#import "WDConst.h"

@interface XHPopMenuItemView ()

@property (nonatomic, strong) UIView *menuSelectedBackgroundView;

@property (nonatomic, strong) UIImageView *separatorLineImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation XHPopMenuItemView

- (void)setupPopMenuItem:(XHPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom isCustom:(BOOL)isCustomCell
{
    self.popMenuItem = popMenuItem;
    self.separatorLineImageView.hidden = isBottom;
    
    if (isCustomCell) {
        
        self.titleLabel.text = popMenuItem.title;
        self.titleLabel.textColor = popMenuItem.color;
        
    } else {
        
        self.textLabel.text = popMenuItem.title;
        self.imageView.image = popMenuItem.image;
    }
    
}

#pragma mark - Propertys

- (UIView *)menuSelectedBackgroundView {
    if (!_menuSelectedBackgroundView) {
        _menuSelectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _menuSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.016 green:0.682 blue:0.565 alpha:0.9];

    }
    return _menuSelectedBackgroundView;
}

- (UIImageView *)separatorLineImageView {
    if (!_separatorLineImageView) {
        
        if (!self.width) {
            
//            _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight, kXHMenuTableViewWidth - 2 * kXHMenuTableViewSapcing, kXHSeparatorLineImageViewHeight)];

            _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight,  kXHMenuTableViewWidth * 4, kXHSeparatorLineImageViewHeight)];

        } else {
            
//            _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight, self.width - 2 * kXHMenuTableViewSapcing, kXHSeparatorLineImageViewHeight)];
            _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight, self.width, kXHSeparatorLineImageViewHeight)];
        }
        
        _separatorLineImageView.backgroundColor = [UIColor XSJColor_grayLine];
    }
    return _separatorLineImageView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = MKCOLOR_RGB(22, 175, 202);
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.separatorLineImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = MKCOLOR_RGB(22, 175, 202);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.textLabel.frame = textLabelFrame;
    
    self.titleLabel.frame = self.contentView.bounds;
}

@end
