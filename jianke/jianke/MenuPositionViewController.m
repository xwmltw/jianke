//
//  MenuPositionViewController.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客首页MenuBar位置子菜单

#import "MenuPositionViewController.h"
#import "MenuBarDefine.h"
#import "UIView+MKExtension.h"
#import "CityTool.h"
#import "MenuCollectionViewCell.h"
#import "CollectionViewCellModel.h"
#import "LocalModel.h"
#import "UserData.h"
#import <CoreLocation/CoreLocation.h>
#import "MenuBarController.h"

@interface MenuPositionViewController ()

@property (nonatomic, strong) NSMutableArray *CollectionViewCellModelArray; /*!< 当前城市的区域数组 */
@end

@implementation MenuPositionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    // 设置layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(kMenuContentBtnWidth, kMenuContentBtnHeight);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsZero;
    
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view的frame
    self.collectionView.x = 0;
    
    self.collectionView.y = -20;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        self.collectionView.y = 0;
    }
    
    self.collectionView.width = kMenuContentWidth;
    self.collectionView.height = kMenuContentHeight;
    self.collectionView.backgroundColor = MKCOLOR_RGBA(230, 230, 230, 0.6);
//    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    // 获取数据
    self.selectArray = [NSMutableArray array];
    [self getData];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.CollectionViewCellModelArray) {
        return self.CollectionViewCellModelArray.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.CollectionViewCellModel = self.CollectionViewCellModelArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCellModel *model = self.CollectionViewCellModelArray[indexPath.item];
    
    if (model.type == CollectionViewCellModelTypeSubOption || model.type == CollectionViewCellModelTypeNone) {
        return CGSizeMake(kMenuContentBtnWidth, kMenuContentBtnHeight);
    }
    
    return CGSizeMake(kMenuContentWidth, kMenuContentBtnHeight);    
}



#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"第%ld个按钮被点击", (long)indexPath.item);
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    // 修改模型,显示为选中
    CollectionViewCellModel *model = self.CollectionViewCellModelArray[indexPath.item];
    
    if (model.type == CollectionViewCellModelTypeNone) { // 空白按钮
        return;
    }
    
    model.selected = !model.selected;
    
    // 清除其余选中
    WEAKSELF
    switch (model.type) {
        case CollectionViewCellModelTypeSubOption:
        {
            // 清除全福州,附近选中状态
            [self.CollectionViewCellModelArray enumerateObjectsUsingBlock:^(CollectionViewCellModel *obj, NSUInteger idx, BOOL *stop) {
               
                if (obj.type != CollectionViewCellModelTypeSubOption) {
                    obj.selected = NO;
                }
            }];
        }
            break;
            
        case CollectionViewCellModelTypeParentOption:
        {
            // 清除 子区域,附近 选中状态
            [self.CollectionViewCellModelArray enumerateObjectsUsingBlock:^(CollectionViewCellModel *obj, NSUInteger idx, BOOL *stop) {
                
                if (obj.type != CollectionViewCellModelTypeParentOption) {
                    obj.selected = NO;
                }
            }];
        }
            break;
            
        case CollectionViewCellModelTypeDefault:
        {
            // 清除 子区域,全福州 选中状态
            [self.CollectionViewCellModelArray enumerateObjectsUsingBlock:^(CollectionViewCellModel *obj, NSUInteger idx, BOOL *stop) {
                
                if (obj.type != CollectionViewCellModelTypeDefault) {
                    obj.selected = NO;
                }
            }];            
        }
            break;
            
            default:
            break;
    }
    
    // 修改选中数组
    weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
    
    // 隐藏菜单
    [self.menuBarVC coverBtnClick];
    
    // 刷新
    [self.collectionView reloadData];
    
    
}


#pragma mark - 其他方法
- (void)getData
{
    WEAKSELF
    CityModel *city = [[UserData sharedInstance] city];
    [CityTool getAreasWithCityId:city.id block:^(NSArray *areaArray) {
       
        // 子区域
        weakSelf.CollectionViewCellModelArray = [CollectionViewCellModel cellArrayWithAreaArray:areaArray];
        
        // 添加空白模型
        NSUInteger addBtnCount = 0;
        if (weakSelf.CollectionViewCellModelArray.count % 3 == 2) { // 添加1个
            
            addBtnCount = 1;
        }
        
        if (weakSelf.CollectionViewCellModelArray.count % 3 == 1) { // 添加2个
            
            addBtnCount = 2;
        }
        
        for (NSUInteger i = 0; i < addBtnCount; i ++) {
            
            CollectionViewCellModel *empty = [[CollectionViewCellModel alloc] init];
            empty.selected = NO;
            empty.name = nil;
            empty.type = CollectionViewCellModelTypeNone;
            [weakSelf.CollectionViewCellModelArray addObject:empty];
        }

        // 全福州 && 附近
        CityModel *savedCuttentCity = [[UserData sharedInstance] city];
        LocalModel *savedlocal = [[UserData sharedInstance] local];
        if (savedCuttentCity) { // 有保存城市
            
            CollectionViewCellModel *parentArea = [[CollectionViewCellModel alloc] init];
            parentArea.model = savedCuttentCity;
            parentArea.name = [NSString stringWithFormat:@"全%@", savedCuttentCity.name];
            parentArea.type = CollectionViewCellModelTypeParentOption;
            parentArea.selected = YES;
            [weakSelf.CollectionViewCellModelArray addObject:parentArea];
            
            // 附近
            CollectionViewCellModel *nearby = [[CollectionViewCellModel alloc] init];
            nearby.type = CollectionViewCellModelTypeDefault;
            nearby.selected = NO;
            nearby.name = @"定位失败";
            [weakSelf.CollectionViewCellModelArray addObject:nearby];
            
            if (savedlocal) {
                nearby.model = savedlocal;
                nearby.name = @"离我最近";
                
                // 设置默认选中
                // 修改选中数组
                weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
                
                [weakSelf.collectionView reloadData];
                
            } else if([CLLocationManager locationServicesEnabled]) {
           
                [CityTool getLocalWithBlock:^(LocalModel *local) {
                    
                    if (local) {
                        nearby.model = local;
                        nearby.name = @"离我最近";
                    }
                    
                    // 设置默认选中
                    // 修改选中数组
                    weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
                    
                    [weakSelf.collectionView reloadData];
                }];
                
            } else {
                
                // 设置默认选中
                // 修改选中数组
                weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
                
                [weakSelf.collectionView reloadData];
            }
            
        } else { // 没保存城市, 也没定位信息
            
            [CityTool getCurrentCityWithBlock:^(CityModel *currentCity) {
                
                CollectionViewCellModel *parentArea = [[CollectionViewCellModel alloc] init];
                parentArea.model = currentCity;
                parentArea.name = [NSString stringWithFormat:@"全%@", currentCity.name];
                parentArea.type = CollectionViewCellModelTypeParentOption;
                parentArea.selected = YES;
                [weakSelf.CollectionViewCellModelArray addObject:parentArea];
                
                // 附近
                [CityTool getLocalWithBlock:^(LocalModel *local) {
                    
                    CollectionViewCellModel *nearby = [[CollectionViewCellModel alloc] init];
                    nearby.type = CollectionViewCellModelTypeDefault;
                    nearby.selected = NO;
                    nearby.name = @"定位失败";
                    
                    if (local) {
                        nearby.model = local;
                        nearby.name = @"离我最近";
                    }
                    
                    [weakSelf.CollectionViewCellModelArray addObject:nearby];
                    
                    // 设置默认选中
                    // 修改选中数组
                    weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
                    
                    [weakSelf.collectionView reloadData];
                }];
            }];
        }
    }];
}

@end
