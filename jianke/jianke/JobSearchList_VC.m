//
//  JobSearchList_VC.m
//  jianke
//
//  Created by xiaomk on 16/1/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobSearchList_VC.h"
#import "WDConst.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetail_VC.h"
#import "JobClassCollectionViewCell.h"
#import "JobClassifierModel.h"
#import "JobController.h"
#import "GetEnterpriseModel.h"
#import "EpProfile_VC.h"
#import "SearchEpList_VC.h"
#import "JobSearchEpModel_Cell.h"
#import "JobSearchList_Cell.h"

@interface JobSearchList_VC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSMutableArray* _jobClassArray;
    NSMutableArray* _historyArray;
    NSMutableArray* _searchDatasArray;
    QueryParamModel* _queryParam;
    
    CGFloat _jobClassWidth;
    CGFloat _jobClassHeight;
    
    NSNumber* _entCount;   /*!< 搜索到的雇主数量 */
    NSMutableArray* _entArray;  /*!< 搜索的雇主列表 */
    NSString* _searchStr;   /*!< 搜索的字符串 */
}

@property (nonatomic, strong) UITableView* tagTableView;
@property (nonatomic, strong) UITableView* jobListTableView;
@property (nonatomic, strong) UITextField* tfSearch;
@property (nonatomic, strong) UICollectionView* collectView;
@property (nonatomic, weak) UICollectionView* collectViewEpModel;
@property (nonatomic, weak) UIButton *btnClearSerach;

@end

@implementation JobSearchList_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar addSubview:self.tfSearch];
    [self.tfSearch becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.tfSearch removeFromSuperview];
    
}

- (UITextField *)tfSearch{
    if (!_tfSearch) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 28)];
        _tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH-80-16, 28)];
        _tfSearch.returnKeyType = UIReturnKeySearch;
        _tfSearch.clearButtonMode = UITextFieldViewModeNever;
        _tfSearch.delegate = self;
        _tfSearch.font = [UIFont systemFontOfSize:14];
//        _tfSearch.placeholder = @"输入雇主、岗位关键词搜索";
        _tfSearch.textColor = [UIColor whiteColor];
        _tfSearch.tintColor = [UIColor whiteColor];
        _tfSearch.leftView = view;
        _tfSearch.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *btn = [UIButton buttonWithTitle:nil bgColor:nil image:@"v320_clear_icon" target:self sector:@selector(clearSearchOnClick:)];
        btn.frame = CGRectMake(0, 0, 30, 28);
        self.btnClearSerach = btn;
        _tfSearch.rightView = btn;
        _tfSearch.rightViewMode = UITextFieldViewModeAlways;
        btn.hidden = YES;
        
        _tfSearch.backgroundColor = MKCOLOR_RGB(3, 3, 3);
        _tfSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入雇主、岗位关键词搜索" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName : MKCOLOR_RGBA(255, 255, 255, 0.32)}];
        [_tfSearch addTarget:self action:@selector(searchChanged:) forControlEvents:UIControlEventEditingChanged];
        [_tfSearch setCornerValue:14.0f];
    }
    return _tfSearch;
}

- (void)viewDidLoad {
    self.isRootVC = YES;
    [super viewDidLoad];
    
    _jobClassHeight = 54;
    _jobClassWidth = (SCREEN_WIDTH- 32 -2)/3;
    
    _queryParam = [[QueryParamModel alloc] init];
    _queryParam.page_num = @(1);
    _queryParam.page_size = @(100);
    
    NSArray* ary = [[UserData sharedInstance] getSearchHistoty];
    if (ary) {
        _historyArray = [[NSMutableArray alloc] initWithArray:ary];
    }else{
        _historyArray = [[NSMutableArray alloc] init];
    }
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.tfSearch];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(itemCancelOnClick)];
   
    self.tagTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tagTableView.backgroundColor = [UIColor whiteColor];
    self.tagTableView.delegate = self;
    self.tagTableView.dataSource = self;
    self.tagTableView.hidden = NO;
    self.tagTableView.tag = 100;
    self.tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tagTableView];
    [self.tagTableView registerNib:nib(@"JobSearchList_Cell") forCellReuseIdentifier:@"JobSearchList_Cell"];
    
    
    self.jobListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.jobListTableView.backgroundColor = [UIColor XSJColor_grayDeep];
    self.jobListTableView.delegate = self;
    self.jobListTableView.dataSource = self;
    self.jobListTableView.hidden = YES;
    self.jobListTableView.tag = 101;
    self.jobListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.jobListTableView];
    
    WEAKSELF
    [self.tagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.jobListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    if ([self.tagTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tagTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tagTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tagTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _searchDatasArray = [[NSMutableArray alloc] init];
    _entArray = [[NSMutableArray alloc] init];
    [self getJobTagData];
}

/** 获取分类 岗位 */
- (void)getJobTagData{
    WEAKSELF
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray* jobClassArray) {
        if (jobClassArray && jobClassArray.count) {
            _jobClassArray = [[NSMutableArray alloc] initWithArray:jobClassArray];
            [weakSelf.collectView reloadData];
        }
    }];
}

/** 搜索 */
- (void)searchDataWithText:(NSString*)searchText isFromHistory:(BOOL)isFromHistory{
    [_searchDatasArray removeAllObjects];
    return;
    _searchStr = searchText;
    NSString* cityId = [[UserData sharedInstance] city].id.stringValue;
    QueryJobListConditionModel *conModel = [[QueryJobListConditionModel alloc] init];
    conModel.city_id = cityId;
    conModel.job_title = searchText;
    conModel.is_include_grab_single = @"1";
    
    QueryJobListModel* queryModel = [[QueryJobListModel alloc] init];
    queryModel.query_param = _queryParam;
    queryModel.query_condition = conModel;
    
    NSString* content = [queryModel getContent];
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSArray* dataArray = [JobModel objectArrayWithKeyValuesArray:response.content[@"self_job_list"]];
            if (dataArray.count) {
                if (isFromHistory || weakSelf.tfSearch.text.length > 0) {
                    [_searchDatasArray addObjectsFromArray:dataArray];
//                    weakSelf.tagTableView.hidden = YES;
//                    weakSelf.jobListTableView.hidden = NO;
//                    [weakSelf.jobListTableView reloadData];
                }
                if(globaModel.is_need_hide_limit_job.integerValue == 1 ){
                    
                    //隐藏部分兼职
                    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
                    for (int i = 0; i < _searchDatasArray.count; i++) {
                        id model = _searchDatasArray[i];
                        if ([model isKindOfClass:[JobModel class]]) {
                            JobModel *jModel = model;
                            if (jModel.job_type.integerValue == 5) {
                                [indexs addIndex:i];
                            }
                        }
                        
                    }
                    [_searchDatasArray removeObjectsAtIndexes:indexs];
                    
                }

            }
        }
        [weakSelf searchEPWithText:searchText isFromHistory:isFromHistory];
    }];
}

/** 搜索雇主 */
- (void)searchEPWithText:(NSString*)searchText isFromHistory:(BOOL)isFromHistory{
    [_entArray removeAllObjects];
    
    QueryParamModel* qpModel = [[QueryParamModel alloc] init];
    qpModel.page_size = @(3);
    qpModel.page_num = @(1);
    
    EntNameModel* enModel = [[EntNameModel alloc] init];
    enModel.enterprise_name = searchText;
    enModel.city_id = [UserData sharedInstance].city.id;
    
    GetEnterpriseModel* gemModel = [[GetEnterpriseModel alloc] init];
    gemModel.query_condition = enModel;
    gemModel.query_param = qpModel;
    
    NSString* content = [gemModel getContent];
    WEAKSELF
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryEnterpriseList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [_entArray removeAllObjects];
            NSArray* ary = [EntInfoModel objectArrayWithKeyValuesArray:response.content[@"ent_list"]];
            _entCount = response.content[@"ent_count"];
            if (ary.count) {
                if (isFromHistory || weakSelf.tfSearch.text.length > 0) {
                    [_entArray addObjectsFromArray:ary];
                }
            }
        }
        weakSelf.tagTableView.hidden = YES;
        weakSelf.jobListTableView.hidden = NO;
        [weakSelf.jobListTableView reloadData];

    }];
}

/** 保存搜索记录 */
- (void)saveSearchText:(NSString*)text{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    for (NSString* str in _historyArray) {
        if ([str isEqualToString:text]) {
            [_historyArray removeObject:str];
            [_historyArray insertObject:text atIndex:0];
            [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
            return;
        }
    }
    [_historyArray insertObject:text atIndex:0];
    [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
}

/** 更多雇主搜索信息 */
- (void)btnShowMoreEp{
    SearchEpList_VC* vc = [[SearchEpList_VC alloc] init];
    vc.searchStr = _searchStr;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ***** UITableView delegate ******
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (tableView.tag == 101) {
        [self.tfSearch resignFirstResponder];
        [self saveSearchText:self.tfSearch.text];
        [[XSJRequestHelper sharedInstance] recordSearchKeyWord:self.tfSearch.text block:^(id result) {
            
        }];
        if (indexPath.section == 0) {
        
        }else if (indexPath.section == 1){
            if (_searchDatasArray.count <= indexPath.row) {
                return;
            }
            JobModel* model = [_searchDatasArray objectAtIndex:indexPath.row];
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = [NSString stringWithFormat:@"%@", model.job_id];
            vc.userType = WDLoginType_JianKe;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (tableView.tag == 100){
        if (indexPath.section == 1) {
            NSString *historyStr = [_historyArray objectAtIndex:indexPath.row];
            self.tfSearch.text = historyStr;
            [self searchDataWithText:[_historyArray objectAtIndex:indexPath.row] isFromHistory:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        UITableViewCell* cell;
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, _jobClassHeight*2+1)];
                cell.backgroundColor = [UIColor whiteColor];
                
                UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
                [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
                flowLayout.itemSize = CGSizeMake(_jobClassWidth, _jobClassHeight);
                flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
                flowLayout.minimumInteritemSpacing = 1;
                flowLayout.minimumLineSpacing = 1;
                
                self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.tagTableView.size.width, _jobClassHeight*3+2) collectionViewLayout:flowLayout];
                self.collectView.delegate = self;
                self.collectView.dataSource = self;
                self.collectView.bounces = NO;
                self.collectView.backgroundColor = [UIColor whiteColor];
                self.collectView.tag = 10086;
                [self.collectView registerClass:[JobClassCollectionViewCell class] forCellWithReuseIdentifier:@"jobClassCVCell"];
                
                [cell addSubview:self.collectView];
            }
        }else if (indexPath.section == 1){
           JobSearchList_Cell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"JobSearchList_Cell"];
             cell1.str = [_historyArray objectAtIndex:indexPath.row];
            return cell1;
        }else if (indexPath.section == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"clearHistoryCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clearHistoryCell"];

                UILabel* labClear = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 48)];
                labClear.tag = 200;
                labClear.textAlignment = NSTextAlignmentCenter;
                labClear.textColor = MKCOLOR_RGB(74, 144, 226);
                labClear.font = [UIFont systemFontOfSize:16];
                [cell addSubview:labClear];
            }
            UILabel* labClear = (UILabel*)[cell viewWithTag:200];
            labClear.text = @"清除搜索记录";
        }
        return cell;
    }else if (tableView.tag == 101){
        if (indexPath.section == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"epCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"epCell"];
                UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
                [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                flowLayout.itemSize = CGSizeMake(68, 84);
                flowLayout.minimumInteritemSpacing = 0;
                flowLayout.minimumLineSpacing = 0;
                UICollectionView *collectioView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
                collectioView.backgroundColor = [UIColor clearColor];
                collectioView.dataSource = self;
                collectioView.delegate = self;
                collectioView.tag = 10089;
                self.collectViewEpModel = collectioView;
                [collectioView registerNib:nib(@"JobSearchEpModel_Cell") forCellWithReuseIdentifier:@"JobSearchEpModel_Cell"];
                [cell.contentView addSubview:collectioView];
                [collectioView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView);
                }];
            }
            if (_entArray.count <= indexPath.row) {
                return cell;
            }
            return cell;
        }else if (indexPath.section == 1) {
            JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
           
            if (_searchDatasArray.count <= indexPath.row) {
                return cell;
            }
            JobModel* model = [_searchDatasArray objectAtIndex:indexPath.row];
            [cell refreshWithData:model andSearchStr:_searchStr];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return _historyArray.count ? _historyArray.count : 0;
        }
//        else if (section == 2) {
//            return _historyArray.count ? 1 : 0;
//        }
    }else if (tableView.tag == 101){
        if (section == 0) {
            return _entArray.count ? 1 : 0;
        }else if (section == 1){
            return _searchDatasArray.count ? _searchDatasArray.count : 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.section == 0) {
            return _jobClassHeight*3+2;
        }else if (indexPath.section == 1 || indexPath.section == 2){
            return 54;
        }
    }else if (tableView.tag == 101){
        if (indexPath.section == 0) {
            return 84;
        }else if (indexPath.section == 1){
            return 94;
        }
//        JobModel* model = _searchDatasArray[indexPath.row];
//        if (model.job_tags.count || (model.icon_status.integerValue == 1 && model.icon_url.length)) {
//            return 94;
//        } else {
//            return 68;
//        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return 2;
    }else if (tableView.tag == 101){
        return 2;
    }
    return 1;
}

//section head view
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 32)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
        labTitle.backgroundColor = [UIColor clearColor];
        labTitle.textColor = [UIColor XSJColor_tGray];
        labTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labTitle];
        
        if (section == 0) {
            labTitle.text = @"热门推荐";
        }else if (section == 1){
            labTitle.text = @"搜索历史";
        }
        return view;
    }else if (tableView.tag == 101){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 40)];
        view.backgroundColor = [UIColor XSJColor_grayDeep];
        if (section == 0) {
            UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
            labTitle.textColor = [UIColor XSJColor_tGray];
            labTitle.font = HHFontSys(kFontSize_2);
            labTitle.text = @"相关雇主";
            [view addSubview:labTitle];
        }else if (section == 1){
            UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 32)];
            labTitle.textColor = [UIColor XSJColor_tGray];
            labTitle.font = HHFontSys(kFontSize_2);
            labTitle.text = @"岗位";
            [view addSubview:labTitle];
        }
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (_historyArray.count && section == 1) {
            UIView *view = [[UIView alloc] init];
            UIButton *btn = [UIButton buttonWithTitle:@"清除搜索记录" bgColor:nil image:@"v320_clear_history" target:self sector:@selector(btnClearOnClick:)];
            [btn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == 0 || section == 1) {
            return 30;
        }else{
            return 1;
        }
    }else if (tableView.tag == 101){
        return 32;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 100 && _historyArray.count && section == 1) {
        return 54.0f;
    }
    return 0;
}

//处理分割线没在最左边问题：ios8以后才有的问题
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

////处理下面多余的线
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}


#pragma mark - ***** UITextField delegate ******
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchChanged:(UITextField*)textField{
    if (textField.text.length <= 0) {
        self.jobListTableView.hidden = YES;
        self.tagTableView.hidden = NO;
        self.btnClearSerach.hidden = YES;
        [self.tagTableView reloadData];
    }else{
        self.btnClearSerach.hidden = NO;
        UITextRange* selectedRange = [textField markedTextRange];
        NSString* newText = [textField textInRange:selectedRange];
        if (newText.length > 0) return;
//        [self searchDataWithText:textField.text isFromHistory:NO];
    }
}


#pragma mark - ***** UICollectionView delegate ******
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 10086) {
        static NSString* cellIdentifier = @"jobClassCVCell";
        JobClassCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            ELog(@"====???");
        }
//        cell.backgroundColor = [UIColor whiteColor];
        cell.labName.frame = CGRectMake(0, 0, cell.size.width, cell.size.height);
        
        if (indexPath.row < _jobClassArray.count) {
            JobClassifierModel* model = [_jobClassArray objectAtIndex:indexPath.row];
            cell.labName.text = model.job_classfier_name;
        }
        return cell;
    }else{
        JobSearchEpModel_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JobSearchEpModel_Cell" forIndexPath:indexPath];
        EntInfoModel* epModel = [_entArray objectAtIndex:indexPath.item];
        [cell setModel:epModel indexPath:indexPath];
        return cell;
    }

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"=collectionView====indexPath:%ld",(long)indexPath.item);
    if (collectionView.tag == 10086) {
        if (indexPath.row >= _jobClassArray.count) {
            return;
        }
        NSString *cityId = [[UserData sharedInstance] city].id.stringValue;
        
        JobClassifierModel* model = [_jobClassArray objectAtIndex:indexPath.row];
        if (model) {
            NSString* jobClassId = model.job_classfier_id.stringValue;
            JobController* vc = [[JobController alloc] init];
            vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_type_id:[%@]}", cityId, jobClassId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (indexPath.item >= 10) {
            [self btnShowMoreEp];
            return;
        }
        
        if(_entArray.count >= indexPath.row){
            EntInfoModel* eiModel = [_entArray objectAtIndex:indexPath.row];
            EpProfile_VC *vc = [[EpProfile_VC alloc] init];
            vc.isLookForJK = YES;
            vc.enterpriseId = [NSString stringWithFormat:@"%@",eiModel.enterprise_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 6;
    if (collectionView.tag == 10086) {
        return _jobClassArray.count ? _jobClassArray.count : 0;
    }else{
        return _entArray.count >= 11 ? 11: _entArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)itemCancelOnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClearOnClick:(UIButton *)sender{
    if (_historyArray) {
        [_historyArray removeAllObjects];
        [[UserData sharedInstance] saveSearchHistoryWithArray:_historyArray];
        [self.tagTableView reloadData];
    }
}

- (void)clearSearchOnClick:(UIButton *)sender{
    self.tfSearch.text = nil;
    [self searchChanged:self.tfSearch];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
