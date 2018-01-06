//
//  EditResumeAlertTelView.h
//  jianke
//
//  Created by yanqb on 2017/7/17.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertTelBtnTag){
    AlertTelBtnTag_code = 1,
    AlertTelBtnTag_cancel,
    AlertTelBtnTag_update,
};

@interface EditResumeAlertTelView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textFiedTel;
@property (weak, nonatomic) IBOutlet UITextField *textFiedCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UILabel *labMiao;
@property (nonatomic, copy) MKBlock block;
@end

@class EditResumeAlertTelView;
@interface AlertTelVIew : UIView
@property (nonatomic, strong) EditResumeAlertTelView *editTelView;
- (instancetype)initWithFrame:(CGRect)frame block:(MKBlock )block;

@end
