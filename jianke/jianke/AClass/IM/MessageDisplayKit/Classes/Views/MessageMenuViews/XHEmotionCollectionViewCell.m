//
//  XHEmotionCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewCell.h"

@interface XHEmotionCollectionViewCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIImageView *emotionImageView;
@property (nonatomic, weak) UILabel *emotionLabel;
/**
 *  配置默认控件和参数
 */
- (void)setup;
@end

@implementation XHEmotionCollectionViewCell

#pragma setter method

- (void)setEmotion:(XHEmotion *)emotion {
    _emotion = emotion;
    
    // TODO:
    if (emotion.emotionConverPhoto) {
        self.emotionImageView.image = emotion.emotionConverPhoto;
    } else if (emotion.emotionPath) {
        self.emotionLabel.text = emotion.emotionPath;
    }
    
    self.emotionLabel.hidden = emotion.emotionType != EmotionType_Emoji;
    self.emotionImageView.hidden = emotion.emotionType != EmotionType_Delete;
}

#pragma mark - Life cycle

- (void)setup {
    
    CGRect frame = self.contentView.frame;
    if (!_emotionImageView) {
        
        float height = frame.size.height/1.5;
        
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - height/2, frame.size.width, height)];
//        emotionImageView.backgroundColor = [UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:1.000];
        emotionImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:emotionImageView];
        self.emotionImageView = emotionImageView;
    }
    
    if (!_emotionLabel) {
        
        UILabel *emotionImageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        emotionImageView.font = [UIFont systemFontOfSize:34];
        emotionImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:emotionImageView];
        emotionImageView.textAlignment = NSTextAlignmentCenter;
        self.emotionLabel = emotionImageView;
        
//        CGFloat red = arc4random()%100/100.0;
//        CGFloat green = arc4random()%100/100.0;
//        CGFloat blue = arc4random()%100/100.0;
//        UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
//        self.contentView.backgroundColor = color;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotion = nil;
}

@end
