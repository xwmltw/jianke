//
//  LookupResumeCell_Info.h
//  jianke
//
//  Created by yanqb on 2017/5/23.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LookupResumeCellType) {
    LookupResumeCellType_resumeIntegrity,   //简历完整度
    LookupResumeCellType_jobType,   //岗位类型
    LookupResumeCellType_jobArea,   //兼职区域
    LookupResumeCellType_idCertification,   //实名认证
    LookupResumeCellType_name,  //姓名
    LookupResumeCellType_sex,   //性别
    LookupResumeCellType_live,  //常驻城区
    LookupResumeCellType_account, //联系账号
    LookupResumeCellType_personnelCategories,   //人员类别
    LookupResumeCellType_education, //学历
    LookupResumeCellType_school,    //学校
    LookupResumeCellType_professional,  //专业
    LookupResumeCellType_speciality,    //特长
    LookupResumeCellType_height,    //身高
    LookupResumeCellType_lifePhotos,    //生活照
    LookupResumeCellType_selfAppraisa,  //自我评价
    LookupResumeCellType_studentId, //学生证
    LookupResumeCellType_healthId,  //健康证
    LookupResumeCellType_previewStudentId,  //预览-学生证
    LookupResumeCellType_previewHealthId,   //预览-健康证
    LookupResumeCellType_previewWorkInfo,   //预览-放鸽子etc
    LookupResumeCellType_newLine, //最新在线时间
};

@interface LookupResumeCell_Info : UITableViewCell


@property (nonatomic, assign) LookupResumeCellType cellType;
@property (nonatomic, assign)BOOL isLookOther;
- (void)setModel:(id)model;

@end
