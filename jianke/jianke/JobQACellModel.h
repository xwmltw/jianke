//
//  JobQACellModel.h
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobQAInfoModel.h"

@interface JobQACellModel : NSObject

@property (nonatomic, strong) JobQAInfoModel *jobQAModel;

@property (nonatomic, assign) CGFloat cellHeight; /*!< cell高度 */

+ (NSArray *)JobQACellArrayWithJobQAArray:(NSArray *)array;

@end
