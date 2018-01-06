//
//  MenuJobViewController.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MenuJobViewController.h"
#import "MenuBarDefine.h"
#import "UIView+MKExtension.h"
#import "JobClassifierModel.h"
#import "MenuCollectionViewCell.h"
#import "UserData.h"
#import "MenuBarController.h"

@interface MenuJobViewController ()

@property (nonatomic, strong) NSMutableArray *CollectionViewCellModelArray; /*!< 岗位分类数组 */
@end

@implementation MenuJobViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.CollectionViewCellModelArray || self.CollectionViewCellModelArray.count == 0) {
     
        [self getData];
    }
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
    // 获取岗位分类
    [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobArray) {
        
        weakSelf.CollectionViewCellModelArray = [CollectionViewCellModel cellArrayWithJobArray:jobArray];
        
        // 去除其他选项
        CollectionViewCellModel *tmp = weakSelf.CollectionViewCellModelArray.lastObject;
        CollectionViewCellModel *other = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:tmp]];
        [weakSelf.CollectionViewCellModelArray removeObject:tmp];
        
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
        
        // 添加其他选项
        other.type = CollectionViewCellModelTypeParentOption;
        [weakSelf.CollectionViewCellModelArray addObject:other];
        
        // 不限
        CollectionViewCellModel *all = [[CollectionViewCellModel alloc] init];
        all.model = nil;
        all.name = @"不限";
        all.type = CollectionViewCellModelTypeDefault;
        all.selected = YES;
        [weakSelf.CollectionViewCellModelArray addObject:all];
        
        
        // 设置默认选中
        // 修改选中数组
        weakSelf.selectArray = [weakSelf.CollectionViewCellModelArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected == %d", YES]];
        
        [weakSelf.collectionView reloadData];
    }];
}

@end
