
//
//  SchoolSelectController.m
//  jianke
//
//  Created by fire on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  学校选择控制器

#import "SchoolSelectController.h"
#import "CitySearchBar.h"
#import "UserData.h"
#import "SchoolModel.h"

@interface SchoolSelectController ()

@property (nonatomic, strong) UISearchDisplayController *searchController; /*!< searchDisplayController */
@property (nonatomic, strong) NSMutableArray *searchResuleArray; /*!< 搜索结果数组 */
@property (nonatomic, strong) NSArray *schoolArray; /*!< 搜索结果数组 */

@end

@implementation SchoolSelectController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择学校";
    
    // 设置tableView
    [self initUIWithType:DisplayTypeOnlyTableView];
    
    // 添加搜索框
    CitySearchBar *searchBar = [CitySearchBar searchBar];
    searchBar.height = 60.0f;
    searchBar.placeholder = @"请输入学校名称";
    [searchBar setImage:[[UIImage imageNamed:@"v324_search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.tableView.tableHeaderView = searchBar;
    
    // 设置UISearchDisplayController
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDelegate = self;
    searchController.searchResultsDataSource = self;
    self.searchController = searchController;
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.searchController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 获取城市数据
    [self getData];
}

- (void)getData{
    if (!self.cityId) {
        return;
    }
    
    [[UserData sharedInstance] querySchoolListWithAreaId:nil cityId:self.cityId schoolName:nil  block:^(ResponseInfo *response) {
        if (response && response.success) {
            self.schoolArray = [SchoolModel objectArrayWithKeyValuesArray:response.content[@"school_list"]];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (self.schoolArray) {
            return self.schoolArray.count;
        }
    }
    
    if (tableView == self.searchController.searchResultsTableView) {
         NSArray *array = [self.schoolArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"schoolName contains[cd] %@", self.searchController.searchBar.text]];
        
        self.searchResuleArray = [NSMutableArray arrayWithArray:array];
        
        // 添加其他学校
        SchoolModel *otherSchool = [[SchoolModel alloc] init];
        otherSchool.id = @(-1);
        otherSchool.schoolName = @"其他学校";
        [self.searchResuleArray addObject:otherSchool];
        
        return self.searchResuleArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SchoolModel *school = nil;
    if (tableView == self.tableView) {
        school = self.schoolArray[indexPath.row];
    } else if (tableView == self.searchController.searchResultsTableView) {
        school = self.searchResuleArray[indexPath.row];
    }
    
    cell.textLabel.text = school.schoolName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.didSelectCompleteBlock) {
        [self back];
        return;
    }
    
    if (tableView == self.tableView) {
        
        SchoolModel *school = self.schoolArray[indexPath.row];
        self.didSelectCompleteBlock(school);
        
    } else if (tableView == self.searchController.searchResultsTableView) {
        
        SchoolModel *school = self.searchResuleArray[indexPath.row];
        self.didSelectCompleteBlock(school);
    }
    [self back];
}

- (void)back{
    [TalkingData trackEvent:@"选择城市_搜索框_取消"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
