//
//  PostWorkExpe_VC.m
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostWorkExpe_VC.h"
#import "EditResumeCell_Info.h"
#import "PostWorkCell_date.h"
#import "PostWorkCell_content.h"
#import "JobTypeList_VC.h"

@interface PostWorkExpe_VC () <PostWorkCell_dateDelegate>

@property (nonatomic, strong) ResumeExperienceModel *comparedModel; /*!< 比较模型 */
@property (nonatomic, strong) NSDate *startDate;    /*!< 开始日期 */
@property (nonatomic, strong) NSDate *endDate;      /*!< 结束日期 */
@property (nonatomic, strong) NSDate *tmpDate;      /*!< 临时变量 */

@end

@implementation PostWorkExpe_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
    if (_model.job_begin_time) {
        self.startDate = [NSDate dateWithTimeIntervalSinceNow:_model.job_begin_time.longLongValue * 0.001];
    }
    if (_model.job_end_time) {
        self.endDate = [NSDate dateWithTimeIntervalSinceNow:_model.job_end_time.longLongValue * 0.001];
    }
    
    if (self.isEdit) {
        self.title = @"编辑工作经历";
        NSAssert(_model, @"model属性不能为nil");
        self.comparedModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.model]];
    }else{
        self.title = @"增加工作经历";
    }
    
    [self loadDatas];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"PostWorkCell_date") forCellReuseIdentifier:@"PostWorkCell_date"];
    [self.tableView registerClass:[PostWorkCell_content class] forCellReuseIdentifier:@"PostWorkCell_content"];
    [self.tableView registerNib:nib(@"EditResumeCell_Info") forCellReuseIdentifier:@"EditResumeCell_Info"];
    
}

- (void)loadDatas{
    [self.dataSource addObject:@(postWorkExpCellType_jobType)];
    [self.dataSource addObject:@(postWorkExpCellType_jobTitle)];
    [self.dataSource addObject:@(PostWorkExpCellType_date)];
    [self.dataSource addObject:@(PostWorkExpCellType_content)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    postWorkExpCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case postWorkExpCellType_jobType:
        case postWorkExpCellType_jobTitle:{
            EditResumeCell_Info *cell = [tableView dequeueReusableCellWithIdentifier:@"EditResumeCell_Info" forIndexPath:indexPath];
            cell.postCellType = cellType;
            cell.model = self.model;
            return cell;
        }
        case PostWorkExpCellType_date:{
            PostWorkCell_date *cell = [tableView dequeueReusableCellWithIdentifier:@"PostWorkCell_date" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.model];
            return cell;
        }
        case PostWorkExpCellType_content:{
            PostWorkCell_content *cell = [tableView dequeueReusableCellWithIdentifier:@"PostWorkCell_content" forIndexPath:indexPath];
            cell.model = self.model;
            return cell;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    postWorkExpCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case PostWorkExpCellType_content:{
            return 206.0f;
        }
            break;
        default:
            break;
    }
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    postWorkExpCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case postWorkExpCellType_jobType:{
            [self jobTypeOnclick];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PostWorkCell_dateDelegate
- (void)PostWorkCell_date:(PostWorkCell_date *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_dateBegin:{
            [self btnDateStartOnclick];
        }
            break;
        case BtnOnClickActionType_dateEnd:{
            [self btnDateEndOnclick];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 业务方法

- (void)jobTypeOnclick{
    WEAKSELF
    JobTypeList_VC* vc = [[JobTypeList_VC alloc] init];
    vc.postJobType = PostJobType_common;
    vc.block = ^(JobClassifyInfoModel* model){
        if (model) {
            weakSelf.model.job_classify_id = model.job_classfier_id;
            weakSelf.model.job_classify_name = model.job_classfier_name;
            [weakSelf.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/** 开始时间 */
- (void)btnDateStartOnclick{
    [self.view endEditing:YES];
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 设置时间限制
    NSDate *minDate = [DateHelper zeroTimeOfToday];
    [datepicker setMaximumDate:minDate];
    
    if (self.endDate) {
        [datepicker setMaximumDate:self.endDate];   // 开始时间必须小于结束日期
    }
    
    if (self.startDate != nil) {
        [datepicker setDate:self.startDate];
    }else{
        [datepicker setDate:[DateHelper zeroTimeOfToday]];
    }
    self.tmpDate = datepicker.date;
    WEAKSELF
    [XSJUIHelper showConfirmWithView:datepicker msg:nil title:@"选择时间" cancelBtnTitle:@"取消" okBtnTitle:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            weakSelf.startDate = weakSelf.tmpDate;
            weakSelf.model.job_begin_time = @([weakSelf.startDate timeIntervalSince1970] * 1000);
            [weakSelf.tableView reloadData];
        }
    }];
}

/** 结束时间 */
- (void)btnDateEndOnclick{
    [self.view endEditing:YES];
    
    if (!self.startDate) {
        [UIHelper toast:@"请先设置开始日期!"];
        return;
    }
    
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 设置时间限制
    NSDate *minDate = [DateHelper zeroTimeOfToday];
    if (self.startDate) {
        minDate = self.startDate; // 结束时间必须大于开始日期
    }
    [datepicker setMinimumDate:minDate];
    
    NSDate *maxDate = [DateHelper zeroTimeOfToday];
    [datepicker setMaximumDate:maxDate];
    
    // 值不为空时  为时间控件赋值为当前的值
    if (self.endDate) {
        if ([self.endDate isLaterThan:maxDate]) {
            [datepicker setDate:maxDate];
        }else{
            [datepicker setDate:self.endDate];
        }
    }else if (self.startDate){
        [datepicker setDate:self.startDate];
    } else {
        [datepicker setDate:[DateHelper zeroTimeOfToday]];
    }
    self.tmpDate = datepicker.date;
    WEAKSELF
    [XSJUIHelper showConfirmWithView:datepicker msg:nil title:@"选择时间" cancelBtnTitle:@"取消" okBtnTitle:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            weakSelf.endDate = weakSelf.tmpDate;
            weakSelf.model.job_end_time = @([weakSelf.endDate timeIntervalSince1970] * 1000);
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    if (datePicker.date) {
        self.tmpDate = datePicker.date;
    }
}

- (void)rightItemOnClick{
    [self.view endEditing:YES];
    
    if (!self.model.job_classify_id) {
        [UIHelper toast:@"请选择岗位类型"];
        return;
    }
    if (!self.model.job_title.length) {
        [UIHelper toast:@"请输入岗位名称"];
        return;
    }
    if (self.model.job_title.length > 20) {
        [UIHelper toast:@"岗位名称不能超过20个字"];
        return;
    }
    
    if (!self.model.job_begin_time) {
        [UIHelper toast:@"请选择工作开始时间"];
        return;
    }
    if (!self.model.job_end_time) {
        [UIHelper toast:@"请选择工作结束时间"];
        return;
    }
    WEAKSELF
    [[XSJRequestHelper sharedInstance] postResumeExperience:self.model block:^(id result) {
        if (result) {
            [UIHelper toast:@"保存成功"];
            MKBlockExec(self.block, nil);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - lazy

- (ResumeExperienceModel *)model{
    if (!_model) {
        _model = [[ResumeExperienceModel alloc] init];
    }
    return _model;
}

- (void)backToLastView{
    [self.view endEditing:YES];
    [self checkIsModified:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)checkIsModified:(MKBlock)block{
    BOOL isModified = NO;
    if (self.isEdit) {
        if (![self.model.job_classify_id isEqual:self.comparedModel.job_classify_id]) {
            isModified = YES;
        }else if (![self.model.job_title isEqualToString:self.comparedModel.job_title]) {
            isModified = YES;
        }else if (![self.model.job_begin_time isEqual:self.comparedModel.job_begin_time]) {
            isModified = YES;
        }else if (![self.model.job_end_time isEqual:self.comparedModel.job_end_time]) {
            isModified = YES;
        }else if (![self.model.job_content isEqualToString:self.comparedModel.job_content]) {
            isModified = YES;
        }
    }else{
        if (self.model.job_classify_id) {
            isModified = YES;
        }else if (self.model.job_title.length) {
            isModified = YES;
        }else if (self.model.job_begin_time) {
            isModified = YES;
        }else if (self.model.job_end_time) {
            isModified = YES;
        }else if (self.model.job_content.length) {
            isModified = YES;
        }
    }
    if (isModified) {
        [MKAlertView alertWithTitle:nil message:@"您编辑的信息还未保存，确定要退出吗？" cancelButtonTitle:@"果断退出" confirmButtonTitle:@"留在这里" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                MKBlockExec(block, nil);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
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
