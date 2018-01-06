//
//  PersonalList_VC.m
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalList_VC.h"
#import "WebView_VC.h"
#import "XZTabBarCtrl.h"
#import "TopicJobList_VC.h"

#import "XSJRequestHelper.h"
#import "ResponseInfo.h"

#import "PersonalListCell.h"
#import "SDCycleScrollView.h"
#import "JKHomeModel.h"

@interface PersonalList_VC () <SDCycleScrollViewDelegate>{
    NSArray *_adArrayData;
}

@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) SDCycleScrollView *cycleBannerSV; /*!< banner 广告 */
@property (nonatomic, strong) UIScrollView *noDataView;

@end

@implementation PersonalList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccess) name:WDNotifi_LoginSuccess object:nil];
    self.cityId = [UserData sharedInstance].city.id;
    if ([[UserData sharedInstance] isLogin]) {
        [self queryServiceApplyInfo];
    }else{
        [self initRightItemWithTitle:@"立即申请" sector:@selector(applyAction)];
    }
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self initHeaderView];
    [self.tableView registerNib:nib(@"PersonalListCell") forCellReuseIdentifier:@"PersonalListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    self.tableView.estimatedRowHeight = 109.0f;
    [self.tableView.header beginRefreshing];

}

- (void)setupData{
    NSAssert(self.service_type, @"service_type不能为空！！");
    self.queryParam = [[QueryParamModel alloc] init];
    switch (self.service_type.integerValue) {
        case 2:
            self.title = @"礼仪";
            break;
        case 1:
            self.title = @"模特";
            break;
        case 5:
            self.title = @"家教";
            break;
        case 4:
            self.title = @"商演";
            break;
        case 3:
            self.title = @"主持";
            break;
        case 7:
            self.title = @"促销";
            break;
        default:
            break;
    }
}

- (void)initHeaderView{
    WEAKSELF
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    if (globaModel) {
        if (globaModel.service_type_stu_banner_ad_list && globaModel.service_type_stu_banner_ad_list.count > 0) {
            UIView *tableHeaderView = [[UIView alloc] init];
            
            CGFloat bannerH = SCREEN_WIDTH*(76.00/359.00);
            self.cycleBannerSV.frame = CGRectMake(0, 12, SCREEN_WIDTH, bannerH);
            //初始化完成  设置tableViewheader
            tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerH + 12);   //24为上下间距12 * 2
            [tableHeaderView addSubview:self.cycleBannerSV];
            _adArrayData = [AdModel objectArrayWithKeyValuesArray:globaModel.service_type_stu_banner_ad_list];
            [weakSelf refreshBannerWithArray:_adArrayData];
            self.tableView.tableHeaderView = tableHeaderView;
        }
    }
}

/** 刷新广告条 */
- (void)refreshBannerWithArray:(NSArray*)dataArray{
    NSMutableArray* imgArray = [[NSMutableArray alloc] init];
    for (AdModel* model in dataArray) {
        if (model.img_url) {
            [imgArray addObject:model.img_url];
        }
    }
    if (dataArray.count == 1) {
        _cycleBannerSV.autoScrollTimeInterval = 3600;
    }else{
        _cycleBannerSV.autoScrollTimeInterval = 3;
    }
    _cycleBannerSV.imageURLStringsGroup = imgArray;
    
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalStuList:self.service_type cityId:self.cityId jobId:self.service_personal_job_id orderType:@1 param:self.queryParam block:^(NSArray *result) {
        [weakSelf.tableView.header endRefreshing];
        if (result) {
            if (result.count) {
                weakSelf.noDataView.hidden = YES;
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObjectsFromArray:result];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.noDataView.hidden = NO;
            }
        }

    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalStuList:self.service_type cityId:self.cityId jobId:self.service_personal_job_id orderType:@1 param:self.queryParam block:^(NSArray *result) {
        [weakSelf.tableView.footer endRefreshing];
        if (result) {
            if (result.count) {
                [weakSelf.dataSource addObjectsFromArray:result];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
        
    }];
}

#pragma mark - uitableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource ? self.dataSource.count : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalListCell" forIndexPath:indexPath];
    ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell setModel:model atIndexPath:indexPath];
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"进入个人需求详情页");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UserData sharedInstance] userIsLogin:^(id result) {
        ServicePersonalStuModel *model = [self.dataSource objectAtIndex:indexPath.section];
        WebView_VC *viewCtrl = [[WebView_VC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@%@?service_type=%@&stu_account_id=%@&show_type=1", URL_HttpServer, KUrl_ServicePersonalDetail, self.service_type, model.stu_account_id];
        url = (self.service_personal_job_id) ? [url stringByAppendingFormat:@"&service_personal_job_id=%@", self.service_personal_job_id] : url ;
        viewCtrl.url = url;
        viewCtrl.uiType = WebViewUIType_PersonalServiceDetail;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
}

- (void)applyAction{
    [self applyService];
}

- (void)applyService{
    
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id result) {
        if (result) {
            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                if (globalModel && globalModel.service_personal_apply_url) {
                    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                    NSRange range = [globalModel.service_personal_apply_url rangeOfString:@"?"];
                    if (range.location == NSNotFound) {
                        viewCtrl.url = [NSString stringWithFormat:@"%@?service_type_id=%@", globalModel.service_personal_apply_url, weakSelf.service_type];
                    }else{
                        viewCtrl.url = [NSString stringWithFormat:@"%@&service_type_id=%@", globalModel.service_personal_apply_url, weakSelf.service_type];
                    }
                    [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
                }
            }];
        }
    }];

    //    WEAKSELF
    //    [[UserData sharedInstance] userIsLogin:^(id obj) {
    //        if (obj) {
    //            [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
    //                if (globalModel && globalModel.service_personal_apply_url) {
    //                    WebView_VC *vc = [[WebView_VC alloc] init];
    //                    NSRange range = [globalModel.service_personal_apply_url rangeOfString:@"?"];
    //                    if (range.location == NSNotFound) {
    //                        vc.url = [NSString stringWithFormat:@"%@?service_type_id=%@", globalModel.service_personal_apply_url, self.service_type];
    //                    }else{
    //                        vc.url = [NSString stringWithFormat:@"%@&service_type_id=%@", globalModel.service_personal_apply_url, self.service_type];
    //                    }
    //                    [weakSelf.navigationController pushViewController:vc animated:YES];
    //                }
    //            }];
    //        }
    //    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ELog(@"---点击了第%ld张图片", (long)index);
    if (_adArrayData.count <= 0) {
        return;
    }
    //    NSString *numBanner = [NSString stringWithFormat:@"%ld",index + 1];
    //    [TalkingData trackEvent:@"兼职快讯_Banner" label:numBanner];
    
    AdModel* model = _adArrayData[index];
    // 1:应用内打开链接 2:岗位广告  3:浏览器打开链接 4:专题类型
    [[XSJRequestHelper sharedInstance] queryAdClickLogRecordWithADId:model.ad_id];
    
    switch (model.ad_type.intValue) {
        case 1:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = model.ad_detail_url;
            vc.title = model.ad_name;
            vc.uiType = WebViewUIType_Banner;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                return;
            }
            //            //进入岗位详情
            //            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            //            vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
            //            vc.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
        }
            break;
        case 4:{
            TopicJobList_VC *vc = [[TopicJobList_VC alloc] init];
            vc.adDetailId = model.ad_detail_id.stringValue;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - ***** lazy ****

- (SDCycleScrollView *)cycleBannerSV{
    if (!_cycleBannerSV) {
        _cycleBannerSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        _cycleBannerSV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerSV.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleBannerSV.delegate = self;
        _cycleBannerSV.currentPageDotColor = [UIColor whiteColor];
        _cycleBannerSV.pageDotColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _cycleBannerSV.placeholderImage = [UIImage imageNamed:@"v3_public_banner"];
    }
    return _cycleBannerSV;
}

- (UIScrollView *)noDataView{
    if (!_noDataView) {
        CGFloat noDataViewH = 0;
        _noDataView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
        _noDataView.showsVerticalScrollIndicator = NO;
        _noDataView.bounces = NO;
        _noDataView.backgroundColor = [UIColor XSJColor_newWhite];
        
        UILabel *labTitle = [UILabel labelWithText:@"兼客密探，全国纳新咯！" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:24.0f];
        labTitle.numberOfLines = 0;
        
        UILabel *labSubTitle = [UILabel labelWithText:@"不论你是专业人士还是尝鲜小白,只要你想做:" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:17.0f];
        labSubTitle.numberOfLines = 0;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_service_nodata_img"]];
        UILabel *labApplyTitle = [UILabel labelWithText:@"个人或团队均可申请入驻兼客觅探,快到碗里来吧!" textColor:[UIColor XSJColor_tGrayHistoyTransparent] fontSize:17.0f];
        labApplyTitle.numberOfLines = 0;
        
        UIButton *btnApply = [UIButton buttonWithTitle:@"申请入驻" bgColor:[UIColor XSJColor_base] image:nil target:self sector:@selector(btnApplyOnClick:)];
        btnApply.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [btnApply setCornerValue:2.0f];
        
        [self.tableView addSubview:_noDataView];
        [self.tableView bringSubviewToFront:_noDataView];
        [_noDataView addSubview:labTitle];
        [_noDataView addSubview:labSubTitle];
        [_noDataView addSubview:imgView];
        [_noDataView addSubview:labApplyTitle];
        [_noDataView addSubview:btnApply];
        
        CGFloat imgWidth = (SCREEN_WIDTH - 32);
        CGFloat imgOrignWidth = imgView.width;
        CGFloat percentX = (imgWidth - imgOrignWidth) / imgOrignWidth;
        CGFloat imgOrignHeight = imgView.height;
        CGFloat imgHeight = percentX * imgOrignHeight + imgOrignHeight;
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noDataView).offset(32);
            make.left.equalTo(_noDataView).offset(16);
            make.width.equalTo(@(SCREEN_WIDTH - 32));
            make.height.greaterThanOrEqualTo(@1);
        }];
        
        noDataViewH += 32;
        CGFloat height = [labTitle contentSizeWithWidth:SCREEN_WIDTH - 32].height;
        noDataViewH += height;
        
        [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labTitle.mas_bottom).offset(47);
            make.left.equalTo(_noDataView).offset(16);
            make.width.equalTo(@(SCREEN_WIDTH - 32));
            make.height.greaterThanOrEqualTo(@1);
        }];
        
        noDataViewH += 47;
        height = [labSubTitle contentSizeWithWidth:SCREEN_WIDTH - 32].height;
        noDataViewH += height;
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labSubTitle.mas_bottom).offset(32);
            make.centerX.equalTo(_noDataView);
            make.width.equalTo(@(SCREEN_WIDTH - 32));
            make.height.equalTo(@(imgHeight));
        }];
        
        noDataViewH += 32;
        noDataViewH += imgHeight;
        
        [labApplyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(32);
            make.left.equalTo(_noDataView).offset(16);
            make.width.equalTo(@(SCREEN_WIDTH - 32));
            make.height.greaterThanOrEqualTo(@1);
        }];
        noDataViewH += 32;
        height = [labApplyTitle contentSizeWithWidth:SCREEN_WIDTH - 32].height;
        noDataViewH += height;
        
        [btnApply mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labApplyTitle.mas_bottom).offset(32);
            make.left.equalTo(_noDataView).offset(16);
            make.width.equalTo(@(SCREEN_WIDTH - 32));
            make.height.equalTo(@44);
        }];
        
        noDataViewH += (32 + 44 + 16);
        
        _noDataView.contentSize = CGSizeMake(SCREEN_WIDTH, noDataViewH);
        
    }
    return _noDataView;
}

- (void)btnApplyOnClick:(UIButton *)sender{
    [self applyService];
}

- (void)lookProfile{
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfoRM) {
        if (globalInfoRM && globalInfoRM.wap_url_list && globalInfoRM.wap_url_list.service_personal_apply_preview_url.length) {
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            if ([globalInfoRM.wap_url_list.service_personal_apply_preview_url rangeOfString:@"?"].location == NSNotFound) {
                viewCtrl.url = [NSString stringWithFormat:@"%@?service_type=%@", globalInfoRM.wap_url_list.service_personal_apply_preview_url, self.service_type];
            }else{
                viewCtrl.url = [NSString stringWithFormat:@"%@&service_type=%@", globalInfoRM.wap_url_list.service_personal_apply_preview_url, self.service_type];
            }
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
}

- (void)initRightItemWithTitle:(NSString *)title sector:(SEL)sector{
    if ([self.parentViewController isKindOfClass:[XZTabBarCtrl class]]) {
        UIButton *btnQrCode = [UIButton buttonWithType:UIButtonTypeCustom];
        btnQrCode.frame = CGRectMake(0, 0, 66, 44);
        btnQrCode.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnQrCode setTitle:title forState:UIControlStateNormal];
        [btnQrCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnQrCode addTarget:self action:sector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnQrCode];
        self.parentViewController.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)queryServiceApplyInfo{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServiceApplyInfoWithServiceType:self.service_type block:^(ResponseInfo *response) {
        if (response) {
            NSNumber *applySatatus = [[response.content objectForKey:@"service_personal_detail"] objectForKey:@"service_apply_status"];
            if (applySatatus.integerValue == 2) {
                [weakSelf initRightItemWithTitle:@"查看简历" sector:@selector(lookProfile)];
            }else{
                [weakSelf initRightItemWithTitle:@"立即申请" sector:@selector(applyAction)];
            }
        }
    }];
}

- (void)loginSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self queryServiceApplyInfo];
    });
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
