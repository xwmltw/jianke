//
//  MKBaseTableViewCell.h
//  jianke
//
//  Created by xiaomk on 16/4/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HHBaseTVCDelegateType) {
    HHBaseTVCDelegateType_NO    =   1,
};


@protocol MKBaseTableViewCellDelegate <NSObject>
@optional
- (void)cell_eventWithIndexPath:(NSIndexPath*)indexPath;
- (void)Cell_eventWithIndexPath:(NSIndexPath*)indexPath tager:(id)tager;
- (void)Cell_eventWithIndexPath:(NSIndexPath*)indexPath cellDelegateType:(HHBaseTVCDelegateType)type;
- (void)Cell_eventWithIndexPath:(NSIndexPath*)indexPath tager:(id)tager cellDelegateType:(HHBaseTVCDelegateType)type;
@end


@interface MKBaseTableViewCell : UITableViewCell


/**
 *  cell 代理
 */
@property (nonatomic, weak) id <MKBaseTableViewCellDelegate> delegate;
/**
 *  保存 tableView 的 indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)newWithClassName:(NSString*)className;

- (CGFloat)getCellHeight;

- (void)setCellHeight:(CGFloat)height;

- (void)refreshWithData:(id)model andIndexPath:(NSIndexPath*)indexPath;

@end
