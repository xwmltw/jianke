//
//  CitySelectController.m
//  jianke
//
//  Created by fire on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  城市选择控制器

#import "CitySelectController.h"
#import "WDConst.h"
#import "CitySearchBar.h"
#import "CityModel.h"
#import "CityTool.h"
#import "CitySelectCell.h"
#import "EPActionSheetItem.h"

@interface CitySelectController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSString *currentCityName; /*!< 定位的城市名 */
@property (nonatomic, strong) CityModel *currentCity; /*!< 当前定位城市 */
@property (nonatomic, strong) NSArray *hotCity; /*!< 热门城市 */
@property (nonatomic, strong) NSArray *allCity; /*!< 所有城市 */
@property (nonatomic, strong) NSArray *allSortCity; /*!< 所有排序好的城市 */
@property (nonatomic, strong) NSArray *cityFirstLetterArray; /*!< 城市首字母数组 */
@property (nonatomic, strong) UISearchDisplayController *searchController; /*!< searchDisplayController */
@property (nonatomic, strong) NSArray *searchResuleArray; /*!< 搜索结果数组 */

@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [TalkingData trackEvent:@"选择城市页面"];
    // 设置tableView
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    // 添加搜索框
    CitySearchBar *searchBar = [CitySearchBar searchBar];
    [searchBar setImage:[UIImage imageNamed:@"v3_city_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.tableView.tableHeaderView = searchBar;
    
    // 设置UISearchDisplayController
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDelegate = self;
    searchController.searchResultsDataSource = self;
    self.searchController = searchController;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CitySelectCell" bundle:nil] forCellReuseIdentifier:@"CitySelectCell"];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"CitySelectCell" bundle:nil] forCellReuseIdentifier:@"CitySelectCell"];
    
    // 获取城市数据
    [self getData];
}

- (void)backToLastView{
    
    if ([self.currentCityName isEqualToString:@"定位失败"]) {
        [UIHelper showMsg:@"请选择工作城市"];
        return;
    }
    
    
    if (!self.isFromNewFeature) {
        if (![[UserData sharedInstance] city]) {
            if (!self.hotCity.count) {
                [UIHelper toast:@"城市数据正在加载中，请稍后！"];
                return;
            }
            CityModel *city = self.hotCity[0];
            if (self.didSelectCompleteBlock) {
                self.didSelectCompleteBlock(city);
            }
        }
    }
    
    if (self.isPushAction) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        if (self.allSortCity) {
            return self.allSortCity.count + 2;
        }
    }
    return 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        switch (section) {
            case 0: // 定位城市
                return 1;
            case 1: // 热门城市
                return self.hotCity.count;
            default: // 所有城市
                return [self.allSortCity[section - 2] count];
        }
    } else {
        self.searchResuleArray = [self.allCity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"spelling contains[cd] %@  or name contains[cd] %@", self.searchController.searchBar.text, self.searchController.searchBar.text]];
        return self.searchResuleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CitySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitySelectCell"];
    
    if (tableView == self.tableView) { // 当前tableView
        switch (indexPath.section) {
            case 0: // 定位城市
            {
                [cell.cityFirstLetter setImage:[UIImage imageNamed:@"v3_city_location"] forState:UIControlStateNormal];
                [cell.cityFirstLetter setTitle:nil forState:UIControlStateNormal];
                if (self.currentCityName) {
                    cell.cityName.text = self.currentCityName;
                } else {
                    cell.cityName.text = @"定位中...";
                }
            }
                break;
                
            case 1: // 热门城市
            {
                if (indexPath.row == 0) { // 显示五角星
                    [cell.cityFirstLetter setImage:[UIImage imageNamed:@"v3_city_search_star"] forState:UIControlStateNormal];
                } else {
                    [cell.cityFirstLetter setImage:nil forState:UIControlStateNormal];
                }
                [cell.cityFirstLetter setTitle:nil forState:UIControlStateNormal];
                cell.cityName.text = [self.hotCity[indexPath.row] name];
            }
                break;
                
            default: // 所有城市
            {
                
                if (indexPath.row == 0) { // 显示字母
                    [cell.cityFirstLetter setTitle:self.cityFirstLetterArray[indexPath.section - 2] forState:UIControlStateNormal];
                } else {
                    [cell.cityFirstLetter setTitle:nil forState:UIControlStateNormal];
                }
                [cell.cityFirstLetter setImage:nil forState:UIControlStateNormal];
                cell.cityName.text = [self.allSortCity[indexPath.section - 2][indexPath.row] name];
                
            }
                break;
        }

    } else { // 搜索结果显示的tableView
        
        [cell.cityFirstLetter setImage:nil forState:UIControlStateNormal];
        [cell.cityFirstLetter setTitle:nil forState:UIControlStateNormal];
        cell.cityName.text = [self.searchResuleArray[indexPath.row] name];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@"@"];
        [array addObject:@"#"];
        [array addObjectsFromArray:self.cityFirstLetterArray];
        return array;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.didSelectCompleteBlock) { // 没设置回调, 直接返回
        [self backToLastView];
        return;
    }
    
    if (!self.isShowSubArea) { // 不显示子区域
        
        if (tableView == self.tableView) { // 默认tableView
            switch (indexPath.section) {
                case 0: // 定位城市
                {
                    [TalkingData trackEvent:@"选择城市_定位城市"];

                    if (self.currentCity) {
                        self.didSelectCompleteBlock(self.currentCity);
                    }else{
                        return;
                    }
                    
                }
                    break;
                    
                case 1: // 热门城市
                {
                    [TalkingData trackEvent:@"选择城市_热门城市" label:[[NSString alloc]initWithFormat:@"%@",self.hotCity[indexPath.row]]];
                    CityModel *city = self.hotCity[indexPath.row];
                    self.didSelectCompleteBlock(city);
                }
                    break;
                    
                default: // 其他城市
                {
                    [TalkingData trackEvent:@"选择城市_其它城市" label:[[NSString alloc]initWithFormat:@"%@",self.allSortCity[indexPath.row]]];
                    CityModel *city = self.allSortCity[indexPath.section - 2][indexPath.row];
                    self.didSelectCompleteBlock(city);
                }
                    break;
            }
        } else { // 搜索的tableView
            CityModel *city = self.searchResuleArray[indexPath.row];
            self.didSelectCompleteBlock(city);
        }
        
    } else { // 需要显示子区域
        
        CityModel *city = nil;
        if (tableView == self.tableView) { // 默认tableView
            switch (indexPath.section) {
                case 0: // 定位城市
                {
                    city = self.currentCity;
                }
                    break;
                    
                case 1: // 热门城市
                {
                    city = self.hotCity[indexPath.row];
                }
                    break;
                    
                default: // 其他城市
                {
                    city = self.allSortCity[indexPath.section - 2][indexPath.row];
                }
                    break;
            }
        } else { // 搜索的tableView
            city = self.searchResuleArray[indexPath.row];
        }

        [CityTool getAreasWithCityId:city.id block:^(NSArray *areas) {
            
            NSMutableArray *items = [NSMutableArray array];
                
            // 添加不限
            if (self.isShowParentArea) {
                city.parent_id = city.id;
                city.parent_name = city.name;
                EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:city.name arg:city];
                [items addObject:item];
            }else if (self.showCityWide){
                EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:@"全市" arg:city];
                [items addObject:item];
            }
                
            // 添加子区域
            for (CityModel *area in areas) {
                EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:area.name arg:area];
                [items addObject:item];
            }
            
            // 判断有没有子区域
            if (items.count < 1) { // 没有子区域 直接显示城市
                
                if (tableView == self.tableView) { // 默认tableView
                    switch (indexPath.section) {
                        case 0: // 定位城市
                        {
                            self.didSelectCompleteBlock(self.currentCity);
                        }
                            break;
                            
                        case 1: // 热门城市
                        {
                            CityModel *city = self.hotCity[indexPath.row];
                            self.didSelectCompleteBlock(city);
                        }
                            break;
                            
                        default: // 其他城市
                        {
                            CityModel *city = self.allSortCity[indexPath.section - 2][indexPath.row];
                            self.didSelectCompleteBlock(city);
                        }
                            break;
                    }
                } else { // 搜索的tableView
                    
                    CityModel *city = self.searchResuleArray[indexPath.row];
                    self.didSelectCompleteBlock(city);
                }
            
            } else { // 有子区域
                
                MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"请选择区域" objArray:items titleKey:@"title"];
                sheet.maxShowButtonCount = 5.6;
                [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                    EPActionSheetItem *item = [items objectAtIndex:buttonIndex];
                    CityModel *area = item.arg;
                    if (self.didSelectCompleteBlock) {
                        self.didSelectCompleteBlock(area);
                    }
                }];
            }
        }];
    }
    
    self.currentCityName = nil;
    
    [self backToLastView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackEvent:@"选择城市_返回"];
}

#pragma mark - 服务器交互
/** 获取城市数据 */
- (void)getData{
    WEAKSELF
    // 所有城市
    [CityTool getAllCityWithBlock:^(NSArray *allCity) {
        weakSelf.allCity = allCity;
        // 城市首字母
        [CityTool getCityFirstLetterArrayWithBlock:^(NSArray *cityFirstLetterArray) {
            weakSelf.cityFirstLetterArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cityFirstLetterArray]];
        }];
        
        // 排序好的城市数组
        [CityTool getAllSortCityWithBlock:^(NSArray *allSortCity) {
            weakSelf.allSortCity = allSortCity;
            [weakSelf.tableView reloadData];
        }];
        
        // 热门城市
        [CityTool getHotCityWithBlock:^(NSArray *hotCity) {
            weakSelf.hotCity = hotCity;
            [weakSelf.tableView reloadData];
        }];
        
        // 当前定位的城市
        [CityTool getCurrentCityWithBlock:^(CityModel *currentCity) {
            weakSelf.currentCityName = (currentCity != nil) ? currentCity.name : @"定位失败";
            weakSelf.currentCity = currentCity;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
            [weakSelf.tableView reloadSections:set withRowAnimation:YES];
        }];
    }];
    
}

@end
