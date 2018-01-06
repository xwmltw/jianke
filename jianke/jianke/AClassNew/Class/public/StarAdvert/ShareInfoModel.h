//
//  ShareInfoModel.h
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfoModel : NSObject
@property (nonatomic, copy) NSString* share_title;      /*!< 分享标题 */
@property (nonatomic, copy) NSString* share_content;    /*!< 分享内容 */
@property (nonatomic, copy) NSString* share_img_url;    /*!< 分享图片url */
@property (nonatomic, copy) NSString* share_url;        /*!< 分享链接url */
@end
