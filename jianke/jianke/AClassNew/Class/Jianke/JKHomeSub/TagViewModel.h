//
//  TagViewModel.h
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagViewModel : NSObject

@property (nonatomic, copy) NSString* tagName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat pointX;
@property (nonatomic, assign) CGFloat poingY;
@property (nonatomic, assign) CGFloat nextPointX;
@property (nonatomic, assign) CGFloat nextPointY;
@end
