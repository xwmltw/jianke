//
//  JobDetailFooterView.h
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobDetailFooterView, JobDetailModel;

typedef NS_ENUM(NSInteger, JobDetailFooterViewBtnType) {
    JobDetailFooterViewBtnType_sendMsg = 10086,
    JobDetailFooterViewBtnType_makeCall,
    JobDetailFooterViewBtnType_makeApply,
    JobDetailFooterViewBtnType_makeApplyCall,   //采集 电话联系
    JobDetailFooterViewBtnType_cancelApply, //取消报名
    JobDetailFooterViewBtnType_putQuestion, //提问题
};

@protocol JobDetailFooterViewDelegate <NSObject>

- (void)jobDetailFooterView:(JobDetailFooterView *)footerView jobDetalModel:(JobDetailModel *)jobDetailModel actionType:(JobDetailFooterViewBtnType)actionType;

@end

@interface JobDetailFooterView : UIView

@property (nonatomic, assign) BOOL isFromQrScan; /*!< 扫码过来的 */
@property (nonatomic, strong) JobDetailModel *jobDetailModel; /*!< 岗位详情模型 */
@property (nonatomic, weak) id<JobDetailFooterViewDelegate> delegate;


@end
