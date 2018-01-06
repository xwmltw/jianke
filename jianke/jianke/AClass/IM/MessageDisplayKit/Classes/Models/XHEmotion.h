//
//  XHEmotion.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXHEmotionImageViewSize 38

//======添加表情删除功能键
typedef NS_ENUM(NSInteger, EmotionType){
    EmotionType_Emoji = 1,      //表情
    EmotionType_Delete = 2,     //删除功能
};
//====================

@interface XHEmotion : NSObject

/**
 *  gif表情的封面图
 */
@property (nonatomic, strong) UIImage *emotionConverPhoto;      //改成删除按钮专用

/**
 *  gif表情的路径
 */
@property (nonatomic, copy) NSString *emotionPath;              //已经改成表情对应的text符号


//add:自定义熟悉
@property (nonatomic, assign) EmotionType emotionType;          //表情类型


@end
