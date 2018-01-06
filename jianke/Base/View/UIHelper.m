//
//  UIHelper.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHelper.h"
#import "UIView+Toast.h"
#import "WDConst.h"
#import "Login_VC.h"
#import "Masonry.h"
#import "WDLoadingView.h"
#import "ImDataManager.h"
#import "SwitchIdentity_View.h"
#import "XSJUIHelper.h"
#import "MKUIHelper.h"
#import "RequestParamWrapper.h"
#import "JobController.h"

#import "MainTabbarCtlMgr.h"
#import "XSJSessionMgr.h"

@implementation UIHelper

#pragma mark - 场景切换
+ (void)showLoginVC:(BOOL)isShowGuide withBlock:(MKBlock)block{
    Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    loginVC.isShowGuide = isShowGuide;
    loginVC.blcok = block;
    MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
    UIViewController* current = [MKUIHelper getCurrentRootViewController];
    while (current.presentedViewController) {
        current = current.presentedViewController;
    }
    [current presentViewController:vc animated:YES completion:nil];
}

+ (void)showLoginVCWithBlock:(MKBlock)block{
    [self showLoginVC:NO withBlock:block];
}

+ (void)hideCustomWindow{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == UIWindowLevel_custom) {
            [window resignKeyWindow];
            window.hidden = YES;
        }
    }
}

+ (void)loginOutToView{
    [self loginOutRequest];
    [[XSJUserInfoData sharedInstance] clearStaticObj];
    [[ImDataManager sharedInstance] loginOutRCIM];
    [[UserData sharedInstance] loginOutUpdateData];
    [XSJUIHelper showMainScene];
    [WDNotificationCenter postNotificationName:WDNotifi_setLoginOut object:nil];
    
    [self hideCustomWindow];
}

+ (void)loginOutRequest{
    if ([[UserData sharedInstance] isLogin]) {
        RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_userLogout" andContent:nil];
        [request sendRequestWithResponseBlock:^(id response) {
//            [UIHelper toast:@"退出"];
        }];
    }
}


#pragma mark - view 通用方法
//将 vc 设置成根 控制器
+ (void)setKeyWindowWithVC:(id)vc{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = vc;
}

+ (void)setWindowRootVCWith:(id)vc{
    UIViewController* current = [MKUIHelper getCurrentRootViewController];
//    [current removeFromParentViewController];
//    [current.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    current.view.window.rootViewController = vc;
}

+ (id)getVCFromStoryboard:(NSString *)nameStoryboard identify:(NSString *)nameVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:nameStoryboard bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:nameVC];
}


#pragma mark - View 归档
//归档
+ (UIView *)duplicate:(UIView *)view{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


#pragma mark - debug 可用 遍历view下的子控件并打印
+ (void)printSubViewWithView:(UIView*)superView{
    static uint level = 0;
    for (uint i = 0; i < level; i++) {
        printf("\t");
    }
    const char* className = NSStringFromClass([superView class]).UTF8String;
    const char* frame = NSStringFromCGRect(superView.frame).UTF8String;
    ELog(@"============================================");
    printf("%s:%s\n",className,frame);
    ++level;
    for (UIView* view in superView.subviews) {
        [self printSubViewWithView:view];
    }
    --level;
}

+ (UIView *)addImage:(NSString *)img to:(UIView *)parent WithStr:(NSString *)str{
    CGSize rect = SCREEN_SIZE;
    CGFloat width = rect.width;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 100)];
    CGRect viewFrame = view.frame;
    CGRect frame = parent.frame;
    viewFrame.origin.x = frame.size.width/2 - viewFrame.size.width/2;
    viewFrame.origin.y = frame.size.height/2 - viewFrame.size.height/2;
    view.frame = viewFrame;
    view.userInteractionEnabled = NO;
    
    UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    imgv.frame = CGRectMake(0, 0, width, 50);
    imgv.contentMode = UIViewContentModeCenter;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, width, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = str;
    lab.font = [UIFont systemFontOfSize:10];
    lab.textColor = [UIColor grayColor];
    
    [view addSubview:imgv];
    [view addSubview:lab];
    
    [parent addSubview:view];
    return view;
}

#pragma mark - 计算 label size
+ (CGSize)getSizeWithString:(NSString*)string width:(CGFloat)width font:(UIFont*)font{
    CGSize labSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return labSize;
}

#pragma mark - showMsg Alert
+ (void)showMsg:(NSString *)msg{
    [self showMsg:msg andTitle:@"提示"];
}
+ (void)showMsg:(NSString *)msg andTitle:(NSString *)title{
    [self showMsg:msg title:title okBtnTitle:@"我知道了"];
}
+ (void)showNoTitleMsg:(NSString*)msg{
    [self showMsg:nil andTitle:msg];
}


+ (void)showMsg:(NSString *)msg title:(NSString *)title okBtnTitle:(NSString *)btnTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:btnTitle
                                              otherButtonTitles:nil, nil];
    [alertView show];
}



+ (void)toast:(NSString *)msg{
    [XSJUIHelper showToast:msg];
}

+ (void)toast:(NSString *)msg inView:(UIView *)view{
    [XSJUIHelper showToast:msg inView:view];
}

+ (void)showConfirmMsg:(NSString*)msg completion:(DLAVAlertViewCompletionHandler)completion{
    [self showMsgBoxWithTitle:nil
                          msg:msg
                 cancelButton:@"取消"
                     okButton:@"确定"
                   completion:completion];
}

+ (void)showConfirmMsg:(NSString*)msg okButton:(NSString*)okButton completion:(DLAVAlertViewCompletionHandler)completion{    
    [self showMsgBoxWithTitle:nil
                          msg:msg
                 cancelButton:@"取消"
                     okButton:okButton
                   completion:completion];
}

+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title okButton:(NSString*)okButton completion:(DLAVAlertViewCompletionHandler)completion{
    [self showMsgBoxWithTitle:title
                          msg:msg
                 cancelButton:@"取消"
                     okButton:okButton
                   completion:completion];
}

+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title cancelButton:(NSString*)cancelTitle completion:(DLAVAlertViewCompletionHandler)completion{
    [self showMsgBoxWithTitle:title
                          msg:msg
                 cancelButton:cancelTitle
                     okButton:nil
                   completion:completion];
}

+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion{
    [self showMsgBoxWithTitle:title
                          msg:msg
                 cancelButton:cancelTitle
                     okButton:okTitle
                   completion:completion];
}

//确认消息框
+ (void)showMsgBoxWithTitle:(NSString*)title msg:(NSString*)msg cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion{
    if (!msg && !title) {
        return;
    }
    
    if (!title) {
        title = msg;
        msg = nil;
    }

    DLAVAlertView* exportAlertView = [[DLAVAlertView alloc] initWithTitle:title
                                                                  message:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:cancelTitle
                                                        otherButtonTitles:okTitle, nil];
    if (msg) {
        UIFont* labFont = [UIFont systemFontOfSize:14];
        //    CGFloat contentViewWidth = SCREEN_WIDTH - 68 - 16;
        CGFloat contentViewWidth = 320 - 48 - 16;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            contentViewWidth = exportAlertView.frame.size.width-16;
        }
        CGSize labSize = [UIHelper getSizeWithString:msg width:contentViewWidth font:labFont];
        UILabel* msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentViewWidth, labSize.height)];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.text = msg;
        msgLabel.textColor = [UIColor blackColor];
        msgLabel.font = labFont;
        msgLabel.numberOfLines = 0;
        
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentViewWidth, labSize.height+4)];
        [contentView addSubview:msgLabel];
        exportAlertView.contentView = contentView;
    }
   
    [exportAlertView showWithCompletion:completion];
}

//带 textfiel 的输入框
- (void)showTextFieldMsgBoxWithTitle:(NSString*)title msg:(NSString*)msg placeholder:(NSString*)placeholder cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion{
    
    NSString* titleStr;
    if (title) {
        titleStr = title;
    }else{
        titleStr = msg;
    }
    DLAVAlertView* exportAlertView = [[DLAVAlertView alloc] initWithTitle:titleStr
                                                                  message:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:cancelTitle
                                                        otherButtonTitles:okTitle, nil];
    CGFloat edgeWidth = 32;
    CGFloat contentViewOriginY = 0;
    CGFloat tfEdgeWidth = 8;
    CGFloat tfOriginY = 0;
    if (msg) {
//        CGFloat labEdgeWidth = 8;
//        CGFloat labOriginY = 0;
        UIFont* labFont = [UIFont systemFontOfSize:16];
        CGSize labSize = [UIHelper getSizeWithString:msg width:SCREEN_WIDTH - edgeWidth*2 - tfEdgeWidth*2  font:labFont];
        
        UILabel* msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(tfEdgeWidth, tfOriginY, SCREEN_WIDTH - edgeWidth*2 - tfEdgeWidth*2, labSize.height)];
        msgLabel.textAlignment = NSTextAlignmentLeft;
        msgLabel.text = msg;
        msgLabel.textColor = [UIColor darkGrayColor];
        msgLabel.font = labFont;
        msgLabel.numberOfLines = 0;
        
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewOriginY, SCREEN_WIDTH - edgeWidth*2, 1)];
        exportAlertView.contentView = contentView;

    }else{
        UITextView* tvEdit = [[UITextView alloc] initWithFrame:CGRectMake(tfEdgeWidth, 0, SCREEN_WIDTH - edgeWidth*2 - tfEdgeWidth*2, 200)];
        tvEdit.text = @"请输入。。。";
        tvEdit.textAlignment = NSTextAlignmentLeft;
        tvEdit.delegate = self;
        tvEdit.editable = YES;
        tvEdit.tag = 200;
        
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewOriginY, SCREEN_WIDTH - edgeWidth*2, tvEdit.frame.size.height)];
        [contentView addSubview:tvEdit];
        exportAlertView.contentView = contentView;
    }
    [exportAlertView show];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 200) {
        ELog(@"====1");
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.tag == 200) {
        ELog(@"====2");
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 200) {
        ELog(@"====3");
    }
}



#pragma mark - 默认占位 图片
static UIImage* s_defaultHead;
+ (UIImage *)getDefaultHead{
    if (!s_defaultHead) {
        s_defaultHead = [UIImage imageNamed:@"info_person_yuan"];
    }
    return s_defaultHead;
}

static UIImage* s_defaultHeadRect;
+ (UIImage *)getDefaultHeadRect{
    if (!s_defaultHeadRect) {
        s_defaultHeadRect =[UIImage imageNamed:@"info_person_fang"];
    }
    return s_defaultHeadRect;
}

static UIImage* s_defaultImage;
+ (UIImage *)getDefaultImage{
    if (!s_defaultImage) {
        s_defaultImage = [UIImage imageNamed:@"public_img_temporary"];
    }
    return s_defaultImage;
}

static UIImage* s_defaultAdBgImage;
+ (UIImage *)getDefaultAdBgImage{
    if (!s_defaultAdBgImage) {
        s_defaultAdBgImage = [UIImage imageNamed:@"v3_public_defaultAd"];
    }
    return s_defaultAdBgImage;
}

+ (UIImageView*)createShadowLine{
    UIImageView* lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_line_shadow"]];
    return lineImgView;
}

#pragma mark - 九宫格图片设置
+ (UIImage*)getRectImage:(NSString*)imgName with:(UIEdgeInsets)uidegeInsets{
    UIImage* bgImage = [UIImage imageNamed:imgName];
    bgImage = [bgImage resizableImageWithCapInsets:uidegeInsets];
    return bgImage;
}

#pragma mark - 黏贴板
+ (void)copyToPasteboard:(NSString *)str{
    if (!str) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
}

#pragma mark - 设置 view 的 圆角 和 边框
+ (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color withView:(UIView*)view{
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+ (void)setCorner:(UIView *)view{
    [self setCorner:view withValue:4.0];
}

+ (void)setCorner:(UIView *)view withValue:(CGFloat)value{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:value];
}

+ (void)setToCircle:(UIView *)view{
    [self setCorner:view withValue:view.width/2];
}


#pragma mark - 显示message到指定View中
/** 显示message到指定View中 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view
{
    // message额定尺寸
    CGFloat maxW = view.width * 0.7;
    CGFloat maxH = view.height * 0.7;
    CGSize maxSize = CGSizeMake(maxW, maxH);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    CGRect rect = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];

    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    
    [view addSubview:label];
    label.center = view.center;
}

#pragma mark - 替换字符串
+ (NSMutableString *)replaceString:(NSString*)originStr str1:(NSString*)str1 toStr2:(NSString*)str2{
    NSMutableString* oStr = [NSMutableString stringWithString:originStr];
    NSString* search = str1;
    NSString* replace = str2;
    NSRange subStr = [originStr rangeOfString:search];
    
    while (subStr.location != NSNotFound) {
        [oStr replaceCharactersInRange:subStr withString:replace];
        subStr = [oStr rangeOfString:search];
    }
    return oStr;
}

#pragma mark - 添加 无网络 无数据 view
+ (UIView *)noDataViewWithTitleArr:(NSArray *)noDataTipArr titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle{
    if (!titleColor) {
        titleColor = [UIColor XSJColor_base];
    }
    UIView *noDataView = [[UIView alloc] init];
    noDataView.backgroundColor = [UIColor clearColor];
    noDataView.size = SCREEN_SIZE;
    
    UIImageView *noDataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [noDataView addSubview:noDataImgView];
    
    NSString *noDataTip;
    UILabel *tipLabel;
    CGFloat preHeight = 0;
    for (NSInteger index = 0; index < noDataTipArr.count; index ++) {
        noDataTip = [noDataTipArr objectAtIndex:index];
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = titleColor;
        tipLabel.numberOfLines = 0;
        tipLabel.text = noDataTip;
        tipLabel.tag = 666 + index;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = (index == 0) ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:14] ;
        [noDataView addSubview:tipLabel];
        
        CGFloat height = [tipLabel contentSizeWithWidth:240].height;
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noDataImgView.mas_bottom).offset(10 * (index + 1) + preHeight * index);
            make.centerX.equalTo(noDataView.mas_centerX);
            make.width.mas_lessThanOrEqualTo(@240);
            
        }];
        preHeight = height;
    }
    
    UIButton *button = nil;
    if (btnTitle && btnTitle.length) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor XSJColor_base]];
        button.tag = 998;
        [button setCornerValue:3.0f];
        [noDataView addSubview:button];
    }
    
    [noDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noDataView.mas_centerX);
        make.top.equalTo(noDataView.mas_top);
    }];
    
    if (button) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(20);
            make.centerX.equalTo(noDataView);
            make.height.equalTo(@39);
            make.width.greaterThanOrEqualTo(@97);
        }];
    }
    
    return noDataView;
}

+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle{
    return [self noDataViewWithTitleArr:@[noDataTip] titleColor:titleColor image:image button:btnTitle];
}

+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip titleColor:(UIColor*)titleColor image:(NSString *)image{
    return [self noDataViewWithTitle:noDataTip titleColor:titleColor image:image button:nil];
}

+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip image:(NSString *)image{
    return [self noDataViewWithTitle:noDataTip titleColor:[UIColor XSJColor_base] image:image];
}

+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip{
    return [self noDataViewWithTitle:noDataTip image:@"v3_public_nodata"];
}

#pragma mark - 转菊花
static WDLoadingView *loadView;
/** 转菊花 */
+ (void)showLoading:(BOOL)isShow withMessage:(NSString *)message{
    UIViewController* vc = [MKUIHelper getCurrentRootViewController];
    [self showLoading:isShow withMessage:message inView:vc.view];
}

/** 转菊花 */
+ (void)showLoading:(BOOL)isShow withMessage:(NSString *)message inView:(UIView *)view{
    if (isShow) {
        if (!view) {
            return;
        }
        if (loadView == nil) {
            loadView = (WDLoadingView *)[WDLoadingView initAnimation];
        }
        [view addSubview:loadView];
        loadView.hidden = NO;
        
        if (message) {
            loadView.labelText = message;
        }else{
            loadView.labelText = @"加载中";
        }
    } else {
        if (loadView) {
            [loadView removeFromSuperview];
            loadView = nil;
        }
    }
}

#pragma mark - 创建UITableView
+ (UITableView *)createTableViewWithStyle:(UITableViewStyle) style delegate:(id)target onView:(UIView *)view{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tableView.delegate = target;
    tableView.dataSource = target;
    [view addSubview:tableView];
    return tableView;
}

#pragma mark - IM 收到消息 音效
static SystemSoundID sms_received_id = 0;
+ (void)playSound{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"rc_sms-received" ofType:@"caf"];
        if (path) {
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sms_received_id);
            AudioServicesPlaySystemSound(sms_received_id);
        }
    });
  
    
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - 其他 没用到的
/** 在指定View中显示loading动画 */
+ (UIView *)loadingWithMessage:(NSString *)message{
    UIView *loadingView=[[UIView alloc]init];
    
    loadingView.backgroundColor=[UIColor clearColor];
    CGSize viewSize=[UIScreen mainScreen].bounds.size;
    CGRect viewFrame=CGRectMake(0, 0, viewSize.width, viewSize.height);
    loadingView.frame = viewFrame;
    
    CGRect tmpviewFrame;
    tmpviewFrame.size.height = 100;
    tmpviewFrame.size.width = 100;
    tmpviewFrame.origin.x = (viewFrame.size.width - tmpviewFrame.size.width) * 0.5;
    tmpviewFrame.origin.y = (viewFrame.size.height - tmpviewFrame.size.height) *0.35;
    
    UIView *backView=[[UIView alloc]initWithFrame:tmpviewFrame];
    backView.backgroundColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
    
    [UIHelper setCorner:backView withValue:tmpviewFrame.size.width * 0.1];
    CGRect imgvFrame;
    imgvFrame.size.height = 60;
    imgvFrame.size.width = 60;
    imgvFrame.origin.x = (tmpviewFrame.size.width - imgvFrame.size.width) * 0.5;
    imgvFrame.origin.y = 14;
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.frame = imgvFrame;
    
    // 添加lab
    UILabel *lab= [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 100, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = message;
    
    // 1.加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i< 4; i++) {
        NSString *filename = [NSString stringWithFormat:@"loading_%d.png", i];
        UIImage *image = [UIImage imageNamed:filename];
        [images addObject:image];
    }
    imgv.animationImages = images;
    
    // 2.设置播放次数
    imgv.animationRepeatCount = 9999;
    
    // 3.设置播放时间
    imgv.animationDuration = 0.6;
    [imgv startAnimating];
    
    [backView addSubview:imgv];
    [backView addSubview:lab];
    [loadingView addSubview:backView];
    return loadingView;
}

+ (UIView*)addNoDataViewTo:(UIView*)parent WithStr:(NSString*)str{
    //    CGSize rect=[DataHelper getScreenSize];
    CGFloat width = SCREEN_WIDTH;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 100)];
    CGRect viewFrame = view.frame;
    CGRect frame = parent.frame;
    viewFrame.origin.x = frame.size.width/2 -viewFrame.size.width/2;
    viewFrame.origin.y = frame.size.height/2 -viewFrame.size.height;
    view.frame = viewFrame;
    view.userInteractionEnabled=NO;
    
    UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_icon_warning"]];
    imgv.frame=CGRectMake(0, 0, width, 50);
    imgv.contentMode=UIViewContentModeCenter;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80,width, 30)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text = str;
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor grayColor];
    
    [view addSubview:imgv];
    [view addSubview:lab];
    
    [parent addSubview:view];
    return view;
}

+ (UIView*)addNoDataViewTo:(UIView*)parent {
    return [UIHelper addNoDataViewTo:parent WithStr:@"没有数据"];
}

static UIWindow* s_switchWindow;
+ (void)showSwitchAnimationWindowIsToEP:(BOOL)isToEP{
    if (!s_switchWindow) {
        s_switchWindow = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
        s_switchWindow.windowLevel = UIWindowLevel_switchView;
    }
    s_switchWindow.hidden = NO;
    
    SwitchIdentity_View *aniView = [[SwitchIdentity_View alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    aniView.isToEP = isToEP;
    WEAKSELF
    aniView.boolBlock = ^(BOOL end){
        if (end) {
            [weakSelf hideSwitchAnimationWindow];
        }
    };
    [s_switchWindow addSubview:aniView];
    [aniView starAnimation];
}

+ (void)hideSwitchAnimationWindow{
    if (s_switchWindow) {
        [UIView animateWithDuration:0.4f animations:^{
            s_switchWindow.alpha = 0;
        } completion:^(BOOL finished) {
            [s_switchWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            s_switchWindow.hidden = YES;
            s_switchWindow.alpha = 1;
        }];
    }
}


// 打开岗位推荐 界面
+ (void)openInsterJobVCWithRootVC:(UIViewController*)rootVC{
    RequestParamWrapper *requestParam = [[RequestParamWrapper alloc] init];
    requestParam.serviceName = @"shijianke_queryStuSubscribeJobList";
    requestParam.typeClass = NSClassFromString(@"JobModel");
    requestParam.arrayName = @"self_job_list";
    requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
    
    JobController *vc = [[JobController alloc] init];
    vc.titleName = @"岗位推荐";
    vc.requestParam = requestParam;
    [rootVC.navigationController pushViewController:vc animated:YES];
}

@end


