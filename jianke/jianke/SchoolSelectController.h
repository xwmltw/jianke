//
//  SchoolSelectController.h
//  jianke
//
//  Created by fire on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  学校选择控制器

#import "BottomViewControllerBase.h"

@interface SchoolSelectController : BottomViewControllerBase

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) MKBlock didSelectCompleteBlock;

@end



/** 
 usage
 
 SchoolSelectController *vc = [[SchoolSelectController alloc] init];
 vc.cityId = @"211";
 vc.didSelectCompleteBlock = ^(SchoolModel *school){
 
 DLog(@"school ==== %@", school.schoolName);
 
 };
 
 [self.navigationController pushViewController:vc animated:YES];
 
 */
