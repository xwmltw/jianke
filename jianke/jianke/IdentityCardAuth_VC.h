//
//  IdentityCardAuth_VC.h
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewController.h"

typedef NS_ENUM(NSInteger, IDCardAuthCellType){
    IDCardAuthCellType_name = 1,
    IDCardAuthCellType_idNum = 2,
    IDCardAuthCellType_photo1 = 3,
    IDCardAuthCellType_photo2 = 4,
    IDCardAuthCellType_photo3 = 5,
    IDCardAuthCellType_jkIntor = 6,
    IDCardAuthCellType_epAgree = 7
};

@interface IdentityCardAuth_VC : MKBaseTableViewController

@property (nonatomic ,assign) BOOL isFromHome;
@property (nonatomic ,assign) BOOL isFromPostJobD4ci;

@property (nonatomic, copy) MKBoolBlock block;
@end
