//
//  NewsView.m
//  jianke
//
//  Created by fire on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "NewsView.h"
#import "UIView+MKExtension.h"
#import "JKHomeModel.h"

@interface NewsView()

@property (nonatomic, strong) NSArray<AdModel *> *modelArray; /*!< 存放JKNewsModel模型的数组 */
@property (nonatomic, weak) NewsBtn *nextBtn;
@property (nonatomic, weak) NewsBtn *currentBtn;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NewsView

- (instancetype)initWithNewsModelArray:(NSArray *)aModelArray size:(CGSize)aSize
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.width = aSize.width;
        self.height = aSize.height;
        self.modelArray = aModelArray;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if (!self.modelArray.count) {
        return;
    }
    
    CGFloat titleImgViewWidth = 92;
    
    UIImageView *titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v240_jk_news"]];
    titleImgView.contentMode = UIViewContentModeCenter;
    titleImgView.frame = CGRectMake(0, 0, titleImgViewWidth, self.height);
    [self addSubview:titleImgView];
    
    self.index = 0;
    AdModel *model = self.modelArray[self.index];
    NewsBtn *currentBtn = [[NewsBtn alloc] initWithModel:model size:CGSizeMake(self.width - titleImgViewWidth, self.height)];
    [currentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    currentBtn.x = titleImgViewWidth;
    currentBtn.y = 0;
    [self addSubview:currentBtn];
    self.currentBtn = currentBtn;
    
    NewsBtn *nextBtn = [[NewsBtn alloc] initWithModel:model size:CGSizeMake(self.width - titleImgViewWidth, self.height)];
    [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.x = titleImgViewWidth;
    nextBtn.y = self.height;
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
//    lineView.backgroundColor = MKCOLOR_RGB(220, 220, 220);
//    [self addSubview:lineView];
    
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(playNews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)playNews{
    if (self.index >= self.modelArray.count - 1) {
        self.index = 0;
    } else {
        self.index += 1;
    }
    
    AdModel *model = self.modelArray[self.index];
    self.nextBtn.model = model;
    
    [UIView animateWithDuration:0.8 animations:^{
        self.currentBtn.y = - self.height;
        self.nextBtn.y = 0;
    } completion:^(BOOL finished) {
        self.currentBtn.y = self.height;
        NewsBtn *tmpBtn = self.currentBtn;
        self.currentBtn = self.nextBtn;
        self.nextBtn = tmpBtn;
        tmpBtn = nil;
    }];
}

- (void)btnClick:(NewsBtn *)btn{
    DLog(@"兼客头条新闻点击");
    if ([self.delegate respondsToSelector:@selector(newsView:btnClick:)]) {
        [self.delegate newsView:self btnClick:btn];
    }
}

- (void)dealloc{
    [self.timer invalidate];
}



@end
