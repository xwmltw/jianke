//
//  MyInfoCollect_Cell2.h
//  jianke
//
//  Created by fire on 16/11/1.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyInfoJKCellType) {
    MyInfoJKCellType_Name,
    
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
    
    MyInfoJKCellType_SwitchJKEP,
};

@interface MyInfoCollect_Cell2 : UICollectionViewCell

@property (nonatomic, assign) MyInfoJKCellType cellType;

@end
