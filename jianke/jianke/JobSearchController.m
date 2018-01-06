//
//  JobSearchController.m
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobSearchController.h"
#import "UserData.h"
#import "BtnView.h"
#import "DataBtn.h"
#import "JobClassifierModel.h"
#import "JobTopicModel.h"
#import "JobController.h"
#import "CitySearchBar.h"
#import "JobExpress_VC.h"

@interface JobSearchController () <BtnViewDelegate, WDTableDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JobExpress_VC *jobExpressVC;

@property (nonatomic, strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSizeHeightConstraint; /*!< scrollView contentSize 高度约束 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicViewHeightConstraint; /*!< 专题View高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobClassViewHeightContraint; /*!< 分类View高度约束 */

@property (weak, nonatomic) IBOutlet UIView *topicView; /*!< 专题View */
@property (weak, nonatomic) IBOutlet UIView *jobClassView; /*!< 分类View */

@property (nonatomic, weak) BtnView *jobClassBtnView;
@property (nonatomic, weak) BtnView *topicBtnView;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, weak) UILabel *noDataLabel;
@property (nonatomic, strong) UIView *noSignalView;
@property (nonatomic, weak) UITextField *searchBar;

@end

@implementation JobSearchController

#pragma mark - lazy
- (UIView *)noDataView
{
    if (!_noDataView) {
        
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH - 100, 50)];
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:_noDataView.bounds];
        noDataLabel.textColor = [UIColor grayColor];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.numberOfLines = 0;
        self.noDataLabel = noDataLabel;
        [_noDataView addSubview:noDataLabel];
        [self.tableView addSubview:_noDataView];
    }
    
    return _noDataView;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    // 添加搜索栏
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 126, 44)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSMutableAttributedString *placeHoldStr = [[NSMutableAttributedString alloc] initWithString:@"输入岗位关键词" attributes:dic];
    searchBar.attributedPlaceholder = placeHoldStr;
    searchBar.textColor = [UIColor whiteColor];
    searchBar.font = [UIFont systemFontOfSize:18];
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBar addTarget:self action:@selector(searchChanged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    // 添加tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    tableView.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    // 添加搜索结果列表
    self.jobExpressVC = [[JobExpress_VC alloc]init];
    self.jobExpressVC.tableView = self.tableView;
    self.jobExpressVC.owner = self;
    self.jobExpressVC.delegate = self;
    self.jobExpressVC.refreshType = WdTableViewRefreshTypeHeader | WdTableViewRefreshTypeFooter;
    self.jobExpressVC.requestParam.serviceName = @"shijianke_queryJobListFromApp";
    self.jobExpressVC.requestParam.typeClass = NSClassFromString(@"JobModel");
    self.jobExpressVC.requestParam.arrayName = @"self_job_list";
    self.jobExpressVC.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    self.jobExpressVC.requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
    
    /** 获取数据 */
    [self getData];
}

- (void)noInternet{
    self.noSignalView = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    [self.scrollView addSubview:self.noSignalView];
    self.noSignalView.centerX = self.scrollView.centerX;
    self.noSignalView.y = 200;
}

- (void)getData
{
    // 获取岗位列表
    WEAKSELF
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobClassArray) {
       
        if (jobClassArray && jobClassArray.count) {

            BtnView *jobClassBtnView = [[BtnView alloc] initWithWidth:SCREEN_WIDTH - 40 dataType:DataTypeJobClass dataArray:jobClassArray];
            
            jobClassBtnView.delegate = self;
            weakSelf.jobClassBtnView = jobClassBtnView;
            
            [weakSelf.jobClassView addSubview:jobClassBtnView];
            
            weakSelf.jobClassViewHeightContraint.constant = jobClassBtnView.height;
            
        } else {

            weakSelf.jobClassViewHeightContraint.constant = 0;
//            self.noSignalView.hidden = NO;
            ELog(@"======无完了");
            [self noInternet];
        }
        // 获取专题列表
        [[UserData sharedInstance] getJobTopicListWithBlock:^(NSArray *jobTopicArray) {
           
            if (jobTopicArray && jobTopicArray.count) {

                BtnView *topicBtnView = [[BtnView alloc] initWithWidth:SCREEN_WIDTH - 40 dataType:DataTypeTopic dataArray:jobTopicArray];
                
                topicBtnView.delegate = self;
                weakSelf.topicBtnView = topicBtnView;
                
                [weakSelf.topicView addSubview:topicBtnView];
                weakSelf.topicViewHeightConstraint.constant = topicBtnView.height;
                
            } else {

                weakSelf.topicViewHeightConstraint.constant = 0;
            }
            
            // 设置scrollView的contentSize高度
            weakSelf.scrollViewContentSizeHeightConstraint.constant = 180 + weakSelf.jobClassBtnView.height + weakSelf.topicBtnView.height;
        }];
    }];
    
}


#pragma mark - textField
- (void)searchChanged:(UITextField *)textField
{
    if (textField.text && textField.text.length) {
        NSString *cityId = [[UserData sharedInstance] city].id.description;
        self.jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_title:\"%@\"}", cityId, textField.text];
        self.tableView.hidden = NO;
        [self.jobExpressVC showLatest];
        
    } else {
        
        self.tableView.hidden = YES;
    }
}
//键盘搜索按钮的事件
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    
    [theTextField resignFirstResponder];
//    if (theTextField.text && theTextField.text.length) {
//        
//        NSString *cityId = [[UserData sharedInstance] city].id.description;
//        self.jobExpressVC.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_title:\"%@\"}", cityId, theTextField.text];
//        self.tableView.hidden = NO;
//        [self.jobExpressVC showLatest];
//        
//    } else {
//        
//        self.tableView.hidden = YES;
//    }
//
    return YES;
}
#pragma mark - BtnViewDelegate

- (void)btnView:(BtnView *)btnView didClickBtn:(DataBtn *)btn
{
    NSString *cityId = [[UserData sharedInstance] city].id.description;
    
    // 岗位分类
    if (btnView == self.jobClassBtnView) {
    
        DLog(@"岗位分类点击");
        JobClassifierModel *jobClass = btn.dataModel;
        NSString *jobClassId = jobClass.job_classfier_id.description;
        JobController *vc = [[JobController alloc] init];
        vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_type_id:[%@]}", cityId, jobClassId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 岗位专题
    if (btnView == self.topicBtnView) {
        
        DLog(@"岗位专题点击");
        JobTopicModel *jobTopic = btn.dataModel;
        NSString *topicId = jobTopic.topic_id.description;
        JobController *vc = [[JobController alloc] init];
        vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, topic_id:%@}", cityId, topicId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - WDTableViewDelegate
- (void)requestDidFinish:(id)data{
    NSArray *dataArray = data;
    
    if (dataArray && !dataArray.count) {
        self.jobExpressVC.noDataView.hidden = YES;
        self.jobExpressVC.noSignalView.hidden = YES;
        self.noDataLabel.text = [NSString stringWithFormat:@"抱歉,没有搜索到与\"%@\"相关的兼职信息", self.searchBar.text];
        self.noDataView.hidden = NO;
        
    } else {
        self.jobExpressVC.noDataView.hidden = YES;
        self.jobExpressVC.noSignalView.hidden = YES;
        self.noDataView.hidden = YES;
    }
}


@end
