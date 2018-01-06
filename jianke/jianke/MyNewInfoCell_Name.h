//
//  MyNewInfoCell_Name.h
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKModel, MyNewInfoCell_Name;

typedef NS_ENUM(NSInteger, btnActionType) {
    btnActionType_login = 666,
    btnActionType_register,
    btnActionType_auth
};

typedef NS_ENUM(NSInteger, MyInfoJKCellType) {
    MyInfoJKCellType_Name,
    
    MyInfoJKCellType_MyNewInfo,
    MyInfoJKCellType_MoneyBag,
    MyInfoJKCellType_oldSalary,
    
    MyInfoJKCellType_waitToDo,
    MyInfoJKCellType_PersonalService,
    MyInfoJKCellType_MySubscription,
    MyInfoJKCellType_MyPersonalService,
    MyInfoJKCellType_Salary,
    MyInfoJKCellType_JobCollection,
    MyInfoJKCellType_JobApplyTrend,
    MyInfoJKCellType_JiankeWeal,
    
    MyInfoJKCellType_ShareApp,
    MyInfoJKCellType_Guide,
    MyInfoJKCellType_Setting,
    MyInfoJKCellType_Suggest,
    MyInfoJKCellType_BindWechat,
    
    MyInfoJKCellType_SwitchJKEP,
};

@protocol MyNewInfoCell_NameDelegate <NSObject>

- (void)myNewInfoCellName:(MyNewInfoCell_Name *)cell btnActionType:(btnActionType)actionType;

@end

@interface MyNewInfoCell_Name : UITableViewCell

@property (nonatomic, strong) JKModel *jkModel;
@property (nonatomic, weak) id<MyNewInfoCell_NameDelegate> delegate;

@end
