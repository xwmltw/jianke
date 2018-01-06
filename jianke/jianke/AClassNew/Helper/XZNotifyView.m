//
//  XZNotifyView.m
//  jianke
//
//  Created by xuzhi on 16/9/11.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZNotifyView.h"
#import "WDConst.h"
#import "WebView_VC.h"

@interface XZNotifyView ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UILabel *titelLab;    /*!< 通知标题 */
@property (nonatomic, strong) UILabel *contentLab;    /*!< 通知内容 */
@property (nonatomic, strong) UIImageView *imgIcon; /*!< 通知icon */
@property (nonatomic, assign) CGFloat orignY;
@property (nonatomic, copy) MKBlock didShowBlock; /*!< 视图显示完成回调 */
@property (nonatomic, copy) MKBlock dismissBlock;   /*!< 视图消失时回调 */
@property (nonatomic, copy) MKBlock clickBlock; /*!< 点击时回调 */

@end

@implementation XZNotifyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = 64;
        self.orignY = -64;
        self.backgroundColor = [UIColor blackColor];
        [self addGestureRecognizer];
        
        self.titelLab = [[UILabel alloc] init];
        self.titelLab.text = @"兼客兼职";
        self.titelLab.textColor = [UIColor whiteColor];
        self.titelLab.font = [UIFont systemFontOfSize:10.0f];
        
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.numberOfLines = 0;
        self.contentLab.textColor = [UIColor whiteColor];
        self.contentLab.font = [UIFont systemFontOfSize:14.0f];
        
        self.imgIcon = [[UIImageView alloc] init];
        self.imgIcon.image = [UIImage imageNamed:@"guide_logo"];

        [self addSubview:self.imgIcon];
        [self addSubview:self.titelLab];
        [self addSubview:self.contentLab];
        
        [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6);
            make.left.equalTo(self).offset(12);
            make.width.height.equalTo(@20);
        }];
        
        [self.titelLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgIcon);
            make.left.equalTo(self.imgIcon.mas_right).offset(6);
        }];
        
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLab.mas_bottom).offset(6);
            make.left.equalTo(self.titelLab);
            make.right.equalTo(self).offset(-12);
            make.height.lessThanOrEqualTo(@38);
        }];
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)content{
    if (self = [self init]) {
        self.frame = CGRectMake(0, self.orignY, SCREEN_WIDTH, self.height);
        self.contentLab.text = content;
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)content url:(NSString *)url{
    if (self = [self initWithContent:content]) {
        _url = url;
    }
    return self;
}

#pragma mark - static menthod

+ (void)showWithContent:(NSString *)content url:(NSString *)url{
    [self showWithContent:content url:url clickBlock:nil];
}

+ (void)showWithContent:(NSString *)content clickBlock:(MKBlock)clickBlock{
    [self showWithContent:content url:nil clickBlock:clickBlock];
}

+ (void)showWithContent:(NSString *)content url:(NSString *)url clickBlock:(MKBlock)clickBlock{
    [self showWithContent:content url:url didShowBlock:nil clickBlock:clickBlock dismissBlock:nil];
    
}

+ (void)showWithContent:(NSString *)content url:(NSString *)url didShowBlock:(MKBlock)didShowBlock clickBlock:(MKBlock)clickBlock dismissBlock:(MKBlock)dismissBlock{
    XZNotifyView *notifyView = [[XZNotifyView alloc] initWithContent:content url:url];
    notifyView.contentLab.text = content;
    notifyView.didShowBlock = didShowBlock;
    notifyView.clickBlock = clickBlock;
    notifyView.dismissBlock = dismissBlock;
    [notifyView show];
    [notifyView palyVedio];
}

#pragma mark - 私有方法
- (void)show{
    self.frame = CGRectMake(0, -(self.height), SCREEN_WIDTH, self.height);
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.window.windowLevel = UIWindowLevel_switchView;
    [self.window addSubview:self];
    self.window.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {
        [UserData delayTask:2.0f onTimeEnd:^{
            [self close];
        }];
    }];
}

- (void)palyVedio{
    [UIHelper playSound];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)close{
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewOnClick:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)viewOnClick:(UITapGestureRecognizer *)tapGesture{
    [self close];
    if (self.url.length > 0) {
        [self pushWeb];
    }
    MKBlockExec(self.clickBlock, nil);
}

- (void)pushWeb{
    if (self.url.length <= 0) {
        NSAssert(NO, @"***********url链接不能为空");
        return;
    }
    WebView_VC *webVC = [[WebView_VC alloc] init];
    webVC.url = self.url;
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl && viewCtrl.navigationController) {
        webVC.hidesBottomBarWhenPushed = YES;
        [viewCtrl.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)dealloc{
    ELog(@"通知栏消失了~");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
