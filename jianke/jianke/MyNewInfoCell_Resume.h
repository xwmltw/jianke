//
//  MyNewInfoCell_Resume.h
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ResumeBtnType) {
    ResumeBtnType_MyJoin,   //我的报名
    ResumeBtnType_MoneyBag, //钱袋子
    ResumeBtnType_JobTrends,    //兼职意向
    ResumeBtnType_Login,    //立即登录
    ResumeBtnType_MyProfile,    //我的简历
    ResumeBtnType_Refresh,    //刷新简历
};

@class MyNewInfoCell_Resume;
@protocol MyNewInfoCell_ResumeDelegate <NSObject>

- (void)MyNewInfoCellResume:(MyNewInfoCell_Resume *)cell actionType:(ResumeBtnType)actionType;

@end

@interface MyNewInfoCell_Resume : UITableViewCell

- (void)setModel:(id)model;
@property (nonatomic, weak) id<MyNewInfoCell_ResumeDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnResume;
@end
