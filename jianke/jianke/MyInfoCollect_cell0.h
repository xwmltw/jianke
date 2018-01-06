//
//  MyInfoCollect_cell0.h
//  jianke
//
//  Created by fire on 16/11/1.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKModel, MyInfoCollect_cell0;
typedef NS_ENUM(NSInteger, btnActionType) {
    btnActionType_login = 666,
    btnActionType_register,
    btnActionType_auth
};

@protocol MyInfoCollect_cell0Delegate <NSObject>

- (void)MyInfoCollectCell:(MyInfoCollect_cell0 *)cell actionType:(btnActionType)actionType;

@end


@interface MyInfoCollect_cell0 : UICollectionViewCell

@property (nonatomic, strong) JKModel *jkModel;
@property (nonatomic, weak) id<MyInfoCollect_cell0Delegate> delegate;

@end
