//
//  JobQA_VC.m
//  jianke
//
//  Created by xuzhi on 16/7/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobQA_VC.h"
#import "JobQACell.h"
#import "JobDetailCell_QA.h"

@interface JobQA_VC () <UIAlertViewDelegate>{
    QueryParamModel *_queryParam;   //分页
    QueryJobQAParam *_queryQAParam; //请求模型
    UIImageView *_image;
    UILabel *_lab1,*_lab2;
    
}

@property (nonatomic, strong) NSMutableArray *qaCellArray; /*!< 雇主答疑Cell数组, 存放JobQACellModel模型 */
@property (nonatomic, strong) JobQAInfoModel *qaAnswerModel; /*!< 雇主回复兼客的提问 */
@property(nonatomic,assign)WDLogin_type userType;   /*<! 用户类型 */

@end

@implementation JobQA_VC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.btntitles = @[@"提问题"];
    self.userType = [[[UserData sharedInstance] getLoginType] integerValue];
    if (self.userType == WDLoginType_Employer) {
        [self initUIWithType:DisplayTypeOnlyTableView];
    }else{
        [self initUIWithType:DisplayTypeTableViewAndBottom];
    }

    [self setData];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 68;
    [self.tableView.header beginRefreshing];
}

- (void)setData{
    self.title = @"雇主答疑";
    self.qaCellArray = [NSMutableArray array];
    _queryParam = [[QueryParamModel alloc] init];
    _queryQAParam = [[QueryJobQAParam alloc] init];
    _queryQAParam.query_param = _queryParam;
    _queryQAParam.job_id = _jobId;
    
}

- (void)nilDataUi{
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"job_QA_nil"];
    _image = image;
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.text = @"还没有兼客提问哦";
    [lab1 setFont:[UIFont systemFontOfSize:20.0f]];
    [lab1 setTextColor:MKCOLOR_RGB(43, 188, 223)];
    _lab1 = lab1;
    
    UILabel *lab2 = [[UILabel alloc]init];
    lab2.text = @"点击下方\"提问题\"开始咨询";
    [lab2 setFont:[UIFont systemFontOfSize:14.0f]];
    [lab2 setTextColor:MKCOLOR_RGB(43, 188, 212)];
    _lab2 = lab2;

    [self.view addSubview:image];
    [self.view addSubview:lab1];
    [self.view addSubview:lab2];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
//        make.left.equalTo(self.view).offset(40);
    }];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(12);
        make.centerX.equalTo(image);
        
    }];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(8);
        make.centerX.equalTo(lab1);
    }];
    

}

#pragma mark - 网络请求

- (void)getMoreData{
    if (_queryParam.page_num.integerValue == 1) {
        _queryParam.page_num = @(_queryParam.page_num.integerValue+1);
    }
    WEAKSELF
    [[UserData sharedInstance] queryJobQAWithParam:_queryQAParam isShowLoding:NO block:^(NSArray *result) {
        if (result && result.count) {
            _queryParam.page_num = @(_queryParam.page_num.integerValue+1);
            [weakSelf.qaCellArray addObjectsFromArray:result];
            [weakSelf.tableView reloadData];
           
        }else{
            [weakSelf nilDataUi];
        }
        
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (void)getNewData{
    _queryParam.page_num = @1;
    WEAKSELF
    [[UserData sharedInstance] queryJobQAWithParam:_queryQAParam isShowLoding:NO block:^(NSArray *result) {
        if (result && result.count) {
            weakSelf.qaCellArray = [result mutableCopy];
            [weakSelf.tableView reloadData];
            _image.hidden = YES;
            _lab1.hidden = YES;
            _lab2.hidden = YES;
        }else{
            [weakSelf nilDataUi];
        }
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)headerRefresh{
    [self getNewData];
}

- (void)footerRefresh{
    [self getMoreData];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.qaCellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobDetailCell_QA* cell = [JobDetailCell_QA cellWithTableView:tableView];
    JobQAInfoModel* model = _qaCellArray[indexPath.row];
    model.cellHeight = 68 ;
    
    [cell.btnReport addTarget:self action:@selector(btnReportOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAnswer addTarget:self action:@selector(btnAnswerOnclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAnswer.tag = indexPath.row;
    if (self.userType == WDLoginType_Employer) {
        cell.btnAnswer.hidden = NO;
    }else{
        cell.btnAnswer.hidden = YES;
    }
    
    // 头像
    [cell.imgHead sd_setImageWithURL:[NSURL URLWithString:model.question_user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
    // 姓名
    if (model.question_user_true_name && model.question_user_true_name.length) {
        NSString *str = model.question_user_true_name;
        if(str.length>1){
            NSString *str2 = [str substringWithRange:NSMakeRange(1, 1)];
            str = [str stringByReplacingOccurrencesOfString:str2 withString:@"*"];
        }
        cell.labJKName.text = str;
    } else {
        cell.labJKName.text = @"兼客用户";
    }
    
    // 问题
    cell.labQuestion.text = model.question;
    // 提问时间
    cell.labQuestionTime.text = [DateHelper getTimeRangeWithSecond:model.question_time];
    
    CGSize labQuestionSize = [cell.labQuestion contentSizeWithWidth:SCREEN_WIDTH-120];
    if (labQuestionSize.height > 17) {
        model.cellHeight = model.cellHeight - 17 + labQuestionSize.height;
    }
    
    // 回复
    [cell.btnAnswer setTitleColor:[UIColor XSJColor_tBlue] forState:UIControlStateNormal];
    if (model.answer.length > 0) {
        cell.labEpRevert.hidden = NO;
        cell.labAnswer.hidden = NO;
        cell.labAnswerTime.hidden = NO;
        cell.btnAnswer.hidden = YES;
        cell.labAnswerTime.text = [DateHelper getTimeRangeWithSecond:model.answer_time];
        cell.labAnswer.text = model.answer;
        CGSize labAnswerSize = [cell.labAnswer contentSizeWithWidth:SCREEN_WIDTH-160];
        model.cellHeight = model.cellHeight + 38 - 17 + labAnswerSize.height;
        
    }else{
        if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer) {
            cell.labEpRevert.hidden = YES;
            cell.labAnswer.hidden = YES;
            cell.labAnswerTime.hidden = YES;
            cell.btnAnswer.hidden = NO;
            model.cellHeight = model.cellHeight + 38;
        }else{
            cell.viewAnswer.hidden = YES;
        }
        
    }
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    JobQAInfoModel* model = _qaCellArray[indexPath.row];
    return model.cellHeight;
}

#pragma mark - 事件响应
- (void)btnReportOnclick:(UIButton*)sender{
    [UIHelper toast:@"举报成功"];
}

- (void)btnAnswerOnclick:(UIButton*)sender{
    JobQAInfoModel *model = [self.qaCellArray objectAtIndex:sender.tag];
    if (model) {
        self.qaAnswerModel = model;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"回复" message:@"回复兼客提问" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 142;
        [alertView show];
    }
}

#pragma mark - ***** JDGroupType_QA ******
- (void)clickOnview:(UIView *)bottomView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 判读是否登录
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提问" message:@"有什么问题要问雇主呢?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 141;
            [alertView show];
        }
    }];
}

#pragma mark - ***** UIAlertView delegate ******
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (alertView.tag == 141) {
            if (textField.text.length < 1) {
                [UIHelper toast:@"提问内容不能为空"];
                [alertView show];
                return;
            }
            WEAKSELF
            [[UserData sharedInstance] stuJobQuestionWithJobId:self.jobId quesiton:textField.text block:^(id obj) {
                [UIHelper toast:@"发送成功"];
                [weakSelf.tableView.header beginRefreshing];
            }];
        }else if (alertView.tag  == 142){   //雇主视角
            if (textField.text.length < 1) {
                [UIHelper toast:@"回复内容不能为空"];
                [alertView show];
                return;
            }
            WEAKSELF
            [[UserData sharedInstance] entJobAnswerWithJobId:self.jobId quesitonId:[self.qaAnswerModel.qa_id description] answer:textField.text block:^(id obj) {
                if (obj) {
                    [UIHelper toast:@"发送成功"];
                    weakSelf.qaAnswerModel.answer = textField.text;
                    weakSelf.qaAnswerModel.answer_time = @([DateHelper getTimeStamp4Second]);
                    [weakSelf.tableView reloadData];
                }
            }];
        }
        
        
    }
}
@end
