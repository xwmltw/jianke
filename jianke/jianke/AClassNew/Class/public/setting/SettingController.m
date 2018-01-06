//
//  SettingController.m
//  jianke
//
//  Created by fire on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  设置

#import "SettingController.h"
#import "AccountController.h"
#import "WDConst.h"
#import <StoreKit/StoreKit.h>
#import "NewFeature_VC.h"
#import "WDLoadingView.h"
#import "ShareHelper.h"
#import "UserData.h"
#import "ThirdPartAccountModel.h"
#import "WebView_VC.h"
#import "WeChatBinding_VC.h"
#import "FeedBackController.h"
#import "MKActionSheet.h"


@interface SettingController () <UITableViewDataSource,UITableViewDelegate, SKStoreProductViewControllerDelegate, UIActionSheetDelegate>{
    BOOL _isBindingWX;
    NSMutableArray *_datasArray;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) JKModel *jkModel;
@property (nonatomic, strong) EPModel *epModel;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    _isBindingWX = NO;
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    [self loadDatas];
}

- (void)loadDatas{
    _datasArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSMutableArray *ary1 = [[NSMutableArray alloc] init];
    [ary1 addObject:@(SettingCellType_account)];
    
    NSMutableArray *ary2 = [[NSMutableArray alloc] init];
//    [ary2 addObject:@(SettingCellType_opinion)];
//    [ary2 addObject:@(SettingCellType_notice)];
    [ary2 addObject:@(SettingCellType_aboutAPP)];
    [ary2 addObject:@(SettingCellType_shareJK)];
    [ary2 addObject:@(SettingCellType_clearCache)];
    
    NSMutableArray *ary3 = [[NSMutableArray alloc] init];
    [ary3 addObject:@(SettingCellType_logout)];

    [_datasArray addObject:ary1];
    [_datasArray addObject:ary2];
    [_datasArray addObject:ary3];

    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserData sharedInstance] isLogin]) {
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getAccountThirdPlatBindInfo" andContent:nil];
        WEAKSELF
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            NSNumber* isBinding = response.content[@"is_bind_wechat_public"];
            _isBindingWX = isBinding.integerValue == 1;
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    cell.textLabel.textColor = [UIColor XSJColor_tBlackTinge];
    
    
    SettingCellType type = [_datasArray[indexPath.section][indexPath.row] integerValue];

    switch (type) {
        case SettingCellType_account: // 账号信息
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_account"];
            cell.textLabel.text = @"账号信息";
        }
            break;
            
        case SettingCellType_opinion:
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_feedback"];
            cell.textLabel.text = @"意见反馈";
        }
            break;
        case SettingCellType_notice:
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_notification"];
            cell.textLabel.text = @"即时通知";
            
            UILabel* bindWXLabel = (UILabel*)[cell viewWithTag:101];
            if (!bindWXLabel) {
                bindWXLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 98, 12, 50 , 20)];
                bindWXLabel.font = [UIFont systemFontOfSize:15];
                bindWXLabel.textColor = MKCOLOR_RGB(154, 154, 154);
                bindWXLabel.tag = 101;
                [cell addSubview:bindWXLabel];
            }
            if (_isBindingWX){
                bindWXLabel.text = @"已绑定";
            }else{
                bindWXLabel.text = @"未绑定";
            }

        }
            break;
        case SettingCellType_reputably:
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_assessment"];
            cell.textLabel.text = @"赏个好评";
        }
            break;
        case SettingCellType_aboutAPP:{
            cell.imageView.image = [UIImage imageNamed:@"v3_set_info"];
            cell.textLabel.text = @"关于兼客";
            break;
        }
        case SettingCellType_shareJK:{
            cell.imageView.image = [UIImage imageNamed:@"myInfo_share_icon"];
            cell.textLabel.text = @"分享兼客";
        }
            break;
        case SettingCellType_clearCache:
        {
            cell.imageView.image = [UIImage imageNamed:@"v3_set_clean"];
            cell.textLabel.text = @"清除缓存";
        }
            break;
        case SettingCellType_logout:{       // 退出登录
            cell.accessoryType = UITableViewCellAccessoryNone;

            UILabel *labLogout = (UILabel *)[cell viewWithTag:100];
            if (!labLogout) {
                labLogout = [[UILabel alloc] initWithFrame:CGRectZero];
                labLogout.tag = 100;
                labLogout.textAlignment = NSTextAlignmentCenter;
                labLogout.textColor = [UIColor XSJColor_tBlackTinge];
                labLogout.font = [UIFont systemFontOfSize:15];
                [cell addSubview:labLogout];
                
                [labLogout mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell);
                }];
            }
            labLogout.text = @"退出登录";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingCellType type = [_datasArray[indexPath.section][indexPath.row] integerValue];
    
    switch (type) {
        case SettingCellType_account: // 账号信息
        {
            WEAKSELF
            [[UserData sharedInstance] userIsLogin:^(id obj) {
                if (obj) {
                    AccountController *vc = [[AccountController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
 
            }];
        }
            break;
            
        case SettingCellType_opinion:{
            [TalkingData trackEvent:@"雇主个人中心_吐槽冲我来"];
            FeedBackController *vc = [[FeedBackController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SettingCellType_notice:{
            //绑定微信
            [self bindWeiXin];
        }
            break;
        case SettingCellType_reputably: //赏个好评
        {
            [[XSJUIHelper sharedInstance] evaluateWithViewController:self];

        }
            break;
        case SettingCellType_aboutAPP:{
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *uri = [NSString stringWithFormat:@"%@%@", kUrl_aboutApp,version];
            
            WebView_VC *vc = [[WebView_VC alloc] init];
            vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, uri];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case SettingCellType_shareJK:{
            [TalkingData trackEvent:@"雇主_个人中心_分享兼客"];
            WEAKSELF
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM* globaModel) {
                if (globaModel.share_info.share_info) {
                    ShareInfoModel *shareInfo = globaModel.share_info.share_info;
                    [ShareHelper platFormShareWithVc:weakSelf info:shareInfo block:nil];
                }else{
                    [UIHelper toast:@"获取分享信息失败"];
                }
            }];
        }
            break;
        case SettingCellType_clearCache:
        {
            CGFloat foleSize = [MKCacheHelper getCacheFolderSize];
            if (foleSize <= 0) {
                [UIHelper toast:@"你暂时不需要清理缓存"];
                return;
            }
            NSString* content = [NSString stringWithFormat:@"是否清除%0.2fM缓存",foleSize];
            [UIHelper showConfirmMsg:content title:@"清理缓存" okButton:@"确定清理" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [MKCacheHelper clearCacheFolder];
                    [UIHelper toast:@"清理成功"];
                }
            }];
        }
            break;
        case SettingCellType_logout:{       // 退出登录
            MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"退出登录" buttonTitleArray:@[@"退出登录"]];
            sheet.destructiveButtonIndex = 0;
            [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [TalkingData trackEvent:@"设置页面_退出登录_确定"];
                    [UIHelper loginOutToView];
                }
            }];
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_datasArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datasArray.count ? _datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}



#pragma mark - ***** 绑定微信 弃用 ******
-(void)bindWeiXin{
    ELog(@"======绑定微信 ");
    WEAKSELF
    if (_isBindingWX) {
        WEAKSELF
        [UIHelper showConfirmMsg:@"解除绑定后将无法继续接收微信公众号的消息提醒哦！确定要解除账户与微信的关联吗？" title:@"微信解绑" okButton:@"解除绑定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf unBindWeiXin];
            }
        }];
    }else{
//        [self weiXinLogin];
        [[UserData sharedInstance] userIsLogin:^(id obj) {
            if (obj) {
                WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }

        }];
    }
}

- (void)unBindWeiXin{
    NSString *content = @"\"type\":\"2\"";
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_unBandingWechatUser" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo * response) {
        if (response && response.success) {
            [UIHelper toast:@"解绑成功"];
            if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
                weakSelf.jkModel = [[UserData sharedInstance] getJkModelFromHave];
                weakSelf.jkModel.bind_wechat_public_num_status = @(0);
                [[UserData sharedInstance] saveJKModel:weakSelf.jkModel];
            }else{
                weakSelf.epModel = [[UserData sharedInstance] getEpModelFromHave];
                weakSelf.epModel.bind_wechat_public_num_status = @(0);
                [[UserData sharedInstance] saveEPModel:weakSelf.epModel];
            }
            _isBindingWX = NO;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)weChatBindingSuccess{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
            weakSelf.jkModel = [[UserData sharedInstance] getJkModelFromHave];
            weakSelf.jkModel.bind_wechat_public_num_status = @(1);
            [[UserData sharedInstance] saveJKModel:weakSelf.jkModel];
        }else{
            weakSelf.epModel = [[UserData sharedInstance] getEpModelFromHave];
            weakSelf.epModel.bind_wechat_public_num_status = @(1);
            [[UserData sharedInstance] saveEPModel:weakSelf.epModel];
        }
        _isBindingWX = YES;
        [weakSelf.tableView reloadData];
    });
}

//-(void)weiXinLogin{
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//        ELog(@"======安装了微信客户端");
//        // 进行APP跳转授权
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo";
//        req.state = @"JKBindWX";
//        [WXApi sendReq:req];
//    } else { // 没有安装微信
//        ELog(@"没有安装微信客户端");
//        // 进行网页授权
//        [UIHelper toast:@"你没有安装微信"];
//    }
//}

//-(void)getBindWeiXinInfo:(NSNotification *)notification{
//    ELog(@"线程----%@",[NSThread currentThread]);
//    NSString* code = notification.userInfo[JKGetWXCodeInfo];
//    ThirdPartAccountModel* wechatAccount = [ThirdPartAccountModel wechatAccount];
//    
//    NSString *url =[NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatAccount.getAccessTokenURL, wechatAccount.appID, wechatAccount.appKey, code];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    WEAKSELF
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        ELog(@"=====response:%@", response);
//        if (data) {
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            //            ELog(@"=====dic:%@", dic);
//            // 发送登陆请求
//            NSString *access_token = dic[@"access_token"];
//            NSString *openid = dic[@"openid"];
//            
//            ELog(@"=========================== access_token =============== %@", access_token);
//            ELog(@"=========================== openid =============== %@", openid);
//            if (access_token && openid) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [weakSelf sendRequestWithOpenID:openid andAccessToken:access_token];
//                    
//                });
//            }
//        }
//    }];
//
//}
//-(void)sendRequestWithOpenID:(NSString *)openID andAccessToken:(NSString *)accessToken{
//    NSString *content = [NSString stringWithFormat:@"open_id:\"%@\",access_token:\"%@\"",openID,accessToken];
//    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_bandingWechatUser" andContent:content];
//    [request sendRequestWithResponseBlock:^(ResponseInfo * response) {
//        
//        if (response && response.success) {
//            [UIHelper toast:@"绑定成功"];
//            _isBindingWX = YES;
//            self.jkModel.bind_wechat_status = @(1);
//            [self.tableView reloadData];
//        }
//    }];
//}
@end
