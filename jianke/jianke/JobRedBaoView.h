//
//  JobRedBaoView.h
//  jianke
//
//  Created by yanqb on 2017/7/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JobRedBaoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (nonatomic, copy) MKBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelLayout;

@end
@class JobRedBaoView;
@interface RedBaoAlert : UIView
@property (nonatomic, strong) JobRedBaoView *redBaoView;
@property (nonatomic, copy) MKBlock block;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content;
@end
