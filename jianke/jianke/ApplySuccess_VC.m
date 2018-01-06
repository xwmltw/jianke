//
//  ApplySuccess_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ApplySuccess_VC.h"
#import "XSJConst.h"
#import "JobModel.h"
#import "BaseButton.h"
#import "WeChatBinding_VC.h"
#import "ServiceMange_VC.h"
#import "MainTabBarCtlMgr.h"
#import "JKHome_VC.h"
#import "ParttimeJobList_VC.h"
#import "JobSearchList_VC.h"
#import "WDChatView_VC.h"
#import "JobController.h"
#import "ParttimeJobList_VC.h"
#import "LookupResume_VC.h"

@interface ApplySuccess_VC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ApplySuccess_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报名成功";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = [self getTableHeaderView];
    
}

- (void)backToLastView{
    NSArray *vcArr = self.navigationController.childViewControllers;
    [vcArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JKHome_VC class]] || [obj isKindOfClass:[ParttimeJobList_VC class]] || [obj isKindOfClass:[JobSearchList_VC class]] || [obj isKindOfClass:[WDChatView_VC class]] || [obj isKindOfClass:[JobController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            return;
        }
        if (idx == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ApplySuccessCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *infoView = (UIView*)[cell viewWithTag:100];
        infoView = [[UIView alloc] init];
        infoView.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        infoView.tag = 100;
        [cell.contentView addSubview:infoView];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(8);
            make.right.equalTo(cell.contentView).offset(-8);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
        [infoView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(infoView).offset(-8);
            make.centerY.equalTo(infoView);
        }];
        
        if (indexPath.row == 0) {
            UILabel *lab = [UILabel labelWithText:@"查看更多岗位" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
           
            [infoView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoView).offset(16);
                make.centerY.equalTo(infoView);
            }];
        }
        
        if (indexPath.row == 1) {
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            [infoView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(infoView);
                make.height.equalTo(@8);
                
            }];
            
            UILabel *lab = [UILabel labelWithText:@"去完善简历" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:16.0f];
            UILabel *lab2 = [UILabel labelWithText:@"让伯乐发现最好的你" textColor:MKCOLOR_RGBA(34, 58, 80, 0.32) fontSize:14.0f];
            
            [infoView addSubview:lab];
            [infoView addSubview:lab2];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoView).offset(16);
                make.centerY.equalTo(infoView);
            }];
            [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(infoView);
                make.right.equalTo(infoView).offset(-25);
            }];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        ParttimeJobList_VC *vc = [[ParttimeJobList_VC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    if (indexPath.row == 1) {
        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         return 70.0f;
    }else{
        return 90.0f;
    }
   
}

- (UIView *)getTableHeaderView{
    
    CGFloat height = 326.0f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 404)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab1 = [UILabel labelWithText:@"·报名成功 ·被录用啦 ·开工干活 ·完工收账 ·好评get" textColor:[UIColor XSJColor_base] fontSize:12.0f];

    NSMutableAttributedString *mutablAttStr = [[NSMutableAttributedString alloc] initWithString:@"·报名成功 ·被录用啦 ·开工干活 ·完工收账 ·好评get" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]}];
    [mutablAttStr addAttributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_base]} range:NSRangeFromString(@"@{0, 5}")];
    lab1.attributedText = mutablAttStr;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor XSJColor_clipLineGray];
    

    NSString *title = @"";
    UILabel *lab2 = nil;
    UIButton *btnCall = nil;
    if (self.jobModel.wechat_public.length || self.jobModel.wechat_number.length) {
        lab1.hidden = YES;
        line1.hidden = YES;
//        title = @"请主动联系商家，按照以下联系方式与商家沟通，获取工作内容";
        NSString *str = nil;
        if (self.jobModel.wechat_public.length) {
            title = [NSString stringWithFormat:@"打开微信-右上角-点击\"添加朋友\"-\"公众号\"-输入%@", self.jobModel.wechat_public];
            str = [NSString stringWithFormat:@"微信公众号：%@", self.jobModel.wechat_public];
        }else{
            title = [NSString stringWithFormat:@"打开微信-右上角-点击\"添加朋友\"-输入%@", self.jobModel.wechat_number];
            str = [NSString stringWithFormat:@"微信号：%@", self.jobModel.wechat_number];
        }
        lab2 = [UILabel labelWithText:[NSString stringWithFormat:@"%@", str] textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:16.0f];
        lab2.numberOfLines = 0;
        btnCall = [UIButton buttonWithTitle:@"复制" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(btnCopyOnClick:)];
        [btnCall setCornerValue:14.0f];
    }else{
        title = @"请静候佳音，您亦可联系雇主了解其他事项";
        lab2 = [UILabel labelWithText:@"联系雇主" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:16.0f];
        btnCall = [UIButton buttonWithTitle:nil bgColor:nil image:@"v3_job_call_0" target:self sector:@selector(btnCallOnClick:)];
    }

    UIView *viewNodata = [UIHelper noDataViewWithTitleArr:@[@"报名成功", title] titleColor:[UIColor XSJColor_base] image:@"v323_no_data_img" button:nil];
    viewNodata.y = 89;
    viewNodata.height = 277.0f - 40.0f;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    [view addSubview:lab1];
    [view addSubview:line1];
    [view addSubview:viewNodata];
    [view addSubview:line2];
    [view addSubview:lab2];
    [view addSubview:btnCall];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.equalTo(view).offset(16);
        make.right.equalTo(view).offset(-16);
        make.height.equalTo(@49);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom);
        make.left.right.equalTo(lab1);
        make.height.equalTo(@0.7);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewNodata.mas_bottom);
        make.left.right.equalTo(line1);
        make.height.equalTo(@0.7);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(27);
        make.left.equalTo(view).offset(24);
        make.right.equalTo(view).offset(-92);
    }];
    
    height += ([lab2 contentSizeWithWidth:SCREEN_WIDTH - 110].height + 27 +27);
    
    [btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-16);
        make.centerY.equalTo(lab2);
        make.width.equalTo(@60);
        make.height.greaterThanOrEqualTo(@28);
    }];
    
    view.height = height;
    
    return view;
    
}

- (void)btnCallOnClick:(UIButton *)sender{
    [[MKOpenUrlHelper sharedInstance] callWithPhone:self.jobModel.contact.phone_num];
}

- (void)btnCopyOnClick:(UIButton *)sender{
    if (self.jobModel.wechat_public.length) {
        [UIHelper copyToPasteboard:self.jobModel.wechat_public];
    }else{
        [UIHelper copyToPasteboard:self.jobModel.wechat_number];
    }
    if ([WXApi isWXAppInstalled]) {
        [WXApi openWXApp];
    }else{
        [UIHelper toast:@"已复制到剪贴板"];
    }
}

- (void)dealloc{
    ELog(@"ApplySuccess_VC dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
