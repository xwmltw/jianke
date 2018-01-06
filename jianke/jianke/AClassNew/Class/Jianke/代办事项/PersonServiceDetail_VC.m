//
//  PersonServiceDetail_VC.m
//  jianke
//
//  Created by fire on 16/10/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonServiceDetail_VC.h"
#import "WebView_VC.h"
#import "PersonServiceModel.h"
#import "PersonServDetailCell.h"
#import "WDConst.h"

@interface PersonServiceDetail_VC ()

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *botBtn;
@property (nonatomic, strong) UILabel *labStatus;
@property (nonatomic, strong) PersonServiceModel *personServiceModel;

@end

@implementation PersonServiceDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通告详情";
    [self setupViews];
    [self getShareData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)setupViews{
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"PersonServDetailCell") forCellReuseIdentifier:@"PersonServDetailCell"];
    
    self.botView = [[UIView alloc] init];
    

    
    [self.view addSubview:self.botView];

    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
    if (self.isApplyAction) {
        self.botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.botBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.botBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.botBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.botBtn setCornerValue:2.0f];
        [self.botBtn setBackgroundColor:[UIColor XSJColor_base]];
        [self.botBtn addTarget:self action:@selector(applyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.botView addSubview:self.botBtn];
        
        [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.botBtn.mas_top).offset(-12);
        }];
        
        [self.botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.botView).offset(16);
            make.right.equalTo(self.botView).offset(-16);
            make.bottom.equalTo(self.botView).offset(-12);
            make.height.equalTo(@44);
        }];
        
    }else{
        self.labStatus = [[UILabel alloc] init];
        self.labStatus.textAlignment = NSTextAlignmentCenter;
        self.labStatus.textColor = MKCOLOR_RGBA(34, 58, 80, 0.32);
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.leftBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(refuseBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.rightBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor XSJColor_base]];
        [self.rightBtn addTarget:self action:@selector(applyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.botView addSubview:self.labStatus];
        [self.botView addSubview:self.leftBtn];
        [self.botView addSubview:self.rightBtn];
        
        [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [self.labStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.botView);
        }];
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.rightBtn);
            make.left.equalTo(self.botView);
            make.right.equalTo(self.rightBtn.mas_left);
            make.height.equalTo(@49);
            make.bottom.equalTo(self.botView);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.leftBtn);
            make.right.equalTo(self.botView);
            make.height.equalTo(self.leftBtn);
            make.bottom.equalTo(self.botView);
        }];
        
    }
    
    self.botView.hidden = YES;
    [self.botView addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:MKCOLOR_RGBA(230, 230, 230, 1) isConstraint:YES];
}

- (void)getShareData{
    
}

- (void)getData{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getServicePersonalJobDetailWithJobId:self.service_personal_job_id block:^(ResponseInfo *response) {
        if (response) {
            weakSelf.personServiceModel = [PersonServiceModel objectWithKeyValues:[response.content objectForKey:@"service_personal_job"]];
            [weakSelf setBotViewData];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)setBotViewData{
    if (!self.personServiceModel) {
        self.botView.hidden = YES;
    }else{
        self.botView.hidden = NO;
        if (self.isApplyAction) {
            self.botBtn.enabled = NO;
            self.botBtn.backgroundColor = [UIColor XSJColor_grayLabBg];
            if (!self.personServiceModel.apply_status) {
                if (self.personServiceModel.status.integerValue == 2) {
                    [self.botBtn setTitle:@"已结束" forState:UIControlStateNormal];
                }else{
                    self.botBtn.enabled = YES;
                    [self.botBtn setTitle:@"报名" forState:UIControlStateNormal];
                    self.botBtn.backgroundColor = [UIColor XSJColor_base];
                }
            }else{
                switch (self.personServiceModel.apply_status.integerValue) {
                    case 1:{
                        self.botBtn.enabled = YES;
                        [self.botBtn setTitle:@"报名" forState:UIControlStateNormal];
                        self.botBtn.backgroundColor = [UIColor XSJColor_base];
                    }
                        break;
                    case 2:{
                        [self.botBtn setTitle:@"待对方确认" forState:UIControlStateNormal];
                    }
                        break;
                    case 3:{
                        [self.botBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                    }
                        break;
                    case 4:{
                        [self.botBtn setTitle:@"待对方联系" forState:UIControlStateNormal];
                    }
                        break;
                    case 5:{
                        [self.botBtn setTitle:@"不合适" forState:UIControlStateNormal];
                    }
                        break;
                    case 6:{
                        [self.botBtn setTitle:@"已完成" forState:UIControlStateNormal];
                    }
                        break;
                    case 7:{
                        [self.botBtn setTitle:@"对方已取消" forState:UIControlStateNormal];
                    }
                        break;
                    default:{
                        self.botBtn.enabled = YES;
                        [self.botBtn setTitle:@"报名" forState:UIControlStateNormal];
                        self.botBtn.backgroundColor = [UIColor XSJColor_base];
                    }
                        break;
                }
            }
        }else{
            [self setBtnHidden:YES];
//            if (self.personServiceModel.status.integerValue == 2) {
//                self.labStatus.text = @"已结束";
//            }else{
                switch (self.personServiceModel.apply_status.integerValue) {
                    case 1:{
                        [self setBtnHidden:NO];
                    }
                        break;
                    case 2:{
                        self.labStatus.text = @"待对方确认";
                    }
                        break;
                    case 3:{
                        self.labStatus.text = @"已拒绝";
                    }
                        break;
                    case 4:{
                        self.labStatus.text = @"待对方联系";
                    }
                        break;
                    case 5:{
                        self.labStatus.text = @"不合适";
                    }
                        break;
                    case 6:{
                        self.labStatus.text = @"已完成";
                    }
                        break;
                    case 7:{
                        self.labStatus.text = @"对方已取消";
                    }
                        break;
                    default:{
                        [self setBtnHidden:NO];
                    }
                        break;
                }
            }
//        }
    }
}

- (void)setBtnHidden:(BOOL)isHidden{
    self.rightBtn.hidden = isHidden;
    self.leftBtn.hidden = isHidden;
    self.labStatus.hidden = !isHidden;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.personServiceModel) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServDetailCell" forIndexPath:indexPath];
    [cell setModel:self.personServiceModel];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.personServiceModel.cellHeight;
}

- (void)refuseBtnOnClick:(UIButton *)sender{
    WEAKSELF
    [MKAlertView alertWithTitle:@"提示" message:@"是否拒绝该邀约?" cancelButtonTitle:@"取消" confirmButtonTitle:@"拒绝" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf dealWithServicePersonalJobApplyWithOptType:@2];
        }
    }];
    
}

- (void)applyBtnOnClick:(UIButton *)sender{
    if (self.isApplyAction) {
        WEAKSELF
        [[UserData sharedInstance] userIsLogin:^(id result) {
            if (result) {
                [[XSJRequestHelper sharedInstance] applyServicePersonalJobWithJobId:weakSelf.service_personal_job_id block:^(ResponseInfo *response) {
                    if (response.success) {
                        [UIHelper toast:@"已报名，待雇主确认"];
                        weakSelf.personServiceModel.apply_status = @2;
                        [weakSelf setBotViewData];
                        [UserData sharedInstance].isrefreshServiceOrder = YES;
                    }else if (response.errCode.integerValue == 81) {
                        [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalModel) {
                            if (globalModel && globalModel.service_personal_apply_url) {
                                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                                NSRange range = [globalModel.service_personal_apply_url rangeOfString:@"?"];
                                if (range.location == NSNotFound) {
                                    viewCtrl.url = [NSString stringWithFormat:@"%@?service_type_id=%@", globalModel.service_personal_apply_url, weakSelf.personServiceModel.service_type];
                                }else{
                                    viewCtrl.url = [NSString stringWithFormat:@"%@&service_type_id=%@", globalModel.service_personal_apply_url, weakSelf.personServiceModel.service_type];
                                }
                                [self.navigationController pushViewController:viewCtrl animated:YES];
                            }
                        }];
                    }
                }];
            }
        }];

    }else{
        WEAKSELF
        [MKAlertView alertWithTitle:@"提示" message:@"是否报名该邀约?" cancelButtonTitle:@"取消" confirmButtonTitle:@"报名" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf dealWithServicePersonalJobApplyWithOptType:@1];
            }
        }];
    }
    
}

- (void)dealWithServicePersonalJobApplyWithOptType:(NSNumber *)optType{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] stuDealWithServicePersonalJobApplyWithOptType:optType applyId:self.service_personal_job_apply_id block:^(id result) {
        if (result) {
            if (optType.integerValue == 1) {
                [UIHelper toast:@"已报名，待雇主确认"];
                weakSelf.personServiceModel.apply_status = @2;
                MKBlockExec(weakSelf.block, @2);
            }else if (optType.integerValue == 2){
                weakSelf.personServiceModel.apply_status = @3;
                MKBlockExec(weakSelf.block, @3);
            }
            [weakSelf setBotViewData];
        }
    }];
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
