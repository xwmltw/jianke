//
//  GuideUIManager.m
//  jianke
//
//  Created by xiaomk on 16/6/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "GuideUIManager.h"
#import "XSJConst.h"
#import "MKBlurView.h"
#import "JKHomeModel.h"
#import "XSJAlertView.h"

#pragma mark - ***** GuideUIManager ******
@implementation GuideUIManager

static NSString * const XSJUD_GuideUIType_jobDetailBaozhao =    @"XSJUD_GuideUIType_jobDetailBaozhao";
static NSString * const XSJUD_GuideUIType_EPHomeScrollAd =      @"XSJUD_GuideUIType_EPHomeScrollAd";
static NSString * const XSJUD_GuideUIType_jobDetailRMW =        @"XSJUD_GuideUIType_jobDetailRMW";

+ (void)showGuideWithType:(GuideUIType)type block:(GuideUIManagerBlock)block{
    if (type == GuideUIType_jobDetailBaozhao) {
        BOOL isShowYet = [WDUserDefaults boolForKey:XSJUD_GuideUIType_jobDetailBaozhao];
        if (isShowYet) {
            return;
        }
        [WDUserDefaults setBool:YES forKey:XSJUD_GuideUIType_jobDetailBaozhao];
        [WDUserDefaults synchronize];
        
        GuideView *guideView = [[GuideView alloc] initWithType:type block:block];
        [guideView show];
        
    }else if (type == GuideUIType_EPHomeScrollAd){
        ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
        if (globaModel) {
            if (globaModel.ent_pop_up_ad_list && globaModel.ent_pop_up_ad_list.count > 0) {
                NSArray *adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.ent_pop_up_ad_list];
                NSString *adIdStr = @"";
                for (AdModel *adModel in adArrayData) {
                    adIdStr = [adIdStr stringByAppendingString:adModel.ad_id.stringValue];
                }
                
                
                NSString *adHistoryStr = [WDUserDefaults stringForKey:XSJUD_GuideUIType_EPHomeScrollAd];
                if (adHistoryStr && [adHistoryStr isEqualToString:adIdStr]) {
                    return;
                }
                [WDUserDefaults setObject:adIdStr forKey:XSJUD_GuideUIType_EPHomeScrollAd];
                [WDUserDefaults synchronize];
                
                GuideView *guideView = [[GuideView alloc] initWithType:type block:block];
                [guideView show];
            }
        }
    }else if (type == GuideUIType_jobDetailRMW){
        if ([[UserData sharedInstance] getLoginType].intValue == WDLoginType_Employer) {
            return;
        }
        BOOL isShowYet = [WDUserDefaults boolForKey:XSJUD_GuideUIType_jobDetailRMW];
        if (isShowYet) {
            return;
        }
        [WDUserDefaults setBool:YES forKey:XSJUD_GuideUIType_jobDetailRMW];
        [WDUserDefaults synchronize];
        //人脉王 分享 弹窗
        XSJAlertView *alertView = [[XSJAlertView alloc] initWithTitle:@"分享岗位得佣金" message:@"分享岗位，让兼客通过您分享的链接报名并最终完工，即可轻松拿到佣金，您可以到「个人中心」我是人脉王中查看您的推广情况。"];
        alertView.directPoint = CGPointMake(SCREEN_WIDTH-30, 46);
        [alertView showWithBlock:nil];
    }
}
@end



#pragma mark - ***** GuideView ******
@interface GuideView()<UIScrollViewDelegate>{
    NSInteger _guideScrollViewViewCount;
    NSArray *_adArrayData;
}

@property (nonatomic, copy) GuideUIManagerBlock block;
@property (nonatomic, assign) GuideUIType type;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation GuideView

- (instancetype)initWithType:(GuideUIType)type block:(GuideUIManagerBlock)block{
    if (self = [super init]) {
        _guideScrollViewViewCount = 0;

        self.frame = MKSCREEN_BOUNDS;
        self.type = type;
        if (block) {
            self.block = block;
        }
        [self setupUI];
    }
    return self;
}


- (void)setupUI{

    if (self.type == GuideUIType_jobDetailBaozhao) {
        self.backgroundColor = [UIColor XSJColor_shadeBg];

        UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBg.frame = self.bounds;
        btnBg.tag = -1;
        [btnBg addTarget:self action:@selector(btnCloseOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBg];
        
        self.backgroundColor = [UIColor XSJColor_shadeBg];

        UIImageView *guideimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v3_job_baozhao"]];
        [self addSubview:guideimg];
        [guideimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(100);
        }];
    }else if (self.type == GuideUIType_EPHomeScrollAd){
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.5);

        ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
        if (globaModel) {
            if (globaModel.ent_pop_up_ad_list && globaModel.ent_pop_up_ad_list.count > 0) {
                _adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.ent_pop_up_ad_list];
            }
        }

        
        if (_adArrayData && _adArrayData.count > 0) {
//            MKBlurView *blurView = [[MKBlurView alloc] initWithFrame:self.bounds];
//            [self addSubview:blurView];
            
            _guideScrollViewViewCount = _adArrayData.count;
            
            [self addSubview:self.scrollView];
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * _guideScrollViewViewCount, self.bounds.size.height);
            
            for (NSInteger index = 0; index < _guideScrollViewViewCount; index++) {
                AdModel *adModel = [_adArrayData objectAtIndex:index];
                UIView* pageView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width*index, 0, self.bounds.size.width, self.bounds.size.height)];
                pageView.backgroundColor = [UIColor clearColor];
                [self.scrollView addSubview:pageView];
                
                UIButton *btnAd = [UIButton buttonWithType:UIButtonTypeCustom];
                btnAd.tag = index;
                [btnAd addTarget:self action:@selector(btnAdOnclick:) forControlEvents:UIControlEventTouchUpInside];
//                [btnAd sd_setImageWithURL:[NSURL URLWithString:adModel.img_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultAdBgImage]];
                [btnAd sd_setBackgroundImageWithURL:[NSURL URLWithString:adModel.img_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultAdBgImage]];
//                UIImageView* pageImg = [[UIImageView alloc] init];
//                [pageImg sd_setImageWithURL:[NSURL URLWithString:adModel.img_url] placeholderImage:[UIHelper getDefaultAdBgImage]];
                [pageView addSubview:btnAd];
                
//                592*770
                CGFloat btnWidth = self.bounds.size.width - 64;
                [btnAd mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(pageView);
                    make.width.mas_equalTo(btnWidth);
                    make.height.mas_equalTo(btnWidth*770/592);
                    make.bottom.equalTo(pageView.mas_bottom).offset(-140);
                }];
            }
            
            [self addSubview:self.pageControl];
            _pageControl.numberOfPages = _guideScrollViewViewCount;
            WEAKSELF
            [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf).offset(-90);
            }];
            
            [self setCloseButton];

        }
    }
}


- (void)btnAdOnclick:(UIButton *)sender{
    if (self.type == GuideUIType_EPHomeScrollAd) {
        AdModel *adModel = [_adArrayData objectAtIndex:sender.tag];
        MKBlockExec(self.block, self, adModel);
    }
}

- (void)btnCloseOnclick:(UIButton *)sender{
    [self hide];
    MKBlockExec(self.block, nil, nil);
}

- (void)show{
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    [window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - ***** UIScrollView type ******
- (void)setCloseButton{
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setImage:[UIImage imageNamed:@"v3_public_close_white"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-48);
    }];
}

/** 添加pageControl */
- (void)setupPageControl{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.numberOfPages = _guideScrollViewViewCount;
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor XSJColor_tGrayMiddle];
    pageControl.pageIndicatorTintColor = [UIColor XSJColor_grayLabBg];
    
    WEAKSELF
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-100);
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.bounds = CGRectMake(0, 0, 100, 30);
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor XSJColor_tGrayMiddle];
        _pageControl.pageIndicatorTintColor = [UIColor XSJColor_grayLabBg];
    }
    return _pageControl;
}

/** UIScrollerView delegate */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;

    // 2.求出页码
    double pageDouble = offsetX / SCREEN_WIDTH;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



