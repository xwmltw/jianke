//
//  MKBaseTableViewCell.m
//  jianke
//
//  Created by xiaomk on 16/4/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@interface MKBaseTableViewCell(){
    CGFloat _cellHeight;
}

@end

@implementation MKBaseTableViewCell{

}

//+ (instancetype)new{
//    
//}

+ (instancetype)newWithClassName:(NSString*)className{
    static UINib* _nib;
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:className bundle:nil];
    }
    id cell;
    if (_nib) {
        cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (void)refreshWithData:(id)model andIndexPath:(NSIndexPath*)indexPath{
    self.indexPath = indexPath;
}



- (CGFloat)getCellHeight{
    return _cellHeight;
}

- (void)setCellHeight:(CGFloat)height{
    _cellHeight = height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
