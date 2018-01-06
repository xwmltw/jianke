//
//  RightImgButton.h
//  jianke
//
//  Created by fire on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightImgButton : UIButton

@property (nonatomic, assign) CGFloat marginBetweenTitleAndImage; /*!< 标题与图片间的间距 */
@property (nonatomic, assign, getter=isResizeButton) BOOL resizeButton; /*!< 是否重置按钮尺寸 */

@end
