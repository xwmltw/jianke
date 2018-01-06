//
//  EPActionSheetItem.h
//  jianke
//
//  Created by fire on 16/2/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPActionSheetItem : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id arg;

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title arg:(id)arg;
- (instancetype)initWithTitle:(NSString *)title arg:(id)arg;

@end

