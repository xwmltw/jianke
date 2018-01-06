//
//  XZImgPreviewView.h
//  jianke
//
//  Created by yanqb on 2016/11/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, showType) {
    showType_default,
    showType_delete,    //删除按钮
};

typedef void (^XZBlock)(id result1, NSInteger currentIndex);

@interface XZImgPreviewView : UIView

+ (void)showViewWithArray:(NSArray *)imgArr beginWithIndex:(NSInteger)index;
+ (instancetype)showViewWithArray:(NSArray *)imgArr beginWithIndex:(NSInteger)index showType:(showType)showType;

@property (nonatomic, copy) NSArray<UIImageView *> *imgArr;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) MKBlock dismissBlock;

//该属性只有当showType为showType_delete才生效
@property (nonatomic, copy) XZBlock deleteBlock;

// 显示
- (void)show;

// 删除指定下标图片
- (void)deleteImgWithIndex:(NSInteger)index;

@end
