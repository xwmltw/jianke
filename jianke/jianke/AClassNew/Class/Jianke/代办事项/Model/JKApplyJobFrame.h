//
//  JKApplyJobFrame.h
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKApplyJob.h"
#import "WDConst.h"

/** cell外边距 */
#define JKApplyJobCellMargin 16
#define JKApplyJobCellContentMargin 8
#define JKApplyJobCellContentMarginTop 4

/** cell内边距 */
#define JKApplyJobCellPendding 16
#define JKApplyJobCellFooterPendding 12

/** 中间View宽度 */
#define JKApplyJobCellContentImageViewW (SCREEN_WIDTH - 2 * JKApplyJobCellContentMargin)

/** 我的报名动态中每条动态的高度 */
#define JKApplyJobCellStateH 25
/** 我的报名动态中每条动态的宽度 */
#define JKApplyJobCellStateW (JKApplyJobCellContentImageViewW - 2 * JKApplyJobCellPendding)

/** 内容字体 */
#define JKApplyJobFont [UIFont systemFontOfSize:15]




@interface JKApplyJobFrame : NSObject
@property (nonatomic, strong) JKApplyJob *applyJob; /*!< 我的工作模型 */
@property (nonatomic, assign) CGRect contentImageViewF; /*!< 内容ViewFrame */
@property (nonatomic, assign) CGRect headViewF; /*!< 头部ViewFrame */
@property (nonatomic, assign) CGRect middleViewF; /*!< 中间内容View未展开时的Frame */
@property (nonatomic, assign) CGRect footViewF; /*!< 底部View未展开时的Frame */
@property (nonatomic, assign) CGFloat cellHeight; /*!< cell高度 */
@property (nonatomic, assign) NSUInteger index; /*!< 记录当前模型在数组中的位置 */

+ (NSMutableArray *)applyJobFListWithApplyJobArray:(NSArray *)array withSection:(NSUInteger)section;

@end
