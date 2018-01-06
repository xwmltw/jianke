//
//  CitySelectCell.h
//  jianke
//
//  Created by fire on 15/9/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName; /*!< 城市名 */
@property (weak, nonatomic) IBOutlet UIButton *cityFirstLetter;  /*!< 城市首字母 */

+ (instancetype)cityCell;

@end
