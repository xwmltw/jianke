//
//  InterestJob_VC.m
//  jianke
//
//  Created by xiaomk on 16/5/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "InterestJob_VC.h"
#import "JobTypeListCell.h"
#import "WDConst.h"
#import "JobClassifyInfoModel.h"
#import "CityModel.h"
#import "CityTool.h"
#import "DaySelectView.h"
#import "UIHelper.h"
#import "LookupResume_VC.h"
#import "GuideMaskView.h"

@interface InterestJob_VC (){
    NSArray* _jobClassifierArray;   /** 岗位类型列表 */
    NSMutableArray* _childAreaArray;   /** 子区域列表 */
    StuSubscribeModel* _ssModel;
    BOOL _isParentCity;
    BOOL _needCallBlock;    /** 是否调用block */
}
@property (nonatomic, strong) CityModel* cityModel;
@end

@implementation InterestJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兼职意向";
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self setUIHaveBottomView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH-32, 60-16)];
    labTitle.text = @"选择您的兼职意向，好工作主动来找您！";
    labTitle.textColor = [UIColor XSJColor_tGray];
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.numberOfLines = 0;
    [headView addSubview:labTitle];
    
    self.tableView.tableHeaderView = headView;
    
    _cityModel = [[UserData sharedInstance] city];

    [self loadDataSource];
}

- (void)loadDataSource{
    _childAreaArray = [NSMutableArray array];
    WEAKSELF
    NSString* conten = [NSString stringWithFormat:@"\"city_id\":%@",_cityModel.id.stringValue];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryStuSubscribeConfig" andContent:conten];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            _ssModel = [StuSubscribeModel objectWithKeyValues:response.content];
            
            _jobClassifierArray = _ssModel.job_classifier_list;
            if (_ssModel.city_info) {
                _ssModel.city_info.isParentCity = YES;
                _ssModel.city_info.isSelect = _ssModel.city_id ? YES : NO;
                [_childAreaArray addObject:_ssModel.city_info];
            }
            [_childAreaArray addObjectsFromArray:_ssModel.child_area];
            
            [weakSelf updateSelectArea];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - ***** 按钮事件 ******
- (void)btnJobClassOnclick:(UIButton*)sender{
    if (!sender.selected) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect = YES"];
        NSArray *array = [_jobClassifierArray filteredArrayUsingPredicate:predicate];
        if (array.count >= 5) {
            [UIHelper toast:@"意向岗位分类不能超过5个哦~"];
            return;
        }
    }
    sender.selected = !sender.selected;
    JobClassifyInfoModel* model = [_jobClassifierArray objectAtIndex:sender.tag];
    model.isSelect = sender.selected;
}

- (void)btnAreaOnclick:(UIButton*)sender{
    [self setBtnSelected:sender];
    if (sender.selected) {
        [self cancelParentBtnSelected];
    }
}

- (void)btnParentAreaOnclick:(UIButton *)sender{
    [self setBtnSelected:sender];
    if (sender.selected) {
        [self cancelOtherBtnSelected];
    }
}

- (void)updateSelectArea{
    NSArray* _selectJobClassifyIdArray = _ssModel.job_classify_id_list;
    NSArray* _selectAreaIdArray = _ssModel.address_area_id_list;
    if (_selectAreaIdArray && _selectAreaIdArray.count) {
        for (CityModel* cityModel in _childAreaArray) {
            NSInteger index = [_selectAreaIdArray indexOfObject:cityModel.id];
            cityModel.isSelect = (index != NSNotFound);
        }
    }
    
    if (_selectJobClassifyIdArray && _selectJobClassifyIdArray.count) {
        for (JobClassifyInfoModel* model in _jobClassifierArray) {
            for (NSString* strId in _selectJobClassifyIdArray ) {
                if (model.job_classfier_id.integerValue == strId.integerValue) {
                    model.isSelect = YES;
                    break;
                }
            }
        }
    }
}

- (void)setBtnSelected:(UIButton *)sender{
    sender.selected = !sender.selected;
    CityModel* model = [_childAreaArray objectAtIndex:sender.tag];
    model.isSelect = sender.selected;
}

- (void)cancelOtherBtnSelected{
    CityModel *model = nil;
    for (NSInteger index = 1; index < _childAreaArray.count; index++) {
        model = [_childAreaArray objectAtIndex:index];
        model.isSelect = NO;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cancelParentBtnSelected{
    CityModel *model = [_childAreaArray objectAtIndex:0];
    if (model.isSelect) {
        model.isSelect = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

/** 提交 */
- (void)btnBottomOnclick:(UIButton *)sender{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect = YES"];
    NSArray *array = [_jobClassifierArray filteredArrayUsingPredicate:predicate];
    if (array.count > 5) {
        [UIHelper toast:@"意向岗位分类不能超过5个哦~"];
        return;
    }
    
    NSMutableArray* jcIdArray = [[NSMutableArray alloc] init];
    for (JobClassifyInfoModel* model in _jobClassifierArray) {
        if (model.isSelect) {
            [jcIdArray addObject:model.job_classfier_id.stringValue];
        }
    }
    NSMutableArray* areaIdArray = [[NSMutableArray alloc] init];
    for (CityModel* model in _childAreaArray) {
        if (model.isSelect) {
            [areaIdArray addObject:model.id.stringValue];
            _isParentCity = model.isParentCity;
        }
    }
    UpdateStuSubscribeModel* usModel = [[UpdateStuSubscribeModel alloc] init];
    usModel.job_classify_id_list = jcIdArray;
    if (areaIdArray.count == 0 || _isParentCity) {
        CityModel *city = _childAreaArray[0];
        usModel.city_id = city.id;
    }else{
        usModel.address_area_id_list = areaIdArray;
    }
    
    NSString* content = [usModel getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_updateStuSubscribeConfig" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"提交成功"];
            if (self.isFromResume) {
                MKBlockExec(self.block, nil);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:NO];
                MKBlockExec(self.block, nil);
            }
        }
    }];
}
- (void)backToLastView{
    [GuideMaskView showTitle:@"提示" content:@"您编辑的信息还未保存，确定要退出吗?" cancel:@"取消" commit:@"确定" block:^(NSInteger result) {
        if (result == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString* cellIdentifier = @"JobTypeListCell";
        JobTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [JobTypeListCell new];
        }
        cell.btn1.hidden = YES;
        cell.btn2.hidden = YES;
        cell.btn3.hidden = YES;
        cell.btn4.hidden = YES;
        
        [cell.btn1 addTarget:self action:@selector(btnJobClassOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(btnJobClassOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(btnJobClassOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(btnJobClassOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSInteger tagBase = 0;
        NSInteger startNum = indexPath.row * 4;
        NSInteger endNum = startNum + 4 >= _jobClassifierArray.count ? _jobClassifierArray.count : startNum + 4;
        for (NSInteger i = startNum; i < endNum; i++ ) {
            NSInteger count = i%4;
            JobClassifyInfoModel* model = [_jobClassifierArray objectAtIndex:i];
            if (count == 0) {
                cell.btn1.hidden = NO;
                [cell.btn1 setTitle:model.job_classfier_name forState:UIControlStateNormal];
                cell.btn1.selected = model.isSelect;
                cell.btn1.tag = tagBase + i;
            }else if (count == 1){
                cell.btn2.hidden = NO;
                [cell.btn2 setTitle:model.job_classfier_name forState:UIControlStateNormal];
                cell.btn2.selected = model.isSelect;
                cell.btn2.tag = tagBase + i;
            }else if (count == 2){
                cell.btn3.hidden = NO;
                [cell.btn3 setTitle:model.job_classfier_name forState:UIControlStateNormal];
                cell.btn3.selected = model.isSelect;
                cell.btn3.tag = tagBase + i;
            }else if (count == 3){
                cell.btn4.hidden = NO;
                [cell.btn4 setTitle:model.job_classfier_name forState:UIControlStateNormal];
                cell.btn4.selected = model.isSelect;
                cell.btn4.tag = tagBase + i;
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString* cellIdentifier = @"JobTypeListCell";
        JobTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [JobTypeListCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.btn1.hidden = YES;
        cell.btn2.hidden = YES;
        cell.btn3.hidden = YES;
        cell.btn4.hidden = YES;
        
        if (indexPath.row == 0) {
            [cell.btn1 addTarget:self action:@selector(btnParentAreaOnclick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.btn1 addTarget:self action:@selector(btnAreaOnclick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.btn2 addTarget:self action:@selector(btnAreaOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(btnAreaOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(btnAreaOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger tagBase = 0;
        NSInteger startNum = indexPath.row * 4;
        NSInteger endNum = startNum + 4 >= _childAreaArray.count ? _childAreaArray.count : startNum + 4;
        for (NSInteger i = startNum; i < endNum; i++ ) {
            NSInteger count = i%4;
            CityModel* model = [_childAreaArray objectAtIndex:i];
            if (count == 0) {
                cell.btn1.hidden = NO;
                [cell.btn1 setTitle:model.name forState:UIControlStateNormal];
                cell.btn1.selected = model.isSelect;
                cell.btn1.tag = tagBase + i;
            }else if (count == 1){
                cell.btn2.hidden = NO;
                [cell.btn2 setTitle:model.name forState:UIControlStateNormal];
                cell.btn2.selected = model.isSelect;
                cell.btn2.tag = tagBase + i;
            }else if (count == 2){
                cell.btn3.hidden = NO;
                [cell.btn3 setTitle:model.name forState:UIControlStateNormal];
                cell.btn3.selected = model.isSelect;
                cell.btn3.tag = tagBase + i;
            }else if (count == 3){
                cell.btn4.hidden = NO;
                [cell.btn4 setTitle:model.name forState:UIControlStateNormal];
                cell.btn4.selected = model.isSelect;
                cell.btn4.tag = tagBase + i;
            }
        }
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 50;
    }else if (indexPath.section == 2){
        return 180;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger num;
        NSInteger left = _jobClassifierArray.count%4;
        if (left == 0) {
            num = _jobClassifierArray.count / 4;
        }else{
            num = _jobClassifierArray.count / 4 + 1;
        }
        return num;
    }else if (section == 1){
        NSInteger num;
        NSInteger left = _childAreaArray.count%4;
        if (left == 0) {
            num = _childAreaArray.count / 4;
        }else{
            num = _childAreaArray.count / 4 + 1;
        }
        return num;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 32)];
    view.backgroundColor = [UIColor XSJColor_grayTinge];
    [view setBorderWidth:0.5 andColor:[UIColor XSJColor_grayLine]];
    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, tableView.size.width-32, 32)];
    labTitle.backgroundColor = [UIColor clearColor];
    labTitle.textColor = [UIColor XSJColor_tGray];
    labTitle.font = [UIFont systemFontOfSize:14];
    [view addSubview:labTitle];
    
    if (section == 0) {
        labTitle.text = @"意向岗位（最多可选5个）";
    }else if (section == 1){
        labTitle.text = @"意向区域（可多选）";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 16)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
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
