//
//  LookupResume_VC.h
//  jianke
//
//  Created by 时现 on 16/1/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

typedef NS_ENUM(NSInteger, LookupResumeSectionType) {
    //兼客视角
    LookupResumeSectionType_resumeIntegrity,    //简历信息
    LookupResumeSectionType_applyTrends,    //兼职意向
    LookupResumeSectionType_idCertification,    //实名认证
    LookupResumeSectionType_personalInfo,   //个人信息
    LookupResumeSectionType_lifePhotos, //生活照
    LookupResumeSectionType_workExperience, //工作经历
    LookupResumeSectionType_workExperienceNoData,   //工作经历 - 无数据
    LookupResumeSectionType_selfAppraisa,   //自我评价
    LookupResumeSectionType_studentId,  //学生证
    LookupResumeSectionType_healthId,   //健康证
    //雇主视角
    LookupResumeSectionType_previewResume,  //预览视角-完工-放鸽子etc
    LookupResumeSectionType_newLine, //最新在线
    LookupResumeSectionType_previewCards,   //证件信息
};

@interface LookupResume_VC : BottomViewControllerBase

// 以下属性用于兼客/雇主查看其他兼客简历时传递
@property (nonatomic, strong) JKModel *otherJkModel; /*!< 被查看兼客的模型 */
@property (nonatomic, assign) BOOL isLookOther; /*!< 企业查看投递某个岗位的简历,0不是, 1是 */
@property (nonatomic, copy) NSNumber *resumeId; /*!< 要查询兼客的简历ID */

@property (nonatomic, copy) NSNumber *jobId; /*!< 要查询兼客所投递的岗位ID */
@property (nonatomic, copy) NSString *jobTitle; /*!< 岗位标题,IM聊天时需要带过去 */

@property (nonatomic, copy) NSString *accountId;    /*!< 要查询用户ID */
@property (nonatomic, assign) BOOL isFromGroupMembers;  /*!< 是否从群组过来 */
@property (nonatomic, copy) MKBoolBlock removeBlock;  /*群组成员管理过来 移除成员回调 */

-(void)setData;@end
