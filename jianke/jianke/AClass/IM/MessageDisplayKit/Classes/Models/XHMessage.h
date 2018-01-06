//
//  XHMessage.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageModel.h"

@interface XHMessage : NSObject <XHMessageModel, NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originPhotoUrl;

@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;

@property (nonatomic, copy) NSString *emotionPath;

@property (nonatomic, strong) UIImage *localPositionPhoto;
@property (nonatomic, copy) NSString *geolocations;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImage *avatar;              //头像
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) BOOL shouldShowUserName;

@property (nonatomic, assign) BOOL sended;

@property (nonatomic, assign) XHBubbleMessageMediaType messageMediaType;

@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;         //发送接收 类型

@property (nonatomic) BOOL isRead;

//======添加自定义属性   by:MK 10.19
@property (nonatomic, strong) id obj_id; //岗位详情或者企业详情id

// addeb by kizy from V370
@property (nonatomic, assign, getter=isHiddenTime) BOOL hiddenTime; /*!< 是否隐藏时间 */
@property (nonatomic, assign, getter=isNeedJudgeTime) BOOL needJudgeTime;   /*!< 是否需要参与时间隐藏判断 */
@property (nonatomic, assign, getter=isShowTitle) BOOL showTitle; /*!< 是否有标题 */

//===图文
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *app_param;
@property (nonatomic, strong) NSString *linkUrl;
//======end


//======添加自定义消息类型  by:MK 10.19
/**
 *  初始化岗位消息
 *  @return 返回Message model 对象
 */
- (instancetype)initWithJob:(NSString *)desc
                     obj_id:(NSNumber*)obj_id
                     sender:(NSString *)sender
                  timestamp:(NSDate *)timestamp;

/**
 *  初始化企业消息
 *  @return 返回Message model 对象
 */
- (instancetype)initWithEnterprise:(NSString *)desc
                            obj_id:(NSNumber*)obj_id
                            sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp;

/**
 *  初始化系统消息
 *  @return 返回Message model 对象
 */
- (instancetype)initWithSystem:(NSString *)desc
                           arg:(id)arg
                        sender:(NSString *)sender
                     timestamp:(NSDate *)timestamp;

/**
 *  初始图文消息
 *
 *  @param title                标题
 *  @param message              内容描述
 *  @param publish_time         发布时间的毫秒数
 *  @param imageUrl             图片URL
 *  @param type                 int,  // 类型，1：跳转网页类型，2：app内跳转
 *  @param code                 app内跳转code定义",  //type=2时，此参数必须有值
 *  @param app_param            app内跳转的参数，type=2时必须有值，值的内容根据code不同而不同
 *  @param linkUrl              点击图片后跳转的URL,type=1时此参数必须有值"
 *
 *  @return 返回Message model 对象
 */

- (instancetype)initWithImgTextTitle:(NSString *)title
                                text:(NSString *)text
                        thumbnailUrl:(NSString *)thumbnailUrl
                             linkUrl:(NSString *)linkUrl
                                type:(NSNumber *)type
                                code:(NSNumber *)code
                           app_param:(NSString *)app_param
                           timestamp:(NSDate *)timestamp;
//===============================================================


/**
 *  初始化文本消息
 *
 *  @param text   发送的目标文本
 *  @param sender 发送者的名称
 *  @param date   发送的时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                         arg:(id)arg
                        timestamp:(NSDate *)timestamp;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                                    timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息。增加已读未读标记
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead;

/**
 *  初始化gif表情类型的消息
 *
 *  @param emotionPath 表情的路径
 *  @param sender      发送者
 *  @param timestamp   发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                           sender:(NSString *)sender
                             timestamp:(NSDate *)timestamp;

/**
 *  初始化地理位置的消息
 *
 *  @param localPositionPhoto 地理位置默认显示的图
 *  @param geolocations       地理位置的信息
 *  @param location           地理位置的经纬度
 *  @param sender             发送者
 *  @param timestamp          发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp;

@end
