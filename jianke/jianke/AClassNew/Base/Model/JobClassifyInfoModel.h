//
//  JobClassifyInfoModel.h
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"

@interface JobClassifyInfoModel : MKBaseModel

@property (nonatomic, copy) NSNumber *job_classfier_id;         /*!< 岗位分类id */
@property (nonatomic, copy) NSString *job_classfier_name;       /*!< 岗位分类名称 */
@property (nonatomic, copy) NSString *job_classfier_spelling;   /*!< 名称拼音 */
@property (nonatomic, copy) NSString *job_classfier_img_url;    /*!< 岗位分类图片url */
@property (nonatomic, copy) NSNumber *job_classfier_market_price;   /*!< 岗位分类市场价 以分为单位 */
@property (nonatomic, copy) NSNumber *enable_recruitment_service;   /*!< 是否允许使用委托招聘  1：是 0：否 */
@property (nonatomic, strong) NSArray *job_classifier_label_list;   /*!< 岗位分类拥有的标签列表 */
@property (nonatomic, strong) NSNumber *job_classfier_status;   /*!< 状态 */

@property (nonatomic, assign) BOOL isSelect;    /** 是否选中 */

- (void)setDiselect;

@end

@interface JobClassifierLabelModel : MKBaseModel
@property (nonatomic, copy) NSString *label_name;           /*!< 标签名称 */
@property (nonatomic, copy) NSNumber *label_add_price;      /*!< 标签附加价  以分为单位 */


@end

//“job_classifier_list”:[
//      {
//          “job_classfier_id”: xxx, // 岗位分类id
//          “job_classfier_name”: “xxx”, // 岗位分类名称
//          “job_classfier_img_url”:”xxxxx”, // 岗位分类图片url
//          “job_classfier_market_price”:// 岗位分类市场价 以分为单位
//          “enable_recruitment_service”:// 是否允许使用委托招聘  1：是 0：否
//          “job_classifier_label_list”:// 岗位分类拥有的标签
//                  [
//                      {
//                      “label_name”:// 标签名称
//                      “label_add_price”:// 标签附加价  以分为单位
//                      }
//                  ]
//      }
//  ]
