//
//  WelfareModel.h
//  jianke
//
//  Created by fire on 16/1/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
// 岗位福利

#import <Foundation/Foundation.h>


@interface WelfareModel : NSObject
@property (nonatomic, copy) NSNumber *tag_id;               /*!< 岗位福利的id */
@property (nonatomic, copy) NSString *tag_title;            /*!< 岗位福利的标题(发布岗位时无需上传) */
@property (nonatomic, copy) NSString *tag_img_url;          /*!< 岗位福利的图片地址(发布岗位时无需上传) */
@property (nonatomic, copy) NSNumber *check_status;         /*!< 1表示选中，0表示未选中 */
@property (nonatomic, copy) NSNumber *tag_rank;             /*!< 岗位福利排序 */
@property (nonatomic, copy) NSString *fullname_tag_img_url; /*!< 岗位福利图标 */

@end
