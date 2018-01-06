//
//  MyEnum.h
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#ifndef MyEnum_h
#define MyEnum_h

/** 按钮action类型 */
typedef NS_ENUM(NSInteger, BtnOnClickActionType) {
    BtnOnClickActionType_payForPhoneNum,    //获取联系方式
    BtnOnClickActionType_makeCall,   //打电话
    BtnOnClickActionType_sliderLeft,    //切换
    BtnOnClickActionType_sliderRight,   //切换
    BtnOnClickActionType_idAuthAction,  //信息认证
    BtnOnClickActionType_epInfoIndex,  //雇主信息- 主页 按钮
    BtnOnClickActionType_epInfoJob,  //雇主信息- 岗位 按钮
    BtnOnClickActionType_epInfoCase,  //雇主信息- 案例 按钮
    BtnOnClickActionType_uploadHeadImg,  //雇主信息 - 头像上传
    BtnOnClickActionType_zhaiTaskApplying,  //众包首页 - 兼客正在进行中的任务列表页面地址
    BtnOnClickActionType_zhaiTaskSalary,    //众包首页 - 兼客任务收入列表页面地址
    BtnOnClickActionType_sexFemale, //按钮 - 性别选择 - 女
    BtnOnClickActionType_sexmale,   //按钮 - 性别选择 - 男
    BtnOnClickActionType_editWorkExperience,    //编辑-工作经历
    BtnOnClickActionType_deleteWorkExperience,  //删除-工作经历
    BtnOnClickActionType_dateBegin, //工作经历-开始日期
    BtnOnClickActionType_dateEnd,   //工作经历-结束日期
};

/** 编辑服务商信息cell type */
typedef NS_ENUM(NSInteger, ApplySerciceCellType) {
    ApplySerciceCellType_serviceName,
    ApplySerciceCellType_city,
    ApplySerciceCellType_name,
    ApplySerciceCellType_telphone,
    ApplySerciceCellType_summary,
};

/** 编辑服务商信息cell type */
typedef NS_ENUM(NSInteger, EpProfileCellType) {
    EpProfileCellType_commpany,
    EpProfileCellType_shortCommpany,
    EpProfileCellType_summary,
    EpProfileCellType_industry,
    EpProfileCellType_hireCity,

};


/** 引导注册资料填写 */
typedef NS_ENUM(NSInteger, JoinJKCellType) {
    JoinJKCellType_Name,
    JoinJKCellType_Birthday,
    JoinJKCellType_City,
    JoinJKCellType_Area,
};

/** 编辑简历 */
typedef NS_ENUM(NSInteger, EditResumeCellType) {
    //编辑简历页面
    EditResumeCellType_name = 1,    //姓名
    EditResumeCellType_age, //年龄
    EditResumeCellType_city,    //常驻城区
    EditResumeCellType_area,    //位置
    EditResumeCellType_tel,      // 联系方式
    EditResumeCellType_categories,  //人员类别
    EditResumeCellType_education,   //学历
    EditResumeCellType_school,  //学校
    EditResumeCellType_profession,  //专业
    EditResumeCellType_speaility,   //特长
    EditResumeCellType_height,  //身高体重

};

/** 增加工作经历页面 */
typedef NS_ENUM(NSInteger, postWorkExpCellType) {
    postWorkExpCellType_jobType = 1, //岗位类别
    postWorkExpCellType_jobTitle,    //岗位名称
    PostWorkExpCellType_date,   //工作时间
    PostWorkExpCellType_content,    //工作内容
};


#endif /* MyEnum_h */
