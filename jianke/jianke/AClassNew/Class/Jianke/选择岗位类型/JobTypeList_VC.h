//
//  JobTypeList_VC.h
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewController.h"
#import "MKBaseModel.h"
#import "JobClassifyInfoModel.h"

@interface JobTypeList_VC : MKBaseTableViewController

@property (nonatomic, assign) PostJobType postJobType;  /*!< 岗位发布类型 */
@property (nonatomic, strong) NSArray *classifierArray; /*!< 岗位类型列表 */

@property (nonatomic, copy) MKBlock block;
@end


