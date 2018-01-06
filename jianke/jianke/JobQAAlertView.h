//
//  JobQAAlertView.h
//  jianke
//
//  Created by yanqb on 2018/1/3.
//  Copyright © 2018年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JobQAAlertView;

@protocol JobQAAlertDelegate <NSObject>
- (void)alertDelegate:(NSInteger)tag;
@end

@interface JobQAAlert : UIView
@property (nonatomic ,strong) JobQAAlertView *alertView;
@end


@interface JobQAAlertView : UIView <UITextFieldDelegate>
@property (nonatomic ,copy)MKBlock block;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (nonatomic, weak) id<JobQAAlertDelegate>delegate;
@end
