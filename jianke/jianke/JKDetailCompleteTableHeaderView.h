//
//  JKDetailCompleteTableHeaderView.h
//  jianke
//
//  Created by fire on 16/2/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocialActivistCompleteModel : NSObject

@property (nonatomic, strong) NSNumber *allCompleteNum; /*!< 完工人数 */
@property (nonatomic, strong) NSNumber *allCompleteDayNum; /*!< 完工天数 */
@property (nonatomic, strong) NSNumber *socialActivistReward_unit; /*!< 人脉王赏金单位 1元/人 2元/人/天 */
@property (nonatomic, strong) NSNumber *socialActivistReward; /*!< 人脉王赏金单位值，单位为分 */
@property (nonatomic, strong) NSNumber *allSocialActivistReward; /*!< 人脉王可得到总赏金，单位为分 */

@end




@interface JKDetailCompleteTableHeaderView : UIView

@property (nonatomic, strong) SocialActivistCompleteModel *model;

+ (instancetype)headerView;

@end
