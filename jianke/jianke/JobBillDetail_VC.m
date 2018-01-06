//
//  JobBillDetail_VC.m
//  jianke
//
//  Created by 时现 on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobBillDetail_VC.h"
#import "JobBillDetailCell.h"
#import "WDConst.h"
#import "JobBillModel.h"
@interface JobBillDetail_VC ()<UITableViewDataSource,UITableViewDelegate>
{
    JobBillModel *_jbModel;
    PayListModel *_plModel;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation JobBillDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"账单记录";
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self getData];


}
//获取数据
- (void)getData{
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\",\"bill_status\":\"%d\"",self.job_id,3];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_queryJobBillList" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo * response) {
        if (response && response.success) {
            NSArray *dataArr = [JobBillModel objectArrayWithKeyValuesArray:response.content[@"job_bill_list"]];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:dataArr];

//            weakSelf.allArray = [[NSMutableArray alloc] init];
//            for (JobBillModel* model in weakSelf.dataArray) {
//                NSArray* plArray = [PayListModel objectArrayWithKeyValuesArray:model.stu_pay_list];
//                [weakSelf.allArray addObject:plArray];
//            }
        }
        [weakSelf.tableView reloadData];
    }];
    
}


#pragma mark - ***** UITableView Delegate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobBillDetailCell *cell = [JobBillDetailCell cellWithTableView:tableView];

    JobBillModel* jbModel = [self.dataArray objectAtIndex:indexPath.section];
    if (jbModel.stu_pay_list) {
        NSArray* plArray = [PayListModel objectArrayWithKeyValuesArray:jbModel.stu_pay_list];
        PayListModel* plModel = [plArray objectAtIndex:indexPath.row];
        [cell refreshWithData:plModel];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count > 0 ? self.dataArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    JobBillModel* jbModel = [self.dataArray objectAtIndex:section];
    if (jbModel.stu_pay_list) {
        NSArray* plArray = [PayListModel objectArrayWithKeyValuesArray:jbModel.stu_pay_list];
        return plArray.count ? plArray.count : 0;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88-38-10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JobBillModel *jbModel = [self.dataArray objectAtIndex:section];
    
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    sectionHeadView.backgroundColor = [UIColor XSJColor_grayDeep];
    UIView *separateline = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.6)];
    separateline.backgroundColor = MKCOLOR_RGB(200, 199, 204);
    [sectionHeadView addSubview:separateline];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = MKCOLOR_RGBA(0, 0, 0,0.22);
    label.textColor = [UIColor whiteColor];
    NSString *timeStr ;
    if (jbModel.bill_type.intValue == 1) {
        timeStr = [DateHelper jobBillTimeStrWithNum:jbModel.bill_start_date];
        
    }else{
        timeStr = [DateHelper jobBillTimeStrWithNum:jbModel.bill_end_date];
    }
    
    label.text = [NSString stringWithFormat:@"  %@  ", timeStr];
    label.font = [UIFont systemFontOfSize:14];
    [label setCorner];
    [sectionHeadView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(21));
        make.centerX.equalTo(sectionHeadView);
        make.centerY.equalTo(sectionHeadView);
    }];
    
    return sectionHeadView;

    
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    topView.backgroundColor = COLOR_RGB(240, 240, 240);
//    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 38)];
//    botView.backgroundColor = COLOR_RGB(255, 255, 255);
    
 
//    UIView *separatelineDown = [[UIView alloc]initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 0.6)];
//    separatelineDown.backgroundColor = COLOR_RGB(200, 199, 204);
    
//    [sectionHeadView addSubview:separatelineDown];
//    [sectionHeadView addSubview:topView];
//    [sectionHeadView addSubview:botView];
    //当日服务费
//    UILabel *otherLabel = [[UILabel alloc]init];
//    otherLabel.backgroundColor = [UIColor whiteColor];
//    otherLabel.textColor = COLOR_RGB(89, 89, 89);
//    otherLabel.font = [UIFont systemFontOfSize:14];
//    [botView addSubview:otherLabel];
    
//    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@(21));
//        make.left.mas_equalTo(8);
//        make.centerY.equalTo(botView);
//    }];
//    otherLabel.attributedText = [self serveFeeAttributedTextWithPay:[NSString stringWithFormat:@"¥%.2f",jbModel.service_fee.intValue * 0.01] withAccurateJob:jbModel.bill_type];

}

- (NSMutableAttributedString *)serveFeeAttributedTextWithPay:(NSString *)paySalary withAccurateJob:(NSNumber *)billType{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = MKCOLOR_RGB(255, 87, 34);
    dic[NSFontAttributeName] = [UIFont fontWithName:kFont_RSR size:14];
    NSMutableAttributedString *tempPaySalary = [[NSMutableAttributedString alloc] initWithString:paySalary attributes:dic];
    NSMutableAttributedString *aStrM;
    if (billType.intValue == 1) {
        aStrM = [[NSMutableAttributedString alloc] initWithString:@"当日服务费: "];
    }else{
        aStrM = [[NSMutableAttributedString alloc] initWithString:@"总服务费: "];
    }
    
    [aStrM appendAttributedString:tempPaySalary];

    return aStrM;
}

- (void)backToLastView{
    if (self.isFromPay) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end


