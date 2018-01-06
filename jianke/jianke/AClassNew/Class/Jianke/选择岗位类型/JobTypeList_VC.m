//
//  JobTypeList_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobTypeList_VC.h"
#import "JobClassifyInfoModel.h"
#import "WDConst.h"
#import "JobTypeListCell.h"

@interface JobTypeList_VC (){
    NSMutableArray* _commonArray;   /*!< 普通岗位列表 */
    NSMutableArray* _bdArray;       /*!< 包招岗位列表 */
}
@end

@implementation JobTypeList_VC

static NSInteger _tagBaseBd = 1000;
static NSInteger _tagBaseCommon = 2000;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择岗位类型";

    [self setUISingleTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _commonArray = [[NSMutableArray alloc] init];
    _bdArray = [[NSMutableArray alloc] init];
    
    if (self.classifierArray.count > 0) {
        for (JobClassifyInfoModel* model in self.classifierArray) {
            if (self.postJobType == PostJobType_common || self.postJobType == PostJobType_fast) {
                [_commonArray addObject:model];
            }else if (self.postJobType == PostJobType_bd){
                if (model.enable_recruitment_service.intValue == 1) {
                    [_bdArray addObject:model];
                }else{
                    [_commonArray addObject:model];
                }
            }
        }
    }else{
        [self getNormalClassifyList];
    }
    
    [self.tableView reloadData];
}


- (void)setDatasource{
    for (JobClassifyInfoModel* model in self.classifierArray) {
        if (self.postJobType == PostJobType_common || self.postJobType == PostJobType_fast) {
            [_commonArray addObject:model];
        }else if (self.postJobType == PostJobType_bd){
            if (model.enable_recruitment_service.intValue == 1) {
                [_bdArray addObject:model];
            }else{
                [_commonArray addObject:model];
            }
        }else{
            [_commonArray addObject:model];
        }
    }
}

/** 点击标签事件 */
- (void)btnClick:(UIButton*)sender{

    
    NSInteger tag = sender.tag;
    JobClassifyInfoModel* model;
    if (tag >= _tagBaseCommon) {
        model = [_commonArray objectAtIndex:tag%_tagBaseCommon];
    }else if (tag >= _tagBaseBd){
        model = [_bdArray objectAtIndex:tag%_tagBaseBd];
    }
    if (self.block) {
        self.block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"JobTypeListCell";
    JobTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [JobTypeListCell new];
    }
    cell.btn1.hidden = YES;
    cell.btn2.hidden = YES;
    cell.btn3.hidden = YES;
    cell.btn4.hidden = YES;
    [cell.btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    NSArray* tempArray;
    NSInteger tagBase = 0;
    if (indexPath.section == 0) {
        tempArray = [NSArray arrayWithArray:_bdArray];
        tagBase = _tagBaseBd;
    }else if (indexPath.section == 1){
        tagBase = _tagBaseCommon;
        tempArray = [NSArray arrayWithArray:_commonArray];
    }

    NSInteger startNum = indexPath.row * 4;
    NSInteger endNum = startNum + 4 >= tempArray.count ? tempArray.count : startNum + 4;
    for (NSInteger i = startNum; i < endNum; i++ ) {
        NSInteger count = i%4;
        JobClassifyInfoModel* model = [tempArray objectAtIndex:i];
        if (count == 0) {
            cell.btn1.hidden = NO;
            [cell.btn1 setTitle:model.job_classfier_name forState:UIControlStateNormal];
            cell.btn1.tag = tagBase + i;
        }else if (count == 1){
            cell.btn2.hidden = NO;
            [cell.btn2 setTitle:model.job_classfier_name forState:UIControlStateNormal];
            cell.btn2.tag = tagBase + i;
        }else if (count == 2){
            cell.btn3.hidden = NO;
            [cell.btn3 setTitle:model.job_classfier_name forState:UIControlStateNormal];
            cell.btn3.tag = tagBase + i;
        }else if (count == 3){
            cell.btn4.hidden = NO;
            [cell.btn4 setTitle:model.job_classfier_name forState:UIControlStateNormal];
            cell.btn4.tag = tagBase + i;
        }
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && (self.postJobType == PostJobType_common || self.postJobType == PostJobType_fast)) {
        return 0;
    }
    
    if (section == 0 && _bdArray.count) {
        NSInteger num;
        NSInteger left = _bdArray.count%4;
        if (left == 0) {
            num = _bdArray.count / 4;
        }else{
            num = _bdArray.count / 4 + 1;
        }
        return num;

    }else if (section == 1 && _commonArray.count){
        NSInteger num;
        NSInteger left = _commonArray.count%4;
        if (left == 0) {
            num = _commonArray.count / 4;
        }else{
            num = _commonArray.count / 4 + 1;
        }
        return num;
    }
    return 0;
}



//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0 && (self.postJobType == PostJobType_common || self.postJobType == PostJobType_fast)) {
//        return nil;
//    }
//    
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 32)];
//    view.backgroundColor = [UIColor XSJColor_grayTinge];
//    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, tableView.size.width-32, 32)];
//    labTitle.backgroundColor = [UIColor clearColor];
//    labTitle.textColor = [UIColor XSJColor_tGray];
//    labTitle.font = [UIFont systemFontOfSize:14];
//    [view addSubview:labTitle];
//
//    if (section == 0) {
//        labTitle.text = @"包招岗位暂时只支持以下岗位类型";
//    }else if (section == 1){
//        labTitle.text = @"以普通岗位发布";
//    }
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0 && (self.postJobType == PostJobType_common || self.postJobType == PostJobType_fast)) {
//        return 0;
//    }else{
//        return 32;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


//
//- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIdentifier = @"jobTypeCVCell";
//    JobTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    [cell sizeToFit];
//    cell.backgroundColor = [UIColor whiteColor];
//    cell
//}
//

- (void)getNormalClassifyList{
    // 获取普通招聘岗位列表
    CityModel *city = [UserData sharedInstance].city;
    WEAKSELF
    NSString* content = [NSString stringWithFormat:@"\"city_id\":\"%@\"", city.id];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobClassifyInfoList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            _classifierArray = [JobClassifyInfoModel objectArrayWithKeyValuesArray:response.content[@"job_classifier_list"]];
            if (_classifierArray.count) {
                [weakSelf setDatasource];
                [weakSelf.tableView reloadData];
            }
        }else{
            [UIHelper toast:@"获取岗位分类列表失败"];
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
