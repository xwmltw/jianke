//
//  EpProfileCell.h
//  JKHire
//
//  Created by fire on 16/11/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class EpProfileCell;
@protocol EpProfileCellDelegate <NSObject>

- (void)EpProfileCell:(EpProfileCell *)cell rightBtnActionType:(BtnOnClickActionType)actionType;

@end

@interface EpProfileCell : UITableViewCell

@property (nonatomic, weak) id<EpProfileCellDelegate> delegate;
@property (nonatomic, assign) BOOL isLookForJK; /*!< 兼客视角 */
- (void)setEpModel:(id)epModel cellType:(EpProfileCellType)cellType;

@end
