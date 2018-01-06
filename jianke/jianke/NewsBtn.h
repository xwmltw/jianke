//
//  NewsBtn.h
//  jianke
//
//  Created by fire on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdModel;

@interface NewsBtn : UIButton

@property (nonatomic, strong) AdModel *model; /*!< 新闻模型 */

- (instancetype)initWithModel:(AdModel *)aModel size:(CGSize)aSize;

@end
