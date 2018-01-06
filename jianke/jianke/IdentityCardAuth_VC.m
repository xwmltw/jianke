//
//  IdentityCardAuth_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IdentityCardAuth_VC.h"
#import "IdentityCardAuthCell_textField.h"
#import "IdentityCardAuthCell_photo.h"
#import "IdentityCardAuthCell_agree.h"
#import "IdentityCardAuthCell_intro.h"

#import "WebView_VC.h"

@interface IdentityCardAuth_VC ()<UIActionSheetDelegate,IdentityCardAuthCellPhotoDelegate>{
    BOOL _isAgree;
    IDCardAuthCellType _currentPhotoType;
}

@property (nonatomic, strong) PostIdcardAuthInfoPM *postIdcardAuthInfo;

@end

@implementation IdentityCardAuth_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    
    [self setUIHaveBottomView];
    _isAgree = YES;
    self.postIdcardAuthInfo = [[PostIdcardAuthInfoPM alloc] init];
    [self loadDataSource];
    [self getLatestVerifyInfo];
}
- (void)loadDataSource{
    [self.datasArray removeAllObjects];
    [self.datasArray addObject:@(IDCardAuthCellType_name)];
    [self.datasArray addObject:@(IDCardAuthCellType_idNum)];
    [self.datasArray addObject:@(IDCardAuthCellType_photo1)];
    [self.datasArray addObject:@(IDCardAuthCellType_photo2)];
    [self.datasArray addObject:@(IDCardAuthCellType_photo3)];
    if ([[UserData sharedInstance] getLoginType].integerValue == WDImUserType_Jianke) {
        [self.datasArray addObject:@(IDCardAuthCellType_jkIntor)];
    } else {
        [self.datasArray addObject:@(IDCardAuthCellType_epAgree)];
    }
    [self.tableView reloadData];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IDCardAuthCellType type = [[self.datasArray objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case IDCardAuthCellType_name:
        case IDCardAuthCellType_idNum:{
            IdentityCardAuthCell_textField* cell = [IdentityCardAuthCell_textField cellWithTableView:tableView];
            [cell setData:_postIdcardAuthInfo withIDCardAuthCellType:type];
            return cell;
        }
        case IDCardAuthCellType_photo1:
        case IDCardAuthCellType_photo2:
        case IDCardAuthCellType_photo3:{
            IdentityCardAuthCell_photo* cell = [IdentityCardAuthCell_photo cellWithTableView:tableView];
            cell.delegate = self;
            [cell setData:_postIdcardAuthInfo withIDCardAuthCellType:type];
            return cell;
        }
        case IDCardAuthCellType_epAgree:{
            IdentityCardAuthCell_agree* cell = [IdentityCardAuthCell_agree cellWithTableView:tableView];
            [cell.btnAgree addTarget:self action:@selector(btnAgreeOnclick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAgree.selected = _isAgree;
            [cell.btnAgreeText addTarget:self action:@selector(btnAgreeTextOnclick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case IDCardAuthCellType_jkIntor:{
            IdentityCardAuthCell_intro* cell = [IdentityCardAuthCell_intro cellWithTableView:tableView];
            return cell;
        }
        default:
            break;
    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray.count ? self.datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IDCardAuthCellType type = [[self.datasArray objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case IDCardAuthCellType_name:
        case IDCardAuthCellType_idNum:
            return 52;
        case IDCardAuthCellType_photo1:
        case IDCardAuthCellType_photo2:
        case IDCardAuthCellType_photo3:
            return 196;
        case IDCardAuthCellType_epAgree:
            return 40;
        case IDCardAuthCellType_jkIntor:
            return 96;
        default:
            break;
    }
    return 0;
}

#pragma mark - ***** 获取兼客认证状态 ******

- (void)getLatestVerifyInfo{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getLatestVerifyInfo:^(ResponseInfo *result) {
        if (result) {
            
            PostIdcardAuthInfoPM *tmp = [PostIdcardAuthInfoPM objectWithKeyValues:[result.content objectForKey:@"account_info"]];
            if (tmp.id_card_verify_status.integerValue > 1) {
                weakSelf.postIdcardAuthInfo = [PostIdcardAuthInfoPM objectWithKeyValues:[result.content objectForKey:@"last_id_card_verify_info"]];
                weakSelf.postIdcardAuthInfo.id_card_verify_status = tmp.id_card_verify_status;
            }else{
                weakSelf.postIdcardAuthInfo = tmp;
            }

            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - ***** 上传照片 ******
- (void)btnUploadOnclick:(UIButton*)sender{
    [self.view endEditing:YES];
    _currentPhotoType = sender.tag;
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

#pragma mark - ***** uiActionSheet ******
/** ActionSheet选择相应事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //按了取消
    if (buttonIndex == 2) {
        return;
    }
    WEAKSELF
    [UIDeviceHardware getCameraAuthorization:^(id obj) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        if(buttonIndex == 0){
            type = UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1){
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [[UIPickerHelper sharedInstance] presentImagePickerOnVC:weakSelf sourceType:type finish:^(NSDictionary<NSString *,id> *info) {
            UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
            UIImage* newImg = image;
            [weakSelf performSelector:@selector(selectPic:) withObject:newImg afterDelay:0.5];
        }];
    }];
}

/** 上传图片 */
- (void)selectPic:(UIImage*)image{
    WEAKSELF
    RequestInfo *request = [[RequestInfo alloc] init];
    request.isShowLoading = YES;
    [request uploadImage:image andBlock:^(NSString* imgUrl) {
        ELog(@"图片地址==========:%@",imgUrl);
        switch (_currentPhotoType) { // 正面
            case IDCardAuthCellType_photo1 :{ // 正面
                weakSelf.postIdcardAuthInfo.id_card_url_front = imgUrl;
                weakSelf.postIdcardAuthInfo.isUpdateIdCardUrlfront = YES;
            }
                break;
            case IDCardAuthCellType_photo2 :{ // 反面
                weakSelf.postIdcardAuthInfo.id_card_url_back = imgUrl;
                weakSelf.postIdcardAuthInfo.isUpdateIdCardUrlBack = YES;
            }
                break;
            case IDCardAuthCellType_photo3 :{ //手持身份证正面照
                weakSelf.postIdcardAuthInfo.id_card_url_third = imgUrl;
                weakSelf.postIdcardAuthInfo.isUpdateIdCardUrlthird = YES;
            }
                break;
            default:
                break;
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - ***** 按钮事件 ******
- (void)btnAgreeOnclick:(UIButton*)sender{
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}

/** 查看认证承诺书 */
- (void)btnAgreeTextOnclick:(UIButton*)sender{
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_entPromise];
    vc.title = @"雇主认证承诺书";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 提交 */
- (void)btnBottomOnclick:(UIButton *)sender{
    if (!self.postIdcardAuthInfo.true_name || self.postIdcardAuthInfo.true_name.length == 0 ) {
        [UIHelper toast:@"名字不能为空"];
        return;
    }
    
    if (!self.postIdcardAuthInfo.id_card_no || self.postIdcardAuthInfo.id_card_no.length != 18) {
        [UIHelper toast:@"请输入18位真实身份证号码"];
        return;
    }
    if (!self.postIdcardAuthInfo.id_card_url_front || self.postIdcardAuthInfo.id_card_url_front.length == 0) {
        [UIHelper toast:@"请上传身份证个人信息面照片"];
        return;
    }
    if (!self.postIdcardAuthInfo.id_card_url_back || self.postIdcardAuthInfo.id_card_url_back.length == 0) {
        [UIHelper toast:@"请上传身份证国徽面照片"];
        return;
    }
    if (!self.postIdcardAuthInfo.id_card_url_third || self.postIdcardAuthInfo.id_card_url_third.length == 0) {
        [UIHelper toast:@"请上传身份证手持照片"];
        return;
    }
    
    if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer) {
        if (!_isAgree) {
            [UIHelper toast:@"请阅读并确认同意雇主认证承诺书的内容!"];
            return;
        }
    }
    [self UploadResumeVerifyInfo];
}

/** 上传认证信息 */
- (void)UploadResumeVerifyInfo{
    NSString* content = [self.postIdcardAuthInfo getContent];
    
    WEAKSELF
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_idCardVerify" andContent:content];
    request.isShowLoading = YES;
    request.isShowErrorMsgAlertView = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
            if (weakSelf.isFromHome) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:@"提交成功"];
            }];
            if (weakSelf.block) {
                weakSelf.block(YES);
            }
        }
    }];
}

#pragma mark - IdentityCardAuthCellPhoto delegate

- (void)updatePhoto:(UIButton *)sender{
    [self.view endEditing:YES];
    _currentPhotoType = sender.tag;
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

/** 返回 */
- (void)backToLastView{
    if (self.isFromPostJobD4ci == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
