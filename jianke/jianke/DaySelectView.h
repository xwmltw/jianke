//
//  DaySelectView.h
//  jianke
//
//  Created by xiaomk on 16/5/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseModel.h"

@interface DaySelectView : UIView

- (void)initUIWithDaySelectModelArray:(NSMutableArray*)array;

@end


@interface DaySelectModel : MKBaseModel
@property(nonatomic, strong) NSString* title;  /*!< 按钮 文字 */
@property(nonatomic, assign) long value;     /*!< 数值 */
@property(nonatomic, assign) BOOL isEnable; /*!< 是否可点击 */
@property(nonatomic, assign) BOOL isSelect; /*!< 是否选中 */


- (void)setDiselect;
@end