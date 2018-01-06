//
//  PostWorkExpe_VC.h
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface PostWorkExpe_VC : BottomViewControllerBase

@property (nonatomic, strong) ResumeExperienceModel *model;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) MKBlock block;

@end
