//
//  MenuCollectionViewCell.m
//  jianke
//
//  Created by fire on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "UIView+MKExtension.h"

@interface MenuCollectionViewCell()

@property (nonatomic, weak) UILabel *titleLabel; /*!< 标题 */
//@property (nonatomic, weak) UIImageView *leftSelectedView; /*!< 标记选中的图标 */
@property (nonatomic, weak) UIImageView *centerSelectedView; /*!< 中间选中的图标 */

@end

@implementation MenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
//        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.titleLabel = label;
        
//        // 左上角标记选中的图标
//        UIImageView *leftSelectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_0"]];
//        [self.contentView addSubview:leftSelectedView];
//        self.leftSelectedView = leftSelectedView;
        
        // 左边中间标记选中的图标
        UIImageView *centerSelectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_icon_select_1"]];
        [self.contentView addSubview:centerSelectedView];
        self.centerSelectedView = centerSelectedView;
        
    }
    return self;
}

- (void)setCollectionViewCellModel:(CollectionViewCellModel *)CollectionViewCellModel
{
    _CollectionViewCellModel = CollectionViewCellModel;
    self.titleLabel.text = CollectionViewCellModel.name;
    
    switch (CollectionViewCellModel.type) {
        case CollectionViewCellModelTypeSubOption:
        {
//            self.leftSelectedView.hidden = !CollectionViewCellModel.isSelected;
            
            if (CollectionViewCellModel.isSelected) {
                self.contentView.backgroundColor = MKCOLOR_RGB(209, 242, 247);
                self.titleLabel.textColor = MKCOLOR_RGB(27, 180, 205);
                
            } else {
                self.contentView.backgroundColor = [UIColor whiteColor];
                self.titleLabel.textColor = MKCOLOR_RGB(51, 51, 51);
            }
            
            self.centerSelectedView.hidden = YES;
        }
            break;
            
        case CollectionViewCellModelTypeNone:
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.centerSelectedView.hidden = YES;
            
        }
            break;
            
        default:
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = [UIColor blackColor];
            self.centerSelectedView.hidden = !CollectionViewCellModel.isSelected;
            
            if (CollectionViewCellModel.isSelected) {
                self.contentView.backgroundColor = MKCOLOR_RGB(209, 242, 247);
                self.titleLabel.textColor = MKCOLOR_RGB(27, 180, 205);
                
            } else {
                self.contentView.backgroundColor = [UIColor whiteColor];
                self.titleLabel.textColor = [UIColor blackColor];
            }
        }
            break;
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标题
    self.titleLabel.width = self.width;
    self.titleLabel.height = 20;
    self.titleLabel.x = 0;
    self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
    
//    // 左上角标记选中的图标
//    self.leftSelectedView.width = 12;
//    self.leftSelectedView.height = self.leftSelectedView.width;
//    self.leftSelectedView.x = 0;
//    self.leftSelectedView.y = 0;
    
    // 中间标记选中的图标
    self.centerSelectedView.width = 12;
    self.centerSelectedView.height = self.centerSelectedView.width;
    self.centerSelectedView.x = 20;
    self.centerSelectedView.y = (self.height - self.centerSelectedView.height) * 0.5;
    
}


@end
