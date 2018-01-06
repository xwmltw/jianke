//
//  SocialActivist_VC.m
//  jianke
//
//  Created by 时现 on 15/11/18.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "SocialActivist_VC.h"
#import "SocialAcitvistCell.h"
#import "WDConst.h"
#import "SociaAcitvistModel.h"
#import "ShareHelper.h"
#import "JKDetailController.h"
#import "JobDetail_VC.h"
#import "WebView_VC.h"

@interface SocialActivist_VC ()<UITableViewDelegate,UITableViewDataSource,SocialAcitvistDelegate>
{
    SociaAcitvistModel *_saModel;
}
@property (weak, nonatomic) IBOutlet UIButton *revocationAlert;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *revocationHeight;
@property (nonatomic,strong) NSMutableArray *dateArray;
@property (nonatomic,strong) NSNumber *social_activist_status;//人脉王状态  0未申请，1申请中，2申请通过，3被驳回，4被撤销
@property (nonatomic, strong) QueryParamModel *queryParam;


@end

@implementation SocialActivist_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我是人脉王";
        
    self.revocationAlert.hidden = YES;
    self.revocationHeight.constant = 0.1;
    self.revocationAlert.userInteractionEnabled = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MKCOLOR_RGB(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupTableViewHeaderView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(helpClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    //上下拉刷新
    [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)]];
    [self.tableView setFooter:[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)]];
    self.tableView.footer.hidden = YES;
    
    [self.tableView.header beginRefreshing];

}

- (void)setupTableViewHeaderView{
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = MKCOLOR_RGB(244, 251, 255);
    
    UIButton* btnHeadBx = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [btnHeadBx setBackgroundColor:[UIColor clearColor]];
    [btnHeadBx addTarget:self action:@selector(btnBxOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btnHeadBx];
    
    UIImageView* iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 15, 24, 24)];
    iconIV.image = [UIImage imageNamed:@"v240_navigate"];
    [headView addSubview:iconIV];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = MKCOLOR_RGB(222, 236, 251);
    [headView addSubview:lineView];
    
    UILabel* bxLab = [[UILabel alloc] init];
    bxLab.textAlignment = NSTextAlignmentLeft;
    bxLab.numberOfLines = 1;
    bxLab.font = [UIFont systemFontOfSize:16];
    bxLab.adjustsFontSizeToFitWidth = YES;
    bxLab.minimumScaleFactor = 12;
    bxLab.textColor = MKCOLOR_RGB(76, 133, 226);
    bxLab.text = @"动动手指来赚钱,兼客兼职人脉王介绍";
    
    [headView addSubview:bxLab];
    
    [bxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(headView.mas_left).offset(16);
        make.right.equalTo(headView.mas_right).offset(8);
    }];
    self.tableView.tableHeaderView = headView;
}


- (void)btnBxOnclick:(UIButton *)btn{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_socialActivistGuide];
    vc.title = @"人脉王介绍";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)helpClick{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_helpCenter];
    vc.title = @"人脉王介绍";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark - 网路请求
- (void)getData{
    self.queryParam = [[QueryParamModel alloc] init];
    self.queryParam.page_num = @(1);
//    self.queryParam.page_size = @(30);
    self.queryParam.timestamp = @((long)([[NSDate date] timeIntervalSince1970] * 1000));
    
    NSString *content = [self.queryParam getContent] ;
    WEAKSELF
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_getSocialActivistTaskList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            weakSelf.social_activist_status = response.content[@"social_activist_status"];
            NSArray *tempArray = response.content[@"task_list"];
            NSArray *array = [SociaAcitvistModel objectArrayWithKeyValuesArray:tempArray];
            weakSelf.dateArray = [NSMutableArray arrayWithArray:array];
        }
        [weakSelf.tableView reloadData];
        [weakSelf setUpUI];
        [weakSelf.tableView.header endRefreshing];
    }];
    
}

- (void)getMoreData{
    self.queryParam.page_num = @(self.queryParam.page_num.integerValue + 1);
    self.queryParam.timestamp = @([[NSDate date]timeIntervalSince1970] * 1000);
    
    NSString *content = [self.queryParam getContent] ;
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_getSocialActivistTaskList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response && response.success) {
            NSArray *tempArray = response.content[@"task_list"];
            NSArray *array = [SociaAcitvistModel objectArrayWithKeyValuesArray:tempArray];
            if (array && array.count > 0) {
                [self.dateArray addObjectsFromArray:array];
            }
        }
        [self.tableView reloadData];
        [self setUpUI];
        [self.tableView.footer endRefreshing];
    }];

}

- (void)setUpUI{
    if (self.social_activist_status.intValue == 2) {//是人脉王
        self.revocationAlert.hidden = YES;
        self.revocationHeight.constant = 0.1;
    }
    if (self.social_activist_status.intValue == 4) {//被撤销
        self.revocationAlert.hidden = NO;
        self.revocationHeight.constant = 60;
    }
    if (self.social_activist_status.intValue == 1 || self.social_activist_status.intValue == 3) {//不是人脉王
        [self.dateArray removeAllObjects];
        [self setNoDataViewText:@"您还不是人脉王"];
    }
}

#pragma  mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SocialAcitvistCell *cell = [SocialAcitvistCell cellWithTableView:tableView];
    cell.delegate = self;

    _saModel = self.dateArray[indexPath.row];
    if (self.social_activist_status.intValue == 4) {
        cell.isNotSocialActivist = YES;
    }
    [cell refreshWithData:_saModel andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _saModel = self.dateArray[indexPath.row];
    return _saModel.cellHeight ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArray.count > 0 ? self.dateArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


#pragma makr - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SociaAcitvistModel *model = self.dateArray[indexPath.row];
    
    if (model.task_status.integerValue == 2) { // 已接单 -> 跳兼客详情
        
        JKDetailController *vc = [[JKDetailController alloc] init];
        vc.jobId = model.job_id;
        // 2.6TODO
        [self.navigationController pushViewController:vc animated:YES];
        
    } else { // 为接单 | 拒绝 -> 跳岗位详情
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobId = model.job_id;
        vc.userType = WDLoginType_JianKe;
        vc.isFromSocialActivistBroadcast = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - SocialActivistDelegate

- (void)sa_Cell_updateCellIndex:(NSIndexPath *)indexPath withModel:(SociaAcitvistModel *)model{
    [self getData];
    [self setUpUI];
}

-(void)shareWihtModel:(SociaAcitvistModel *)model{
    [ShareHelper jobShareWithVc:self info:model.share_info_not_sms block:^(NSNumber *obj) {
        
    }];
}


@end
