//
//  ActivateAdvertView.m
//  jianke
//
//  Created by xiaomk on 16/7/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ActivateAdvertView.h"
#import "UserData.h"
#import "WDConst.h"
#import "JKHomeModel.h"
#import "NewFeature_VC.h"
#import "ClientVersionModel.h"
#import "ClientGlobalInfoRM.h"
#import "XSJRequestHelper.h"
#import "XSJUserInfoData.h"
#import "XSJNetWork.h"
#import "JKHomeModel.h"


@interface ActivateAdvertView(){
    
}

@property (nonatomic, strong) UIView *viewADBg;         /*!< 广告背景 */
@property (nonatomic, weak) UIImageView *imgAdView;

@property (nonatomic, weak) UIButton *btnCancel;
@property (nonatomic, weak) UIButton *btnAD;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AdModel *adModel;

@end

@implementation ActivateAdvertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
    //底部 固定View
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_lanuch_icon"]];
    
    UILabel *lab = [UILabel labelWithText:[NSString stringWithFormat:@"V%@", [MKDeviceHelper getAppBundleShortVersion]] textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    
    [self addSubview:imgView];
    [self addSubview:lab];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-24);
    }];
    
    //广告 背景
    self.viewADBg = [[UIView alloc] init];
    UIImageView *img1 = [[UIImageView alloc] init];
    _imgAdView = img1;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [button setCornerValue:10.0f];
    [button addTarget:self action:@selector(btnCancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    _btnCancel = button;
    button.hidden = YES;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(btnADOnClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.hidden = YES;
    _btnAD = button1;
    
    [self addSubview:self.viewADBg];
    [self.viewADBg addSubview:img1];
    [self.viewADBg addSubview:button1];
    [self.viewADBg addSubview:button];
    
    [self.viewADBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.viewADBg);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewADBg).offset(-16);
        make.top.equalTo(self.viewADBg).offset(28);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(36);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.viewADBg);
    }];
    
    [self initData];
}

- (void)initData{
    [[UserData sharedInstance] setLoginStatus:NO];
    
    WEAKSELF
    int versionInt = [MKDeviceHelper getAppIntVersion];
    [[XSJNetWork sharedInstance] createSession:^(id response) {
        [[XSJRequestHelper sharedInstance] postDeviceInfoWithBlock:^(id obj) {
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoMust:YES withBlock:^(ClientGlobalInfoRM* result) {
                if (result) {
                    //检查版本更新
                    ClientVersionModel* cvmModel = result.version_info;
                    if (cvmModel && cvmModel.version.intValue > versionInt) {
                        if (cvmModel.need_force_update.integerValue == 1) {
                            [UIHelper showConfirmMsg:@"有新的版本啦，请更新到最新版本吧！" title:@"提示" cancelButton:@"更新" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cvmModel.url]];
                                }
                            }];
                        }else{
                            [UIHelper showConfirmMsg:@"有新的版本啦，请更新到最新版本吧！" title:@"提示" cancelButton:@"暂不更新" okButton:@"更新" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [weakSelf alertContinue:nil];
                                }else if(buttonIndex == 1){
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cvmModel.url]];
                                }
                            }];
                        }
                        return ;
                    }
                }
                [weakSelf alertContinue:result];
            }];
        }];
    }];
}

- (void)alertContinue:(ClientGlobalInfoRM *)globalRM{
    
    NSString* lastVersion = [WDUserDefaults stringForKey:WDUserDefault_CFBundleVersion];
    NSString* currentVersion = [MKDeviceHelper getAppBundleVersion];
    if (![currentVersion isEqualToString:lastVersion]) {     //新版本
        //设置第一次登录状态
        if ([[UserData sharedInstance] getLoginType].integerValue != WDLoginType_Employer) {
            [[XSJUserInfoData sharedInstance] setIsOpenAppYet:NO];
        }
        [WDUserDefaults setObject:currentVersion forKey:WDUserDefault_CFBundleVersion];
        [WDUserDefaults setBool:YES forKey:NewFeatureAboutBindWechat];
        [WDUserDefaults setBool:NO forKey:LoginSuccessNoticeBindWechat];
        [WDUserDefaults synchronize];
        //是否隐藏新特性
        if (![UserData sharedInstance].hiddenNewFeature) {
            [self removeFromSuperview];
            NewFeature_VC* vc = [[NewFeature_VC alloc] init];
            [UIHelper setKeyWindowWithVC:vc];
        }else{
            [self removeFromSuperview];
            MKBlockExec(self.block, @1);
            
        }
    }else{                                                  //旧版本
        [WDUserDefaults setBool:NO forKey:NewFeatureAboutBindWechat];
        [WDUserDefaults synchronize];
        
        if (globalRM && globalRM.start_front_ad_list.count) {
            [self showAD:globalRM];
        }else{
            [self removeFromSuperview];
            MKBlockExec(self.block, @1);
        }
    }
}

- (void)showAD:(ClientGlobalInfoRM *)globalRM{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timeOnOver) userInfo:nil repeats:NO];
    NSArray *ads = [AdModel objectArrayWithKeyValuesArray:globalRM.start_front_ad_list];
    self.adModel = ads[0];
    [self.imgAdView sd_setImageWithURL:[NSURL URLWithString:self.adModel.img_url]];
    self.btnCancel.hidden = NO;
    self.btnAD.hidden = NO;
}

- (void)timeOnOver{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self removeFromSuperview];
    MKBlockExec(self.block, @1);
}

- (void)btnCancelOnClick:(UIButton *)sender{
    [self removeFromSuperview];
    MKBlockExec(self.block, @1);
}

- (void)btnADOnClick:(UIButton *)sender{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self removeFromSuperview];
    MKBlockExec(self.block, self.adModel);
}

- (void)dealloc{
    DLog(@"StarAdvert_VC dealloc");
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
