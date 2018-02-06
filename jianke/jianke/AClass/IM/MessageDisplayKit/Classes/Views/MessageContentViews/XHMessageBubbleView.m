//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"

#import "XHMessageBubbleHelper.h"
#import "XHConfigurationHelper.h"
#import "UIView+MKExtension.h"
#import "DateHelper.h"
#import "WdMessage.h"
#import "ImMessage.h"
#import "DateTools.h"
#import "UIImageView+WebCache.h"
#import "UIHelper.h"
#import "ImDataManager.h"

#define kXHHaveBubbleMargin 8.0f // 文本、视频、表情气泡上下边的间隙
#define kXHHaveBubbleVoiceMargin 13.5f // 语音气泡上下边的间隙
#define kXHHaveBubblePhotoMargin 6.5f // 图片、地理位置气泡上下边的间隙

#define kXHVoiceMargin 20.0f // 播放语音时的动画控件距离头像的间隙

#define kXHArrowMarginWidth 5.2f // 箭头宽度

#define kXHTopAndBottomBubbleMargin 13.0f // 文本在气泡内部的上下间隙
#define kXHLeftTextHorizontalBubblePadding 13.0f // 文本的水平间隙
#define kXHRightTextHorizontalBubblePadding 13.0f // 文本的水平间隙

#define kXHUnReadDotSize 10.0f // 语音未读的红点大小

#define kXHNoneBubblePhotoMargin (kXHHaveBubbleMargin - kXHBubblePhotoMargin) // 在没有气泡的时候，也就是在图片、视频、地理位置的时候，图片内部做了Margin，所以需要减去内部的Margin

const CGFloat kXHLookupDetailBtnHeight = 33; /*!< 查看详情按钮高度 */
const CGFloat kXHLookupDetailBtnWidth = 72; /*!< 查看详情按钮宽度 */
const CGFloat kXHreportBtnHeight = kXHLookupDetailBtnHeight; /*!< 打卡按钮高度 */
const CGFloat kXHreportBtnWidth = 72; /*!< 打卡按钮宽度 */
const CGFloat kXHtimeLabelHeight = 20; /*!< 时间宽度 */


@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) SETextView *displayTextView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) FLAnimatedImageView *emotionImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) UIImageView *voiceUnreadDotImageView;

@property (nonatomic, weak, readwrite) UILabel *voiceDurationLabel;

@property (nonatomic, weak, readwrite) XHBubblePhotoImageView *bubblePhotoImageView;

@property (nonatomic, weak, readwrite) UIImageView *videoPlayImageView;

@property (nonatomic, weak, readwrite) UILabel *geolocationsLabel;

@property (nonatomic, strong, readwrite) id <XHMessageModel> message;

@property (nonatomic, weak, readwrite) UILabel *imgTextTitleLabel;      //add

@property (nonatomic, weak, readwrite) UILabel *imgTextTextLabel;       //add

@property (nonatomic, weak, readwrite) UILabel *timeLabel; /*!< 时间 */

@property (nonatomic, weak, readwrite) UIImageView *imgTextImageView; /** 岗位分享消息图片 */

@end

@implementation XHMessageBubbleView

#pragma mark - Bubble view

// 获取文本的实际大小
+ (CGFloat)neededWidthForText:(NSString *)text {
//    UIFont *systemFont = [[XHMessageBubbleView appearance] font];
//    CGSize textSize = CGSizeMake(CGFLOAT_MAX, 20); // rough accessory size
//    CGSize sizeWithFont = [text sizeWithFont:systemFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeWithFont = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[XHMessageBubbleView appearance] font], NSFontAttributeName, nil]];
#if defined(__LP64__) && __LP64__
    return ceil(sizeWithFont.width);
#else
    return ceilf(sizeWithFont.width);
#endif
}

// 计算文本实际的大小
+ (CGSize)neededSizeForText:(NSString *)text {
    // 实际处理文本的时候
    // 文本只有一行的时候，宽度可能出现很小到最大的情况，所以需要计算一行文字需要的宽度
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : (kIs_iPhone_6 ? 0.6 : (kIs_iPhone_6P ? 0.62 : 0.55)));
    
    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        dyWidth += 10;
    }
    
    CGSize textSize = [SETextView frameRectWithAttributtedString:[[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text]
                                                  constraintSize:CGSizeMake(maxWidth, MAXFLOAT)
                                                     lineSpacing:kXHTextLineSpacing
                                                            font:[[XHMessageBubbleView appearance] font]].size;
    
    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth), textSize.height);
}

// 计算图片实际大小
+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
//=======================add
//    float height = 120/photo.size.width * photo.size.height;
//    CGSize photoSize = CGSizeMake(120, height);
//=======================end
    CGSize photoSize = CGSizeMake(140, 140);
    return photoSize;
}

// 计算语音实际大小
+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 42);
    return voiceSize;
}

// 计算Emotion的高度
+ (CGSize)neededSizeForEmotion {
    return CGSizeMake(100, 100);
}

// 计算LocalPostion的高度
+ (CGSize)neededSizeForLocalPostion {
    return CGSizeMake(140, 140);
}

// 计算Cell需要实际Message内容的大小
+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size = [XHMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height;
}

/** 计算timeLabel的宽度 */
+ (CGFloat)getTimeLabelWidthWithText:(NSString *)text
{
    CGSize maxSize = CGSizeMake(200, 18);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    CGRect rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width;
}


// 获取Cell需要的高度
+ (CGSize)getBubbleFrameWithMessage:(id <XHMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
            //==========add
        case XHBubbleMessageMediaTypeImgText:
        {
            ELog(@"=====图文====设置 泡泡 大小===============1");
            float width = [UIScreen mainScreen].bounds.size.width - 100;
            
            float height = width/message.photo.size.width * message.photo.size.height;
            bubbleSize = CGSizeMake(width, height+80);
            break;
        }
        case XHBubbleMessageMediaTypeJob: // 分享岗位
        {
            float width = [UIScreen mainScreen].bounds.size.width - 120;
            float height = 120;
            bubbleSize = CGSizeMake(width, height);
            
            break;
        }
            
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:
            //==========end
        case XHBubbleMessageMediaTypeText: {
            CGSize needTextSize = [XHMessageBubbleView neededSizeForText:message.text];
           
            // 确保timeLabel够宽
//            NSString *timeStr = [DateHelper getTimeRangeWithSecond:@(((XHMessage *)message).timestamp.timeIntervalSince1970)];
//            CGFloat timeStrWidth = [XHMessageBubbleView getTimeLabelWidthWithText:timeStr];
//            needTextSize.width = needTextSize.width > timeStrWidth ? needTextSize.width : timeStrWidth;
            
            bubbleSize = CGSizeMake(needTextSize.width + kXHLeftTextHorizontalBubblePadding + kXHRightTextHorizontalBubblePadding + kXHArrowMarginWidth, needTextSize.height + kXHHaveBubbleMargin * 2 + kXHTopAndBottomBubbleMargin * 2); //这里*4的原因是：气泡内部的文本也做了margin，而且margin的大小和气泡的margin一样大小，所以需要加上*2的间隙大小
            
            // 需要显示按钮,时间
            WdMessage* msgBlock = (WdMessage*)message;
            if (message.messageMediaType == XHBubbleMessageMediaTypeSystem) {
                ImSystemMsg* sysMsg = msgBlock.obj_id;
                if (sysMsg) {
                    switch (sysMsg.notice_type.intValue) {
                            
                        case WdSystemNoticeType_EpPayNotification:          //系统给雇主发送付款提醒
                        case WdSystemNoticeType_GetApplyFitst:              //获得首个报名
                        case WdSystemNoticeType_GetSnagFitst:               //获得首个抢单
                        case WdSystemNoticeType_JobApplyFull:               //岗位已报满
                        case WdSystemNoticeType_JobSnagEnd:                 //岗位已抢完
                        case WdSystemNoticeType_JkWorkTomorrow:             //系统提醒兼客明天上岗
                        case WdSystemNoticeType_JkMoneyAdd:                 //系统给兼客发的到账提醒
                        case WdSystemNoticeType_RechargeMoneySuccess:       //充值成功
                        case WdSystemNoticeType_GetMoneySuccess:            //取现成功
                        case WdSystemNoticeType_PaySuccess:                 //付款成功
                        case WdSystemNoticeType_EpCheckJobOver:             //雇主确认工作完成
                        case WdSystemNoticeType_IdAuthFail:                 //身份认证失败
                        case WdSystemNoticeType_EPRequestReport:            // 44 雇主发起打卡请求
                        case WdSystemNoticeType_PersonPoolPush:             // 46 才库推送通知
                        case WdSystemNoticeType_JKReceiveReportRequest:     // 45 兼客打卡通知(兼客收到雇主打卡通知)
                        case WdSystemNoticeType_SocialActivistBroadcast:    // 53：人脉王跳岗位详情广播消息
                        case WdSystemNoticeType_Reward:                     // 54：人脉王跳赏金页面广播消息
                        case WdSystemNoticeType_BDSendBillForPayToEP:       // 60: bd发送账单给雇主支付
                        case WdSystemNoticeType_BDSendBillForCheckToEp:     // 62: bd发送对账单给雇主
                        case WdSystemNoticeType_UnAuthLeaderGetMoney:       // 61: 未认证兼客获取领队薪资通知
                        case WdSystemNoticeType_SuccessOpenBDService:       // 64: 成功开通委托招聘服务
                        case WdSystemNoticeType_EPZaiTaskVerifyPast:         // 71: 雇主通过宅任务审核提醒
                        case WdSystemNoticeType_EPZaiTaskVerifyFail:         // 72: 雇主未通过宅任务审核提醒
                        case WdSystemNoticeType_missionTimeoutRemind:        // 73: 兼客提交任务截止时间前通知兼客提交任务
                        case WdSystemNoticeType_openUrlMessage:             // 78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
                        case WdSystemNoticeType_confirWork:                 // 80 确认上岗
                        case WdSystemNoticeType_interestJob:                // 81 意向岗位
                        case WdSystemNoticeType_advanceSalary:              // 82、预支工资推送
                        case WdSystemNoticeType_GzHasEvaluation:            // 8雇主已评介申请岗位
                        case WdSystemNoticeType_activistJobBroadcast:       // 83: 人脉王岗位推送
                        case WdSystemNoticeType_JkApply_Ep:                 //48：兼客申请岗位(雇主)
                        case WdSystemNoticeType_GzAgree:                    //3:雇主同意申请
                        case WdSystemNoticeType_jobVasPushMessage:          //85:岗位付费推送通知
                        case WdSystemNoticeType_topJobTimeOver:            // 86:岗位置顶过期通知
                        case WdSystemNoticeType_ServicePersonalInvite:  // 89:雇主个人服务邀约
                        case WdSystemNoticeType_JobVerifyFail:              //15：岗位审核未通过
                        case WdSystemNoticeType_RedirectJobVasPage:       // 92:跳转客户端付费推广页面
                        case WdSystemNoticeType_ServicePersonalImpoveWorkExperienceNotice:       // 93:个人服务更新案例消息提醒
                        case WdSystemNoticeType_InsuranceOrderFail:       // 94:兼职保险存在失败保单
                        case WdSystemNoticeType_PersonalServiceBackouted:       // 95:个人服务被下架
                        case WdSystemNoticeType_PersonalServiceOrderBackouted:       // 96:个人服务需求被下架
                        case WdSystemNoticeType_ServicePersonalAuditFail:  // 88:个人服务申请审核不通过
                        case WdSystemNoticeType_JobVerifySuccess:           //岗位审核通过
                        case WdSystemNoticeType_JkrzVerifyFaild:           //兼客认证审核未通过
                        case WdSystemNoticeType_JopAnswerQuestion :         // = 33 //关于岗位的提问和答复
                        {
                            bubbleSize = CGSizeMake(bubbleSize.width, bubbleSize.height + kXHreportBtnHeight); //这里*4的原因是：气泡内部的文本也做了margin，而且margin的大小和气泡的margin一样大小，所以需要加上*2的间隙大小
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
            break;
        }
        case XHBubbleMessageMediaTypeVoice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            CGSize needVoiceSize = [XHMessageBubbleView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            bubbleSize = CGSizeMake(needVoiceSize.width, needVoiceSize.height + kXHHaveBubbleVoiceMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeEmotion: {
            // 是否固定大小呢？
            CGSize emotionSize = [XHMessageBubbleView neededSizeForEmotion];
            bubbleSize = CGSizeMake(emotionSize.width, emotionSize.height + kXHHaveBubbleMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeVideo: {
            CGSize needVideoConverPhotoSize = [XHMessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            bubbleSize = CGSizeMake(needVideoConverPhotoSize.width, needVideoConverPhotoSize.height + kXHNoneBubblePhotoMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypePhoto: {
            CGSize needPhotoSize = [XHMessageBubbleView neededSizeForPhoto:message.photo];
            bubbleSize = CGSizeMake(needPhotoSize.width, needPhotoSize.height + kXHHaveBubblePhotoMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 固定大小，必须的
            CGSize localPostionSize = [XHMessageBubbleView neededSizeForLocalPostion];
            bubbleSize = CGSizeMake(localPostionSize.width, localPostionSize.height + kXHHaveBubblePhotoMargin * 2);
            break;
        }
        default:
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters

// 获取气泡的位置以及大小，比如有文字的气泡，语音的气泡，图片的气泡，地理位置的气泡，Emotion的气泡，视频封面的气泡
- (CGRect)bubbleFrame {
    // 1.先得到MessageBubbleView的实际大小
    CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:self.message];
    
    // 2.计算起泡的大小和位置
    CGFloat paddingX = 0.0f;
    if (self.message.bubbleMessageType == XHBubbleMessageTypeSending) {
        paddingX = CGRectGetWidth(self.bounds) - bubbleSize.width;
    }
    
    XHBubbleMessageMediaType currentMessageMediaType = self.message.messageMediaType;
    
    // 最终减去上下边距的像素就可以得到气泡的位置以及大小
    CGFloat marginY = 0.0;
    CGFloat topSumForBottom = 0.0;
    switch (currentMessageMediaType) {
        case XHBubbleMessageMediaTypeVoice:
            marginY = kXHHaveBubbleVoiceMargin;
            topSumForBottom = kXHHaveBubbleVoiceMargin * 2;
            break;
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeLocalPosition:
            marginY = kXHHaveBubblePhotoMargin;
            topSumForBottom = kXHHaveBubblePhotoMargin * 2;
            break;
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeEmotion:
        case XHBubbleMessageMediaTypeJob:
        {
            // 文本、视频、表情
            marginY = kXHHaveBubbleMargin;
            topSumForBottom = kXHHaveBubbleMargin * 2;
            break;
        }
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:         //系统通知消息
        case XHBubbleMessageMediaTypeImgText:        //图文消息:
//            ELog(@"======mark XHBubbleMessageMediaTypeJob")
            marginY = kXHHaveBubbleMargin;
            topSumForBottom = kXHHaveBubbleMargin * 2;
            break;
        default:
      
            break;
    }
    
    return CGRectMake(paddingX,
                      marginY,
                      bubbleSize.width,
                      bubbleSize.height - topSumForBottom);    
}

#pragma mark - Configure Methods

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    _voiceUnreadDotImageView.hidden = YES;
    _imgTextImageView.hidden = YES;
    
    switch (currentType) {
        case XHBubbleMessageMediaTypeVoice: {
            _voiceDurationLabel.hidden = NO;
            _voiceUnreadDotImageView.hidden = message.isRead;
        }
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeEmotion:
            
//=============================add
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:
//=============================end
        {
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            //隐藏图文消息
            _imgTextTextLabel.hidden = YES;     //add
            _imgTextTitleLabel.hidden = YES;    //add
            
            if (currentType == XHBubbleMessageMediaTypeText
//=============================add
                || currentType == XHBubbleMessageMediaTypeJob
                || currentType == XHBubbleMessageMediaTypeEnterprise
                || currentType == XHBubbleMessageMediaTypeSystem
//=============================add
                ) {
                // 如果是文本消息，那文本消息的控件需要显示
                _displayTextView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
                _emotionImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _displayTextView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == XHBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [XHMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _emotionImageView.hidden = NO;
                    
                    _bubbleImageView.hidden = YES;
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
            
        case XHBubbleMessageMediaTypeJob: // 岗位分享
        {
            // 显示
            _imgTextTextLabel.hidden = NO;
            _imgTextTitleLabel.hidden = NO;
            _imgTextImageView.hidden = NO;
            _bubbleImageView.hidden = NO;
            
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            
            // 隐藏
            _bubblePhotoImageView.hidden = YES;
            _videoPlayImageView.hidden = YES;
            _geolocationsLabel.hidden = YES;
            _displayTextView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            break;
        }
            
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;
            
            _videoPlayImageView.hidden = (currentType != XHBubbleMessageMediaTypeVideo);
            
            _geolocationsLabel.hidden = (currentType != XHBubbleMessageMediaTypeLocalPosition);
            
            // 那其他的控件都必须隐藏
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            
            //隐藏图文消息==================
            _imgTextTextLabel.hidden = YES;
            _imgTextTitleLabel.hidden = YES;
            break;
        }
//=============图文消息 暂时没添加 参考旧版 修改
        case XHBubbleMessageMediaTypeImgText:
        {
            ELog("=======消息的显示");
            _bubblePhotoImageView.hidden = NO;
            _videoPlayImageView.hidden = YES;
            _geolocationsLabel.hidden = YES;
            
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            
            _imgTextTextLabel.hidden = NO;
            _imgTextTitleLabel.hidden = NO;
        }
            break;
//============= end

        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <XHMessageModel>)message {
    
    WdMessage* msgBlock = (WdMessage*)message;
    BOOL bUnderLing = NO;
    
    _reportBtn.hidden = YES;
    _lookupDetailBtn.hidden = YES;
    _timeLabel.hidden = YES;
    
    // 设置字体颜色    
    if (((XHMessage *)message).bubbleMessageType == XHBubbleMessageTypeSending) {
        self.displayTextView.textColor = [UIColor whiteColor];
        self.imgTextTitleLabel.textColor = [UIColor whiteColor];
        self.imgTextTextLabel.textColor = [UIColor whiteColor];
        
    } else {
        self.displayTextView.textColor = [UIColor blackColor];
        self.imgTextTitleLabel.textColor = MKCOLOR_RGB(51, 51, 51);
        self.imgTextTextLabel.textColor = MKCOLOR_RGB(91, 91, 91);
    }
    
    
    if (message.messageMediaType == XHBubbleMessageMediaTypeSystem) {
        ImSystemMsg* sysMsg = msgBlock.obj_id;
        if (sysMsg) {
            switch (sysMsg.notice_type.intValue) {
                
                case WdSystemNoticeType_JkCancelApply:               //兼客取消申请岗位
                case WdSystemNoticeType_GzRefuse:                    //雇主拒绝申请
                case WdSystemNoticeType_JkAgree:                     //兼客同意录用
                case WdSystemNoticeType_JkRefuse:                    //兼客拒绝录用
                case WdSystemNoticeType_JkHasEvaluation:             //兼客已评介申请岗位
                case WdSystemNoticeType_QyrzVerifyPass:              //企业认证审核通过
                case WdSystemNoticeType_QyrzVerifyFaild:            //企业认证审核未通过
                case WdSystemNoticeType_JkrzVerifyPass:             //兼客认证审核已通过
                case WdSystemNoticeType_OpenImSucess:               //成功开通IM功能
                case WdSystemNoticeType_JobApplyComplain:           //岗位申请被投诉
                case WdSystemNoticeType_ReplyAdvice:                //建议反馈答复
                case WdSystemNoticeType_GzComplaintFgz:             //雇主投诉兼客放鸽子
                case WdSystemNoticeType_JkComplaintGzPost:          //兼客投诉雇主岗位
                case WdSystemNoticeType_ChangePhoneSuccess:         //手机号修改成功
                case WdSystemNoticeType_ChangePwdSuccess:           //密码修改成功
                case WdSystemNoticeType_IdAuthSuccess:              //身份认证成功
                case WdSystemNoticeType_EpCertificateAuthSuccess:   //营业执照认证成功
                case WdSystemNoticeType_EpCertificateAuthFail:      //营业执照认证失败
                case WdSystemNoticeType_JobBackouted:               //岗位被下架
                case WdSystemNoticeType_EpLookResume:               //雇主查看简历
                case WdSystemNoticeType_EpEvaluationJk:            //40：雇主评论兼客
                case WdSystemNoticeType_JkNotWorkConsultToEp:       //兼客未到岗(与雇主沟通一致)
                case WdSystemNoticeType_DeductRecognizance:        //扣除保证金
                case WdSystemNoticeType_JobMoveToComplete:          //岗位已移到已完成
                case WdSystemNoticeType_ServicePersonalAuditPass:   //个人服务申请审核通过
                case WdSystemNoticeType_AgreeServicePersonalInvite:      // 89:兼客同意个人服务邀约
                case WdSystemNoticeType_ApplyServiceTeam:       // 90:雇主预约团队服务
                case WdSystemNoticeType_JobApplyFull:               //岗位已报满

                    bUnderLing = NO;
                    break;
                    
                // 显示查看详情按钮
                case WdSystemNoticeType_EpPayNotification:          //系统给雇主发送付款提醒
                case WdSystemNoticeType_GetApplyFitst:              //获得首个报名
                case WdSystemNoticeType_GetSnagFitst:               //获得首个抢单
                
                case WdSystemNoticeType_JobSnagEnd:                 //岗位已抢完
                case WdSystemNoticeType_JkWorkTomorrow:             //系统提醒兼客明天上岗
                case WdSystemNoticeType_JkMoneyAdd:                 //系统给兼客发的到账提醒
                case WdSystemNoticeType_RechargeMoneySuccess:       //充值成功
                case WdSystemNoticeType_GetMoneySuccess:            //取现成功
                case WdSystemNoticeType_PaySuccess:                 //付款成功
                case WdSystemNoticeType_EpCheckJobOver:             //雇主确认工作完成
                case WdSystemNoticeType_IdAuthFail:                 //身份认证失败
                case WdSystemNoticeType_EPRequestReport:            // 44 雇主发起打卡请求
                case WdSystemNoticeType_PersonPoolPush:             // 46 才库推送通知
                case WdSystemNoticeType_Reward:                     // 54：人脉王跳赏金页面广播消息
                case WdSystemNoticeType_BDSendBillForPayToEP:       // 60: bd发送账单给雇主支付
                case WdSystemNoticeType_BDSendBillForCheckToEp:     // 62: bd发送对账单给雇主
                case WdSystemNoticeType_SuccessOpenBDService:       // 64: 成功开通委托招聘服务
                case WdSystemNoticeType_EPZaiTaskVerifyPast:         // 71: 雇主通过宅任务审核提醒
                case WdSystemNoticeType_EPZaiTaskVerifyFail:         // 72: 雇主未通过宅任务审核提醒
                case WdSystemNoticeType_missionTimeoutRemind:        // 73: 兼客提交任务截止时间前通知兼客提交任务
                case WdSystemNoticeType_openUrlMessage:             // 78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
                case WdSystemNoticeType_confirWork:                 // 80, 确认上岗
                case WdSystemNoticeType_interestJob:                // 81 意向岗位
                case WdSystemNoticeType_advanceSalary:               // 82、预支工资推送通知
                case WdSystemNoticeType_GzHasEvaluation:            // 8雇主已评介申请岗位
                case WdSystemNoticeType_JkApply_Ep:                 // 48：兼客申请岗位(雇主)
                case WdSystemNoticeType_GzAgree:                     // 3: 雇主同意申请
                case WdSystemNoticeType_jobVasPushMessage:          //岗位付费推送通知
                case WdSystemNoticeType_topJobTimeOver:           // 86:岗位置顶过期通知
                case WdSystemNoticeType_ServicePersonalInvite:  // 89:雇主个人服务邀约
                case WdSystemNoticeType_JobVerifyFail:              //15：岗位审核未通过
                case WdSystemNoticeType_InsuranceOrderFail:       // 94:兼职保险存在失败保单
                case WdSystemNoticeType_PersonalServiceBackouted:       // 95:个人服务被下架
                case WdSystemNoticeType_PersonalServiceOrderBackouted:       // 96:个人服务需求被下架
                case WdSystemNoticeType_ServicePersonalAuditFail:  // 88:个人服务申请审核不通过
                case WdSystemNoticeType_JobVerifySuccess:           //岗位审核通过
//                case WdSystemNoticeType_JopAnswerQuestion :         // = 33 //关于岗位的提问和答复
                case WdSystemNoticeType_JkrzVerifyFaild:           //兼客认证审核未通过
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                 case WdSystemNoticeType_JopAnswerQuestion :         // = 33 //关于岗位的提问和答复
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"去提问" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                case WdSystemNoticeType_activistJobBroadcast:       // 83: 人脉王岗位推送
                case WdSystemNoticeType_RedirectJobVasPage:       // 92:跳转客户端付费推广页面
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"去推广" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                // 更新案例
                case WdSystemNoticeType_ServicePersonalImpoveWorkExperienceNotice:       // 93:个人服务更新案例消息提醒
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"更新案例" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                // 去认证
                case WdSystemNoticeType_UnAuthLeaderGetMoney:       // 61: 未认证兼客获取领队薪资通知
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"去认证" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                // 显示去发广播按钮
                case WdSystemNoticeType_SocialActivistBroadcast:    // 53：人脉王跳岗位详情广播消息
                {
                    bUnderLing = NO;
                    _lookupDetailBtn.hidden = NO;
                    [_lookupDetailBtn setTitle:@"去接单" forState:UIControlStateNormal];
                    _reportBtn.hidden = YES;
                }
                    break;
                    
                // 显示打卡按钮
                case WdSystemNoticeType_JKReceiveReportRequest:     // 45 兼客打卡通知(兼客收到雇主打卡通知)
                {
                    
                    NSNumber *key = sysMsg.punch_the_clock_request_id;
                    NSNumber *value = [WDUserDefaults objectForKey:[NSString stringWithFormat:@"%@_%@", sysMsg.apply_job_id, key]];
                    
                    if (value.integerValue == 0) { // 未打卡
                        
                        // 判断是否过期
                        NSDate *punchTime = [NSDate dateWithTimeIntervalSince1970:sysMsg.punch_the_clock_time.longLongValue * 0.001];
                        if ([punchTime isToday]) { // 未过期
                            
                            _reportBtn.enabled = YES;
                            [_reportBtn setImage:nil forState:UIControlStateNormal];
                            [_reportBtn setTitle:@"立即打卡" forState:UIControlStateNormal];
                            
                        } else { // 已过期
                            
                            [_reportBtn setImage:nil forState:UIControlStateNormal];
                            [_reportBtn setTitle:@"已过期" forState:UIControlStateNormal];
                            _reportBtn.enabled = NO;
                        }
                        
                    } else { // 已打卡
                        
                        [_reportBtn setImage:[UIImage imageNamed:@"v210_lg"] forState:UIControlStateNormal];
                        [_reportBtn setTitle:@"已完成" forState:UIControlStateNormal];
                        _reportBtn.enabled = NO;
                    }
                    
                    bUnderLing = NO;
                    _reportBtn.hidden = NO;
                    _lookupDetailBtn.hidden = YES;
                }
                    break;
                    
                    default:
                    break;
            }
        }
        if (!bUnderLing) {
            _displayTextView.attributedText = [[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
        }
        
        _timeLabel.text = [DateHelper getTimeRangeWithSecond:@(msgBlock.timestamp.timeIntervalSince1970)];
        _timeLabel.hidden = NO;
    }
    
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            _displayTextView.attributedText = [[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
            _timeLabel.text = [DateHelper getTimeRangeWithSecond:@(msgBlock.timestamp.timeIntervalSince1970)];
            _timeLabel.hidden = NO;
            break;
        case XHBubbleMessageMediaTypePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVideo:
            [_bubblePhotoImageView configureMessagePhoto:message.videoConverPhoto thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVoice:
            self.voiceDurationLabel.text = [NSString stringWithFormat:@"%@\'\'", message.voiceDuration];
            break;
        case XHBubbleMessageMediaTypeEmotion:
            // 直接设置GIF
            if (message.emotionPath) {
                NSData *animatedData = [NSData dataWithContentsOfFile:message.emotionPath];
                FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
                _emotionImageView.animatedImage = animatedImage;
            }
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType];
            
            _geolocationsLabel.text = message.geolocations;
            break;
            
//====================
        case XHBubbleMessageMediaTypeJob: // 岗位分享
        {
            ImPacket* packet = [ImDataManager packetFromRCMessage:msgBlock.rcMsg];
            ImShareJobMessage *shareJobMsg = [packet.dataObj getMessageContent];
            
            _imgTextTitleLabel.text = shareJobMsg.title;
            _imgTextTextLabel.text = shareJobMsg.desc;
            [_imgTextImageView sd_setImageWithURL:[NSURL URLWithString:shareJobMsg.jobIcon] placeholderImage:[UIHelper getDefaultImage]];
            
            _timeLabel.text = [DateHelper getTimeRangeWithSecond:@(msgBlock.timestamp.timeIntervalSince1970)];
            _timeLabel.hidden = NO;
            bUnderLing = NO;
            break;
        }
            
        case XHBubbleMessageMediaTypeEnterprise:
        {
            _timeLabel.text = [DateHelper getTimeRangeWithSecond:@(msgBlock.timestamp.timeIntervalSince1970)];
            _timeLabel.hidden = NO;
            bUnderLing = YES;
            break;
        }

        case XHBubbleMessageMediaTypeImgText:
        {
            ELog(@"=====配置显示 图文消息");
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.thumbnailUrl onBubbleMessageType:self.message.bubbleMessageType];
            _imgTextTitleLabel.text = message.title;
            _imgTextTextLabel.text = message.text;
            break;
        }
        default:
            break;
    }
    
    if (bUnderLing) {
        NSMutableAttributedString* attriString = [[NSMutableAttributedString alloc] initWithString:[message text]];
        [attriString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, [message text].length)];
        _displayTextView.attributedText = attriString;
    }
//=========================================
    self.timeLabel.hidden = msgBlock.isHiddenTime;
    [self setNeedsLayout];
}

- (void)configureVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - CGRectGetWidth(voiceFrame) : bubbleFrame.origin.x + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
}

- (void)configureVoiceUnreadDotImageViewFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceUnreadDotFrame = _voiceUnreadDotImageView.frame;
    voiceUnreadDotFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x + kXHUnReadDotSize : CGRectGetMaxX(bubbleFrame) - kXHUnReadDotSize * 2);
    voiceUnreadDotFrame.origin.y = CGRectGetMidY(bubbleFrame) - kXHUnReadDotSize / 2.0;
    _voiceUnreadDotImageView.frame = voiceUnreadDotFrame;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            FLAnimatedImageView *bubbleImageView = [[FLAnimatedImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_displayTextView) {
            SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
//            displayTextView.textColor = [UIColor colorWithWhite:0.143 alpha:1.000];
            displayTextView.backgroundColor = [UIColor clearColor];
            displayTextView.selectable = NO;
            displayTextView.lineSpacing = kXHTextLineSpacing;
            displayTextView.font = [[XHMessageBubbleView appearance] font];
            displayTextView.showsEditingMenuAutomatically = NO;
            displayTextView.highlighted = NO;
            [self addSubview:displayTextView];
            _displayTextView = displayTextView;
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
            
            if (!_videoPlayImageView) {
                UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
                [bubblePhotoImageView addSubview:videoPlayImageView];
                _videoPlayImageView = videoPlayImageView;
            }
            
            if (!_geolocationsLabel) {
                UILabel *geolocationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                geolocationsLabel.numberOfLines = 0;
                geolocationsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                geolocationsLabel.textColor = [UIColor whiteColor];
                geolocationsLabel.backgroundColor = [UIColor clearColor];
                geolocationsLabel.font = [UIFont systemFontOfSize:12];
                [bubblePhotoImageView addSubview:geolocationsLabel];
                _geolocationsLabel = geolocationsLabel;
            }
        }
        
        // 4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 28, 20)];
            voiceDurationLabel.textColor = [UIColor colorWithWhite:0.579 alpha:1.000];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:13.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentCenter;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            _voiceDurationLabel = voiceDurationLabel;
        }
        
        // 5、初始化显示gif表情的控件
        if (!_emotionImageView) {
            FLAnimatedImageView *emotionImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:emotionImageView];
            _emotionImageView = emotionImageView;
        }
        
        // 6. 初始化显示语音未读标记的imageview
        if (!_voiceUnreadDotImageView) {
            NSString *voiceUnreadImageName = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableVoiceUnreadImageNameKey];
            if (!voiceUnreadImageName) {
                voiceUnreadImageName = @"msg_chat_voice_unread";
            }
            
            UIImageView *voiceUnreadDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXHUnReadDotSize, kXHUnReadDotSize)];
            voiceUnreadDotImageView.image = [UIImage imageNamed:voiceUnreadImageName];
            voiceUnreadDotImageView.hidden = YES;
            [self addSubview:voiceUnreadDotImageView];
            _voiceUnreadDotImageView = voiceUnreadDotImageView;
        }
//==============================
        // 7. 初始化 图文消息 的标题
        if (!_imgTextTitleLabel) {

            UILabel* itTitleLabel = [[UILabel alloc] init];
            itTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            itTitleLabel.textColor = [UIColor blackColor];
            itTitleLabel.font = [UIFont systemFontOfSize:17];
            [self addSubview:itTitleLabel];
            _imgTextTitleLabel = itTitleLabel;
        }
        // 8. 初始化 图文消息 的 文本
        if (!_imgTextTextLabel) {
            
            UILabel* itTextLabel = [[UILabel alloc] init];
            itTextLabel.numberOfLines = 2;
            itTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            itTextLabel.textColor = [UIColor grayColor];
            itTextLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:itTextLabel];
            _imgTextTextLabel = itTextLabel;
        }
        
        if (!_imgTextImageView) {
         
            UIImageView *imgTextImageView = [[UIImageView alloc] init];
            [self addSubview:imgTextImageView];
            _imgTextImageView = imgTextImageView;
        }
//==============================
        
        // 时间Label
        if (!_timeLabel) {
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = [UIFont systemFontOfSize:13.0f];
//            34 57 80, 0.24
            [timeLabel setCornerValue:3.0f];
            timeLabel.backgroundColor = [UIColor colorWithRed:34/255.0 green:57/255.0 blue:88/255.0 alpha:0.24];
            timeLabel.textColor = [UIColor whiteColor];
//            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.hidden = YES;
            [self addSubview:timeLabel];
            _timeLabel = timeLabel;
        }
        
        // 查看详情按钮
        if (!_lookupDetailBtn) {
            BaseButton *lookupDetailBtn = [[BaseButton alloc] init];
            lookupDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [lookupDetailBtn setTitleColor:[UIColor XSJColor_tGrayMiddle] forState:UIControlStateNormal];
            [lookupDetailBtn setImage:[UIImage imageNamed:@"info_icon_push_2"] forState:UIControlStateNormal];
//            lookupDetailBtn.layer.cornerRadius = 2;
//            lookupDetailBtn.layer.borderWidth = 1;
//            lookupDetailBtn.layer.borderColor = [UIColor XSJColor_base].CGColor;
//            lookupDetailBtn.layer.masksToBounds = YES;
            [lookupDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [lookupDetailBtn addTarget:self action:@selector(lookupDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            lookupDetailBtn.hidden = YES;
            [self addSubview:lookupDetailBtn];
            _lookupDetailBtn = lookupDetailBtn;
        }
        
        // 打卡按钮
        if (!_reportBtn) {
            BaseButton *reportBtn = [[BaseButton alloc] init];
//            [reportBtn setBackgroundImage:[UIImage imageNamed:@"v250_daka_bg"] forState:UIControlStateNormal];
//            [reportBtn setBackgroundImage:[UIImage imageNamed:@"v250_yidaka_bg"] forState:UIControlStateDisabled];
            [reportBtn setImage:[UIImage imageNamed:@"info_icon_push_2"] forState:UIControlStateNormal];
            reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [reportBtn setTitleColor:[UIColor XSJColor_tGrayMiddle] forState:UIControlStateNormal];
            [reportBtn setTitleColor:MKCOLOR_RGBA(0, 0, 0, 0.25) forState:UIControlStateDisabled];
//            [reportBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
            [reportBtn setTitle:@"立即打卡" forState:UIControlStateNormal];
            [reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            reportBtn.hidden = YES;
            [self addSubview:reportBtn];
            _reportBtn = reportBtn;
        }
        
        // 标题 add by kizy
        if (!_titleLab) {
            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.font = [UIFont boldSystemFontOfSize:17.0f];
            titleLab.textColor = MKCOLOR_RGB(34, 58, 80);
            [self addSubview:titleLab];
            _titleLab = titleLab;
        }
        
        
    }
    return self;
}

- (void)dealloc {
    _message = nil;
    
    _displayTextView = nil;
    
    _bubbleImageView = nil;
    
    _bubblePhotoImageView = nil;
    
    _animationVoiceImageView = nil;
    
    _voiceUnreadDotImageView = nil;
    
    _voiceDurationLabel = nil;
    
    _emotionImageView = nil;
    
    _videoPlayImageView = nil;
    
    _geolocationsLabel = nil;
    
    _font = nil;

//==============================
    _imgTextTitleLabel = nil;
    _imgTextTextLabel = nil;
    _imgTextImageView = nil;
//==============================

    _timeLabel = nil;
    _lookupDetailBtn = nil;
    _reportBtn = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
//    self.backgroundColor = [UIColor blueColor];
//    self.displayTextView.backgroundColor = [UIColor blackColor];
    switch (currentType) {
//==============================
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:
//==============================
            
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeEmotion: {
            // 获取实际气泡的大小
            self.bubbleImageView.frame = bubbleFrame;
            if (currentType == XHBubbleMessageMediaTypeText || currentType == XHBubbleMessageMediaTypeEnterprise || currentType == XHBubbleMessageMediaTypeSystem) {
                CGFloat textX = -(kXHArrowMarginWidth / 2.0);
                if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                    textX = kXHArrowMarginWidth / 2.0;
                }
                
                if (![self.message isHiddenTime]) {
                    // 要显示时间
                    
                    self.timeLabel.height = kXHtimeLabelHeight;
                    self.timeLabel.width = [XHMessageBubbleView getTimeLabelWidthWithText:self.timeLabel.text] + 20;
                    self.timeLabel.x = SCREEN_WIDTH/2 - self.timeLabel.width/2;
                    self.timeLabel.y = KXHTimeLabelTopAndBottomPadding;
                    self.bubbleImageView.y = CGRectGetMaxY(self.timeLabel.frame) + KXHTimeLabelTopAndBottomPadding;
                    
                    CGPoint point = [self convertPoint:self.timeLabel.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
                    
                    CGFloat margin = point.x - self.timeLabel.x;
                    self.timeLabel.x -= margin;
                    
                }
                
                bubbleFrame = self.bubbleImageView.frame;
                CGRect displayTextViewFrame = CGRectZero;
                displayTextViewFrame.size.width = CGRectGetWidth(bubbleFrame) - kXHLeftTextHorizontalBubblePadding - kXHRightTextHorizontalBubblePadding - kXHArrowMarginWidth;
                displayTextViewFrame.size.height = CGRectGetHeight(bubbleFrame) - kXHHaveBubbleMargin * 3;
                self.displayTextView.frame = displayTextViewFrame;
                self.displayTextView.center = CGPointMake(self.bubbleImageView.center.x + textX, self.bubbleImageView.center.y);
                
                if ([self.message isShowTitle]) {
                    self.titleLab.x = kXHLeftTextHorizontalBubblePadding;
                    self.titleLab.y = kXHTopAndBottomBubbleMargin;
                    self.titleLab.width = CGRectGetWidth(bubbleFrame) - kXHLeftTextHorizontalBubblePadding - kXHRightTextHorizontalBubblePadding - kXHArrowMarginWidth;
                    self.titleLab.height = 24;
                }else{
                }
                

                
                // 需要显示按钮,时间
                WdMessage* msgBlock = (WdMessage*)self.message;
                if (self.message.messageMediaType == XHBubbleMessageMediaTypeSystem) {
                    ImSystemMsg* sysMsg = msgBlock.obj_id;
                    if (sysMsg) {
                        switch (sysMsg.notice_type.intValue) {
                                
                            case WdSystemNoticeType_EpPayNotification:          //系统给雇主发送付款提醒
                            case WdSystemNoticeType_GetApplyFitst:              //获得首个报名
                            case WdSystemNoticeType_GetSnagFitst:               //获得首个抢单
                            case WdSystemNoticeType_JobApplyFull:               //岗位已报满
                            case WdSystemNoticeType_JobSnagEnd:                 //岗位已抢完
                            case WdSystemNoticeType_JkWorkTomorrow:             //系统提醒兼客明天上岗
                            case WdSystemNoticeType_JkMoneyAdd:                 //系统给兼客发的到账提醒
                            case WdSystemNoticeType_RechargeMoneySuccess:       //充值成功
                            case WdSystemNoticeType_GetMoneySuccess:            //取现成功
                            case WdSystemNoticeType_PaySuccess:                 //付款成功
                            case WdSystemNoticeType_EpCheckJobOver:             //雇主确认工作完成
                            case WdSystemNoticeType_IdAuthFail:                 //身份认证失败
                            case WdSystemNoticeType_EPRequestReport:            // 44 雇主发起打卡请求
                            case WdSystemNoticeType_PersonPoolPush:             // 46 才库推送通知
                            case WdSystemNoticeType_JKReceiveReportRequest:     // 45 兼客打卡通知(兼客收到雇主打卡通知)
                            case WdSystemNoticeType_SocialActivistBroadcast:    // 53：人脉王跳岗位详情广播消息
                            case WdSystemNoticeType_Reward:                     // 54：人脉王跳赏金页面广播消息
                            case WdSystemNoticeType_BDSendBillForPayToEP:       // 60: bd发送账单给雇主支付
                            case WdSystemNoticeType_UnAuthLeaderGetMoney:       // 61: 未认证兼客获取领队薪资通知
                            case WdSystemNoticeType_BDSendBillForCheckToEp:     // 62: bd发送对账单给雇主
                            case WdSystemNoticeType_SuccessOpenBDService:       // 64: 成功开通委托招聘服务
                            case WdSystemNoticeType_EPZaiTaskVerifyPast:         // 71: 雇主通过宅任务审核提醒
                            case WdSystemNoticeType_EPZaiTaskVerifyFail:         // 72: 雇主未通过宅任务审核提醒
                            case WdSystemNoticeType_missionTimeoutRemind:        // 73: 兼客提交任务截止时间前通知兼客提交任务
                            case WdSystemNoticeType_openUrlMessage:             // 78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
                            case WdSystemNoticeType_confirWork:                 // 80, 确认上岗
                            case WdSystemNoticeType_interestJob:                // 81 意向岗位
                            case WdSystemNoticeType_advanceSalary:               // 82、预支工资推送通知
                            case WdSystemNoticeType_GzHasEvaluation:            // 8雇主已评介申请岗位
                            case WdSystemNoticeType_activistJobBroadcast:       // 83: 人脉王岗位推送
                            case WdSystemNoticeType_JkApply_Ep:                 //48：兼客申请岗位(雇主)
                            case WdSystemNoticeType_GzAgree:                   //3: 雇主同意申请
                            case WdSystemNoticeType_jobVasPushMessage:          //岗位付费推送通知
                            case WdSystemNoticeType_topJobTimeOver:             // 86:岗位置顶过期通知
                            case WdSystemNoticeType_ServicePersonalInvite:  // 89:雇主个人服务邀约
                            case WdSystemNoticeType_JobVerifyFail:              //15：岗位审核未通过
                            case WdSystemNoticeType_RedirectJobVasPage:       // 92:跳转客户端付费推广页面
                            case WdSystemNoticeType_ServicePersonalImpoveWorkExperienceNotice:       // 93:个人服务更新案例消息提醒
                            case WdSystemNoticeType_InsuranceOrderFail:       // 94:兼职保险存在失败保单
                            case WdSystemNoticeType_PersonalServiceBackouted:       // 95:个人服务被下架
                            case WdSystemNoticeType_PersonalServiceOrderBackouted:       // 96:个人服务需求被下架
                            case WdSystemNoticeType_ServicePersonalAuditFail:  // 88:个人服务申请审核不通过
                            case WdSystemNoticeType_JobVerifySuccess:           //岗位审核通过
                            case WdSystemNoticeType_JkrzVerifyFaild:           //兼客认证审核未通过
                            case WdSystemNoticeType_JopAnswerQuestion :         // = 33 //关于岗位的提问和答复
                            {
                                
                                //lookupDetailBtn
                                self.lookupDetailBtn.width = bubbleFrame.size.width - kXHArrowMarginWidth;
                                self.lookupDetailBtn.height = kXHLookupDetailBtnHeight;
                                self.lookupDetailBtn.x = kXHArrowMarginWidth;
                                self.lookupDetailBtn.y = CGRectGetMaxY(self.displayTextView.frame) - kXHLookupDetailBtnHeight + KXHTimeLabelTopAndBottomPadding;
                                [self.lookupDetailBtn addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_grayLine] isConstraint:NO];
                                [self.lookupDetailBtn setMarginForImg:-8 marginForTitle:8];
                                
                                // reportBtn
                                self.reportBtn.frame = self.lookupDetailBtn.frame;
                                [self.reportBtn addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_grayLine] isConstraint:NO];
                                [self.reportBtn setMarginForImg:-8 marginForTitle:8];
                                
                            }
                                break;

                                default:
                                break;
                        }
                    }
                }
            }
            
            if (currentType == XHBubbleMessageMediaTypeVoice) {
                // 配置语音播放的位置
                CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
                CGFloat voiceImagePaddingX = CGRectGetMaxX(bubbleFrame) - kXHVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame);
                if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                    voiceImagePaddingX = CGRectGetMinX(bubbleFrame) + kXHVoiceMargin;
                }
                animationVoiceImageViewFrame.origin = CGPointMake(voiceImagePaddingX, CGRectGetMidY(bubbleFrame) - CGRectGetHeight(animationVoiceImageViewFrame) / 2.0);  // 垂直居中
                self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
                
                [self configureVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
                [self configureVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
            }
            
            if (currentType == XHBubbleMessageMediaTypeEmotion) {
                CGRect emotionImageViewFrame = bubbleFrame;
                emotionImageViewFrame.size = [XHMessageBubbleView neededSizeForEmotion];
                self.emotionImageView.frame = emotionImageViewFrame;
            }
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            CGSize needPhotoSize = [XHMessageBubbleView neededSizeForPhoto:self.message.photo];
            CGFloat paddingX = 0.0f;
            if (self.message.bubbleMessageType == XHBubbleMessageTypeSending) {
                paddingX = CGRectGetWidth(self.bounds) - needPhotoSize.width;
            }
            
            CGFloat marginY = kXHNoneBubblePhotoMargin;
            if (currentType == XHBubbleMessageMediaTypePhoto || currentType == XHBubbleMessageMediaTypeLocalPosition) {
                marginY = kXHHaveBubblePhotoMargin;
            }
            
            CGRect photoImageViewFrame = CGRectMake(paddingX, marginY, needPhotoSize.width, needPhotoSize.height);
            
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
//========================
        case XHBubbleMessageMediaTypeImgText:   // 图文消息 暂时丢这里
        {
            ELog(@"===========图文消息 暂时丢这里======有走这里吗");
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x, 40, bubbleFrame.size.width, bubbleFrame.size.height-80);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            break;
        }
//========================
            
        case XHBubbleMessageMediaTypeJob:   //  岗位分享
        {
            _bubbleImageView.frame = bubbleFrame;
            
            CGFloat x = bubbleFrame.origin.x;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                
                x = bubbleFrame.origin.x + kXHLeftTextHorizontalBubblePadding;
            }
            
            _imgTextImageView.frame = CGRectMake(x + kXHLeftTextHorizontalBubblePadding - 5, kXHLeftTextHorizontalBubblePadding * 2, 50, 50);
            _imgTextTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imgTextImageView.frame) + kXHLeftTextHorizontalBubblePadding, _imgTextImageView.y, bubbleFrame.size.width - kXHLeftTextHorizontalBubblePadding * 3 - 50, 20);
            
            _imgTextTextLabel.frame = CGRectMake(_imgTextTitleLabel.x, CGRectGetMaxY(_imgTextTitleLabel.frame), _imgTextTitleLabel.width, 40);
            
            _timeLabel.frame = CGRectMake(_imgTextImageView.x, bubbleFrame.size.height - 20, bubbleFrame.size.width - 2 * kXHLeftTextHorizontalBubblePadding, 20);
            
            break;
        }

        default:
            break;
    }
}

#pragma mark - 按钮点击事件
- (void)lookupDetailBtnClick:(UIButton *)btn
{
    DLog(@"查看详情");
    if ([self.delegate respondsToSelector:@selector(lookupDetailBtn:click:)]) {
        [self.delegate lookupDetailBtn:btn click:self.message];
    }
}

- (void)reportBtnClick:(UIButton *)btn
{
    DLog(@"打卡");
    if ([self.delegate respondsToSelector:@selector(reportBtn:click:)]) {
        [self.delegate reportBtn:btn click:self.message];
    }
}


@end
