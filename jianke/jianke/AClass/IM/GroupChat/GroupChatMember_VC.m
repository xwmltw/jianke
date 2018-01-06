//
//  GroupChatMember_VC.m
//  jianke
//
//  Created by xiaomk on 16/1/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "GroupChatMember_VC.h"
#import "GCMCollectionViewCell.h"
#import "WDConst.h"
#import "IMGroupModel.h"
#import "IMGroupDetailModel.h"
#import "ImDataManager.h"
#import "LookupResume_VC.h"
#import "DataBaseTool.h"
#import "IMHome_VC.h"
#import "EpProfile_VC.h"

#define GCMCView_widthEdge 14
#define GCMCView_topEdge 16
#define GCMCView_bottomEdge 18

@interface GroupChatMember_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSMutableArray* _datasArray;
    IMGroupDetailModel* _gdModel;
    BOOL _isEditing;
    BOOL _isManage;
}

@property (nonatomic, strong) UICollectionView* collectView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIButton* btnQuit;
@property (nonatomic, strong) UIButton* btnEdit;
@end

@implementation GroupChatMember_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _isEditing = NO;
    _isManage = NO;
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4-GCMCView_widthEdge*2+GCMCView_topEdge+GCMCView_bottomEdge);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    [self.collectView registerClass:[GCMCollectionViewCell class] forCellWithReuseIdentifier:@"gcmCell"];
    self.collectView.contentInset = UIEdgeInsetsMake(0, 0, 12, 0);
    self.collectView.bounces = YES;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor XSJColor_grayDeep];
    [self.view addSubview:self.bottomView];
    
    UIButton* btnQuit = [[UIButton alloc] init];
    [btnQuit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQuit setTitle:@"退出群聊" forState:UIControlStateNormal];
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnQuit setBackgroundImage:[UIImage imageNamed:@"v231_register"] forState:UIControlStateNormal];
//    [btnQuit setBackgroundImage:[UIImage imageNamed:@"v231_registerdown"] forState:UIControlStateHighlighted];
    [btnQuit addTarget:self action:@selector(btnQuitOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btnQuit];
    self.btnQuit = btnQuit;
    
    
    WEAKSELF
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
    
    [btnQuit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).offset(12);
        make.right.equalTo(_bottomView.mas_right).offset(-12);
        make.top.equalTo(_bottomView.mas_top).offset(8);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-8);
    }];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [self getGroupMembersInfo];
}



- (void)getGroupMembersInfo{
    WEAKSELF
    [[UserData sharedInstance] imGetGroupInfoWithGroupId:self.groupId block:^(IMGroupDetailModel* obj) {
        if (obj) {
            _gdModel = obj;
            _datasArray = [[NSMutableArray alloc] initWithArray:_gdModel.groupMembers];
            NSInteger membersNum;
            membersNum = _datasArray.count ? _datasArray.count : 0;
            weakSelf.title = [NSString stringWithFormat:@"群成员 (%lu)",(long)membersNum];
            [_collectView reloadData];
            
            if ([[UserData sharedInstance] getUserId].integerValue == _gdModel.groupOwnerEnt.integerValue || [[UserData sharedInstance] getUserId].integerValue == _gdModel.groupOwnerBd.integerValue) {
                _isManage = YES;
            }
            if (_isManage) {
                UIButton* btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                [btnEdit setImage:[UIImage imageNamed:@"card_icon_edit"] forState:UIControlStateNormal];
                [btnEdit addTarget:weakSelf action:@selector(btnEditOnclick:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
                weakSelf.navigationItem.rightBarButtonItem = rightItem;
                weakSelf.btnEdit = btnEdit;
                [weakSelf.btnQuit setTitle:@"解散群组" forState:UIControlStateNormal];
            }

        }
    }];
}

//退出 解散    群聊按钮
- (void)btnQuitOnclick:(UIButton*)sender{
    WEAKSELF
    if (_isManage) {    //解散群组
        [UIHelper showConfirmMsg:@"确定解散此群组?" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self dismissGroup];
            }
        }];
    }else{
        [[UserData sharedInstance] imQuitGroupWithGroupId:self.groupId block:^(ResponseInfo* response) {
            if (response) {
                [DataBaseTool hideConversationWithGroupConversationId:weakSelf.groupLocalConversationIdSign];
                [UIHelper toast:@"退出群组成功"];
                for (UIViewController* controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[IMHome_VC class]]) {
                        [weakSelf.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
        }];
    }
}

- (void)dismissGroup{
    RemoveGroupModel* rgModel = [[RemoveGroupModel alloc] init];
    rgModel.groupId = self.groupId;
    NSString* content = [rgModel getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_im_dismissgroup" andContent:content];
    request.isShowLoading = NO;
    WEAKSELF
    [request sendRequestToImServer:^(ResponseInfo *response) {
        if (response.success) {
            [UserData delayTask:0.3 onTimeEnd:^{
                [DataBaseTool hideConversationWithGroupConversationId:weakSelf.groupLocalConversationIdSign];
                [UIHelper toast:@"解散群组成功"];
                for (UIViewController* controller in weakSelf.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[IMHome_VC class]]) {
                        [weakSelf.navigationController popToViewController:controller animated:YES];
                    }
                }
            }];
        }
    }];
}


//点击编辑按钮
- (void)btnEditOnclick:(UIButton*)sender{
    _isEditing = !_isEditing;
    if (_isEditing) {
        [self.btnEdit setImage:[UIImage imageNamed:@"v260_icon_finished"] forState:UIControlStateNormal];
    }else{
        [self.btnEdit setImage:[UIImage imageNamed:@"card_icon_edit"] forState:UIControlStateNormal];
    }
    [self.collectView reloadData];
}

//删除群成员
- (void)removeFromGroupWithIndex:(NSInteger)index{
    
    IMGroupMemberModel* rmModel = [_datasArray objectAtIndex:index];

    RemoveGroupModel* qModel = [[RemoveGroupModel alloc] init];
    qModel.accountId = rmModel.accountId.stringValue;
    qModel.groupId = self.groupId;
    NSString* content = [qModel getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_im_removeGroup" andContent:content];
    request.isShowLoading = NO;
    WEAKSELF
    [request sendRequestToImServer:^(ResponseInfo *response) {
        if (response.success) {
            [_datasArray removeObjectAtIndex:index];
            [weakSelf.collectView reloadData];
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:[NSString stringWithFormat:@"你已将“%@”踢出该群", rmModel.trueName]];
            }];
        }
    }];
}

#pragma mark - UICollectionView delegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"gcmCell";
    GCMCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        ELog(@"====error");
    }
    cell.labName.frame = CGRectMake(0, GCMCView_topEdge + cell.bounds.size.width-GCMCView_widthEdge*2, cell.bounds.size.width,GCMCView_bottomEdge );

    cell.btnHead.frame = CGRectMake(GCMCView_widthEdge, GCMCView_topEdge, cell.bounds.size.width-GCMCView_widthEdge*2, cell.bounds.size.width-GCMCView_widthEdge*2);
    [UIHelper setCorner:cell.btnHead];
    [cell.btnHead addTarget:self action:@selector(btnHeadOnclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnHead.tag = indexPath.row;
    
    cell.imgDelete.frame = CGRectMake(GCMCView_widthEdge-(18/2), GCMCView_topEdge-(18/2), 18, 18);
    cell.imgDelete.hidden = !_isEditing;

    IMGroupMemberModel* model = [_datasArray objectAtIndex:indexPath.row];
    [cell.btnHead sd_setBackgroundImageWithURL:[NSURL URLWithString:model.profileUrl] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultHeadRect]];
    
    if (model.accountId.integerValue == _gdModel.groupOwnerEnt.integerValue) {
        cell.labName.text = [NSString stringWithFormat:@"雇主-%@", model.trueName];
        cell.imgDelete.hidden = YES;
    }else if (model.accountId.integerValue == _gdModel.groupOwnerBd.integerValue){
        cell.labName.text = [NSString stringWithFormat:@"CD-%@", model.trueName];
        cell.imgDelete.hidden = YES;
    }else{
        cell.labName.text = model.trueName;
    }
    
    return cell;
}

//点击 头像事件
- (void)btnHeadOnclick:(UIButton*)sender{
    ELog(@"=====indexPath:%ld",(long)sender.tag);
    [self headClickOnIndex:sender.tag];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"=collectionView====indexPath:%ld",(long)indexPath.row);
    [self headClickOnIndex:indexPath.row];
}

- (void)headClickOnIndex:(NSInteger)index{
    IMGroupMemberModel* gmbModel = [_datasArray objectAtIndex:index];
    
    if (_isEditing && _isManage) {
        if (gmbModel.accountId.integerValue == _gdModel.groupOwnerEnt.integerValue || gmbModel.accountId.integerValue == _gdModel.groupOwnerBd.integerValue) {
            ELog(@"===点击  EP、BD信息");
            return;
        }
        [UIHelper showConfirmMsg:[NSString stringWithFormat:@"确定将“%@”移出该群吗?",gmbModel.trueName]  completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self removeFromGroupWithIndex:index];
            }
        }];
    }else{
        if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
            if (gmbModel.accountId.integerValue == _gdModel.groupOwnerEnt.integerValue || gmbModel.accountId.integerValue == _gdModel.groupOwnerBd.integerValue) {
                ELog(@"====产看EP、BD信息");
                EpProfile_VC *vc = [[EpProfile_VC alloc] init];
                vc.isLookForJK = YES;
                vc.isFromGroupMembers = YES;
                vc.accountId = gmbModel.accountId.stringValue;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                //            [UIHelper toast:@"兼客无法查看兼客个人信息"];
            }
            
        }else if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer){
            if (gmbModel.accountId.integerValue == _gdModel.groupOwnerEnt.integerValue || gmbModel.accountId.integerValue == _gdModel.groupOwnerBd.integerValue) {
                //            [UIHelper toast:@"雇主不能查看雇主信息"];
            }else{
                ELog(@"====产看JK信息");
                LookupResume_VC *vc = [[LookupResume_VC alloc] init];
                vc.isLookOther = YES;
                vc.isFromGroupMembers = YES;
                vc.accountId = gmbModel.accountId.stringValue;
                vc.removeBlock = ^(BOOL removeBlock){
                    if (removeBlock) {
                        [self removeFromGroupWithIndex:index];
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datasArray ? _datasArray.count : 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
