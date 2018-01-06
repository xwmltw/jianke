//
//  EditQuickReply_VC.m
//  jianke
//
//  Created by xiaomk on 15/12/30.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "EditQuickReply_VC.h"
#import "WDConst.h"
#import "EditQuickReplyCell.h"
#import "TVAlertView.h"

@interface EditQuickReply_VC ()<UITableViewDataSource, UITableViewDelegate,EditQuickReplyDelegate>{
    NSMutableArray* _jkMsgArray;
    NSMutableArray* _epMsgArray;
    NSMutableArray* _datasArray;
    EQRMsgModel* _eqrMsgModel;
    
    
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* btnAddMsg;
@property (nonatomic, assign) WDLogin_type loginType;
@end

@implementation EditQuickReply_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.editing = YES;

    [self.view addSubview:self.tableView];

    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self initWithNoDataViewWithStr:@"你还没有常用语哦！" onView:self.tableView];
 
    _btnAddMsg = [[UIButton alloc] initWithFrame:CGRectZero];
    [_btnAddMsg setImage:[UIImage imageNamed:@"v240_new_0"] forState:UIControlStateNormal];
    [_btnAddMsg setImage:[UIImage imageNamed:@"v240_new_1"] forState:UIControlStateHighlighted];
    [_btnAddMsg setSize:CGSizeMake(44, 44)];
    [_btnAddMsg addTarget:self action:@selector(btnAddMsgOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAddMsg];
    [UIHelper setToCircle:_btnAddMsg];
    _btnAddMsg.hidden = YES;
    
    [_btnAddMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-16);
        make.bottom.equalTo(weakSelf.view).offset(-16);
    }];
    
    self.loginType = [[UserData sharedInstance] getLoginType].integerValue;
    
    [self getEqrData];
}

//初始化数据
- (void)getEqrData{
    _eqrMsgModel = nil;
    _jkMsgArray = nil;
    _epMsgArray = nil;
    _datasArray = nil;
    WEAKSELF
    [[UserData sharedInstance] getEqrMsgModelWithBlock:^(EQRMsgModel* eqrModel) {
        _eqrMsgModel = eqrModel;
        if (!_eqrMsgModel) {
            _eqrMsgModel = [[EQRMsgModel alloc] init];
        }
        _jkMsgArray = [[NSMutableArray alloc] initWithArray:_eqrMsgModel.student_quick_reply];
        _epMsgArray = [[NSMutableArray alloc] initWithArray:_eqrMsgModel.ent_quick_reply];
        
        if (weakSelf.loginType == WDLoginType_JianKe) {
            _datasArray = [[NSMutableArray alloc] initWithArray:_jkMsgArray];
        }else if (weakSelf.loginType == WDLoginType_Employer){
            _datasArray = [[NSMutableArray alloc] initWithArray:_epMsgArray];
        }
        
        [weakSelf reloadTableView];
    }];
}

- (void)reloadTableView{
    [self.tableView reloadData];

    [self isShowAddBtn];
}

- (void)isShowAddBtn{
    if (_datasArray.count > 0) {
        self.viewWithNoData.hidden = YES;
    }else{
        self.viewWithNoData.hidden = NO;
    }
    
    _btnAddMsg.hidden = _datasArray.count > 11;
}
#pragma mark - 按钮事件
- (void)btnAddMsgOnclick:(UIButton*)sender{
    WEAKSELF
    [[TVAlertView sharedInstance] showWithTitle:@"添加常用语" placeholder:@"长度显示120字" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex, NSString *content) {
        if (buttonIndex == 1) {
            if (content.length > 0) {
                [_datasArray addObject:content];
                [weakSelf sendUpdateRequestWithType:EQRUpdateType_Add];

            }
        }
    }];
}


- (void)sendUpdateRequestWithType:(EQRUpdateType)type{
    NSString* successStr;
    NSString* failStr;
    BOOL isShowLoding;
    switch (type) {
        case EQRUpdateType_Add:
            isShowLoding = YES;
            successStr = @"添加成功";
            failStr = @"添加失败,检查是否包含非法字符";
            break;
        case EQRUpdateType_Del:
            isShowLoding = YES;
            successStr = @"删除成功";
            failStr = @"删除失败，稍后再试";
            break;
        case EQRUpdateType_Update:
            isShowLoding = YES;
            successStr = @"修改成功";
            failStr = @"修改失败，稍后再试";
            break;
        case EQRUpdateType_Move:
            isShowLoding = NO;
            break;
        default:
            break;
    }
    
    if (self.loginType == WDLoginType_JianKe) {
        _eqrMsgModel.student_quick_reply = _datasArray;
    }else{
        _eqrMsgModel.ent_quick_reply = _datasArray;
    }
    
    WEAKSELF
    [[UserData sharedInstance] postClientCustomInfoWithEQRModel:_eqrMsgModel isShowLoding:isShowLoding block:^(ResponseInfo* response) {
        if (response && [response success]) {
            [weakSelf reloadTableView];
            [[UserData sharedInstance] setEqrMsgModel:_eqrMsgModel];
            if (successStr) {
                [UserData delayTask:0.2 onTimeEnd:^{
                    [UIHelper toast:successStr];
                }];
            }
        }else{
            [weakSelf getEqrData];
            if (failStr) {
                [UserData delayTask:0.2 onTimeEnd:^{
                    [UIHelper toast:failStr];
                }];
            }
        }
    }];
    
//    
//    NSString* msgStr = [_eqrMsgModel simpleJsonString];
//    EQRSendMsgModel* sendModel = [[EQRSendMsgModel alloc] init];
//    sendModel.data_content = msgStr;
//    sendModel.custom_info_type = @"1";
//    NSString* content = [sendModel getContent];
//    
//    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_postClientCustomInfo" andContent:content];
//    request.isShowLoading = isShowLoding;
//    WEAKSELF
//    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
//        if (response && [response success]) {
//            [weakSelf reloadTableView];
//            [[UserData sharedInstance] setEqrMsgModel:_eqrMsgModel];
//            if (successStr) {
//                [UserData delayTask:0.2 onTimeEnd:^{
//                    [UIHelper toast:successStr];
//                }];
//            }
//           
//        }else{
//            [weakSelf getEqrData];
//            if (failStr) {
//                [UserData delayTask:0.2 onTimeEnd:^{
//                    [UIHelper toast:failStr];
//                }];
//            }
//        }
//    }];
}

#pragma mark - tableView delegata
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString* cellIdentifier = @"cell";
    EditQuickReplyCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EditQuickReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.deletate = self;
    }
    if (_datasArray.count <= indexPath.row) {
        return cell;
    }
    
    NSString* msg = [_datasArray objectAtIndex:indexPath.row];
    [cell refreshWithData:msg andIndexPath:indexPath];
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_datasArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        [self sendUpdataRequest];
//    }else if (editingStyle == UITableViewCellEditingStyleInsert){
//        
//    }
//}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath != destinationIndexPath) {
        NSString* str1 = [_datasArray objectAtIndex:sourceIndexPath.row];
        
        [_datasArray removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > _datasArray.count) {
            [_datasArray addObject:str1];
        }else{
            [_datasArray insertObject:str1 atIndex:destinationIndexPath.row];
        }
        [self sendUpdateRequestWithType:EQRUpdateType_Move];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ELog(@"=====indexPath:%ld",(long)indexPath.row);
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasArray.count ? _datasArray.count : 0;
}


#pragma mark - eqr delegate
- (void)eqrCell_btnDelOnclickWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row < _datasArray.count) {
        [_datasArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self sendUpdateRequestWithType:EQRUpdateType_Del];
    }
}

- (void)eqrCell_editMsgWithIndexPath:(NSIndexPath *)indexPath msg:(NSString *)msg{
    if (indexPath.row < _datasArray.count) {
        [_datasArray replaceObjectAtIndex:indexPath.row withObject:msg];
        [self sendUpdateRequestWithType:EQRUpdateType_Update];
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
