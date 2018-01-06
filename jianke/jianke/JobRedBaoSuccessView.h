//
//  JobRedBaoSuccessView.h
//  jianke
//
//  Created by yanqb on 2017/7/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobRedBaoSuccessView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIButton *DetailRule;
@property (nonatomic, copy) MKBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout0;


@end
@class JobRedBaoSuccessView;
@interface RedBaoSuccessView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content money:(NSString *)money block:(MKBlock)block;
@end
