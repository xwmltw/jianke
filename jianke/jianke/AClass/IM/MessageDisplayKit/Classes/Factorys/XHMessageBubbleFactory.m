//
//  XHMessageBubbleFactory.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleFactory.h"
#import "XHMacro.h"
#import "XHConfigurationHelper.h"

@implementation XHMessageBubbleFactory

+ (UIImage *)bubbleImageViewForType:(XHBubbleMessageType)type
                                  style:(XHBubbleImageViewStyle)style
                              meidaType:(XHBubbleMessageMediaType)mediaType {
    NSString *messageTypeString = @"v3_msg_msg_bg";
    
    switch (style) {
        case XHBubbleImageViewStyleWeChat:
            // 类似微信的
//            messageTypeString = @"weChatBubble";
            break;
        default:
            break;
    }
    
    switch (type) {
//            msg_msg_bg_left  msg_msg_bg_right
        case XHBubbleMessageTypeSending:
            // 发送
            messageTypeString = [messageTypeString stringByAppendingString:@"_right"];
            break;
        case XHBubbleMessageTypeReceiving:
            // 接收
            messageTypeString = [messageTypeString stringByAppendingString:@"_left"];
            break;
        default:
            break;
    }
    
//    switch (mediaType) {
//        case XHBubbleMessageMediaTypePhoto:
//        case XHBubbleMessageMediaTypeVideo:
//            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
//            break;
////add======================end
//        case XHBubbleMessageMediaTypeJob:
//        case XHBubbleMessageMediaTypeEnterprise:
//        case XHBubbleMessageMediaTypeSystem:
////======================end
//        case XHBubbleMessageMediaTypeText:
//        case XHBubbleMessageMediaTypeVoice:
//            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
//            break;
//        default:
//            break;
//    }
    
    if (type == XHBubbleMessageTypeReceiving) {
        NSString *receivingSolidImageName = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableReceivingSolidImageNameKey];
        if (receivingSolidImageName) {
            messageTypeString = receivingSolidImageName;
        }
    } else {
        NSString *sendingSolidImageName = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableSendingSolidImageNameKey];
        if (sendingSolidImageName) {
            messageTypeString = sendingSolidImageName;
        }
    }
    
    UIImage *bublleImage = [UIImage imageNamed:messageTypeString];
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInsetsWithStyle:style];
    UIImage *edgeBubbleImage = XH_STRETCH_IMAGE(bublleImage, bubbleImageEdgeInsets);
    return edgeBubbleImage;
}

+ (UIEdgeInsets)bubbleImageEdgeInsetsWithStyle:(XHBubbleImageViewStyle)style {
    UIEdgeInsets edgeInsets;
    switch (style) {
        case XHBubbleImageViewStyleWeChat:
            // 类似微信的
            edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
            break;
        default:
            break;
    }
    return edgeInsets;
}

@end
