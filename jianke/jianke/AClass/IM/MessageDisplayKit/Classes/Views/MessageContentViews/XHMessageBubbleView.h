//
//  XHMessageBubbleView.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

// Views
#import "XHMessageTextView.h"
#import "XHMessageInputView.h"
#import "XHBubblePhotoImageView.h"
#import "SETextView.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

// Macro
#import "XHMacro.h"

// Model
#import "XHMessage.h"

// Factorys
#import "XHMessageAvatarFactory.h"
#import "XHMessageVoiceFactory.h"

#import "BaseButton.h"

#define kXHMessageBubbleDisplayMaxLine 200

#define kXHTextLineSpacing 3.0

#define KXHTimeLabelTopAndBottomPadding 10.0 /*!<  */

@protocol XHMessageBubbleDelegate <NSObject>

@optional

/** 查看详情按钮点击 */
- (void)lookupDetailBtn:(UIButton *)btn click:(id<XHMessageModel>)message;

/** 打卡按钮点击 */
- (void)reportBtn:(UIButton *)btn click:(id<XHMessageModel>)message;

@end


@interface XHMessageBubbleView : UIView

/**
 *  目标消息Model对象
 */
@property (nonatomic, strong, readonly)  id <XHMessageModel> message;

/**
 *  自定义显示文本消息控件，子类化的原因有两个，第一个是屏蔽Menu的显示。第二是传递手势到下一层，因为文本需要双击的手势
 */
@property (nonatomic, weak, readonly) SETextView *displayTextView;

/**
 *  用于显示气泡的ImageView控件
 */
@property (nonatomic, weak, readonly) UIImageView *bubbleImageView;

/**
 *  专门用于gif表情显示控件
 */
@property (nonatomic, weak, readonly) FLAnimatedImageView *emotionImageView;

/**
 *  用于显示语音的控件，并且支持播放动画
 */
@property (nonatomic, weak, readonly) UIImageView *animationVoiceImageView;

/**
 *  用于显示语音未读的控件，小圆点
 */
@property (nonatomic, weak, readonly) UIImageView *voiceUnreadDotImageView;

/**
 *  用于显示语音时长的label
 */
@property (nonatomic, weak, readonly) UILabel *voiceDurationLabel;

/**
 *  用于显示仿微信发送图片的控件
 */
@property (nonatomic, weak, readonly) XHBubblePhotoImageView *bubblePhotoImageView;

/**
 *  显示语音播放的图片控件
 */
@property (nonatomic, weak, readonly) UIImageView *videoPlayImageView;

/**
 *  显示地理位置的文本控件
 */
@property (nonatomic, weak, readonly) UILabel *geolocationsLabel;

/**
 *  设置文本消息的字体
 */
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

//===============================add
/**
 *  图文消息的标题
 */
@property (nonatomic, weak, readonly) UILabel *imgTextTitleLabel;

/**
 *  图文消息的文字
 */
@property (nonatomic, weak, readonly) UILabel *imgTextTextLabel;


/** 岗位分享消息图片 */
@property (nonatomic, weak, readonly) UIImageView *imgTextImageView;


/*!< 2.1 add 时间 */
@property (nonatomic, weak, readonly) UILabel *timeLabel;

/** 2.1 add 查看详情按钮 */
@property (nonatomic, weak, readwrite) BaseButton *lookupDetailBtn;

/** 2.1 add 打卡按钮 */
@property (nonatomic, weak, readwrite) BaseButton *reportBtn;

/** 2.1 add 代理 */
@property (nonatomic, assign) id<XHMessageBubbleDelegate> delegate;

//@property (nonatomic, assign, getter=isShowTime) BOOL showTime;

//===============================end

#pragma mark - added by kizy

/** 标题 */
@property (nonatomic, weak) UILabel *titleLab;


/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message;

/**
 *  获取气泡相对于父试图的位置
 *
 *  @return 返回气泡的位置
 */
- (CGRect)bubbleFrame;

/**
 *  根据消息Model对象配置消息显示内容
 *
 *  @param message 目标消息Model对象
 */
- (void)configureCellWithMessage:(id <XHMessageModel>)message;

/**
 *  根据消息Model对象计算消息内容的高度
 *
 *  @param message 目标消息Model对象
 *
 *  @return 返回所需高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message;

@end
