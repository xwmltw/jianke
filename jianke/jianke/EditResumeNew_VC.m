//
//  EditResumeNew_VC.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "EditResumeNew_VC.h"
#import "CitySelectController.h"
#import "SchoolSelectController.h"
#import "GuideMaskView.h"
#import "EditResumeCell_name.h"
#import "EditResumeCell_Info.h"
#import "EditeResumeCell_position.h"
#import "EditeResumeCell_category.h"
#import "EditeResumeCell_height.h"

#import "CityTool.h"
#import "SchoolModel.h"
#import "EditResumeAlertTelView.h"

@interface EditResumeNew_VC () <EditResumeCell_nameDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditeResumeCell_positionDelegate>
{
    NSTimer *_timer;
    int _countdown;
    BOOL _bGetAuthNum;
    BOOL _isRevisePhone;
}
@property (nonatomic, strong) UIActionSheet  *menu;
@property (nonatomic, strong) UIImagePickerController *ipc;
@property (nonatomic, strong) NSDate    *tmpDate;
@property (nonatomic, strong) CityModel *selectCity;
@property (nonatomic, strong) AlertTelVIew *telView;
@end

@implementation EditResumeNew_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人信息";
    [self loadDatas];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClick)];
    
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:nib(@"EditResumeCell_name") forCellReuseIdentifier:@"EditResumeCell_name"];
    [self.tableView registerNib:nib(@"EditResumeCell_Info") forCellReuseIdentifier:@"EditResumeCell_Info"];
    [self.tableView registerNib:nib(@"EditeResumeCell_position") forCellReuseIdentifier:@"EditeResumeCell_position"];
    [self.tableView registerNib:nib(@"EditeResumeCell_category") forCellReuseIdentifier:@"EditeResumeCell_category"];
    [self.tableView registerNib:nib(@"EditeResumeCell_height") forCellReuseIdentifier:@"EditeResumeCell_height"];
    if (!self.jkModel) {
        [self getData];
    }else{
        //数据补偿
        if (!self.jkModel.sex) {
            self.jkModel.sex = @0;
        }
        if (!self.jkModel.user_type) {
            self.jkModel.user_type = @0;
        }
    }
}

- (void)loadDatas{
    [self.dataSource addObject:@(EditResumeCellType_name)];
    [self.dataSource addObject:@(EditResumeCellType_age)];
    [self.dataSource addObject:@(EditResumeCellType_city)];
    [self.dataSource addObject:@(EditResumeCellType_area)];
    [self.dataSource addObject:@(EditResumeCellType_tel)];
    [self.dataSource addObject:@(EditResumeCellType_categories)];
    [self.dataSource addObject:@(EditResumeCellType_education)];
    [self.dataSource addObject:@(EditResumeCellType_school)];
    [self.dataSource addObject:@(EditResumeCellType_profession)];
    [self.dataSource addObject:@(EditResumeCellType_speaility)];
    [self.dataSource addObject:@(EditResumeCellType_height)];
}

- (void)getData{
    WEAKSELF
    [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
        if (jkModel) {
            weakSelf.jkModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jkModel]];
            if (!weakSelf.jkModel.sex) {
                weakSelf.jkModel.sex = @0;
            }
            if (!weakSelf.jkModel.user_type) {
                weakSelf.jkModel.user_type = @0;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditResumeCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case EditResumeCellType_name:{
            EditResumeCell_name *cell = [tableView dequeueReusableCellWithIdentifier:@"EditResumeCell_name" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.jkModel];
            return cell;
        }
        case EditResumeCellType_age:
        case EditResumeCellType_city:
        case EditResumeCellType_tel:
        case EditResumeCellType_education:
        case EditResumeCellType_school:
        case EditResumeCellType_profession:
        case EditResumeCellType_speaility:{
            EditResumeCell_Info *cell = [tableView dequeueReusableCellWithIdentifier:@"EditResumeCell_Info" forIndexPath:indexPath];
            cell.cellType = cellType;
            cell.jkModel = self.jkModel;
            return cell;
        }
        case EditResumeCellType_area:{
            EditeResumeCell_position *cell = [tableView dequeueReusableCellWithIdentifier:@"EditeResumeCell_position" forIndexPath:indexPath];
            cell.delegate = self;
            cell.jkModel = self.jkModel;
            return cell;
        }
        case EditResumeCellType_categories:{
            EditeResumeCell_category *cell = [tableView dequeueReusableCellWithIdentifier:@"EditeResumeCell_category" forIndexPath:indexPath];
            cell.jkModel = self.jkModel;
            return cell;
        }
        case EditResumeCellType_height:{
            EditeResumeCell_height *cell = [tableView dequeueReusableCellWithIdentifier:@"EditeResumeCell_height" forIndexPath:indexPath];
            cell.model = self.jkModel;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditResumeCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case EditResumeCellType_name:{
            return 149.0f;
        }
        case EditResumeCellType_age:
        case EditResumeCellType_city:
        case EditResumeCellType_area:
        case EditResumeCellType_tel:
        case EditResumeCellType_categories:
        case EditResumeCellType_education:
        case EditResumeCellType_school:
        case EditResumeCellType_profession:
        case EditResumeCellType_speaility:{
            return 75.0f;
        }
        case EditResumeCellType_height:{
            return 75.0f;
        }
        default:
            break;
    }
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditResumeCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case EditResumeCellType_age:{
            [self chooseBirthday];
        }
            break;
        case EditResumeCellType_city:{
            [self getAdress];
        }
            break;
        case EditResumeCellType_education:{
            [self setEducation];
        }
            break;
        case EditResumeCellType_school:{
            [self setSchool];
        }
            break;
        case EditResumeCellType_tel:{
            [self setTel];
        }
            break;
        default:
            break;
    }
}

#pragma mark - EditResumeCell_nameDelegate
- (void)EditResumeCell_name:(NSUInteger )tag{
    if (tag == 100) {
        [GuideMaskView showTitle:@"提示" content:@"通过“实名认证”或处于“实名认证中”的用户不能再修改姓名哦~" cancel:nil commit:@"我知道了" block:^(NSInteger result) {
            
        }];
        return;
    }
    [self getHeadImage];
}

#pragma mark- EditeResumeCell_positionDelegate
- (void)EditeResumeCell_position:(EditeResumeCell_position *)cell{
    [self getLocale];
}

#pragma mark - 上传头像
- (void)getHeadImage{
    [self.view endEditing:YES];
    [TalkingData trackEvent:@"编辑兼客名片_头像"];
    if (!self.menu) {
        self.menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    }
    [self.menu showInView:self.view];
}
/** ActionSheet选择相应事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //按了取消
    if (buttonIndex == 2) {
        return;
    }
    WEAKSELF
    [UIDeviceHardware getCameraAuthorization:^(id obj) {
        if(buttonIndex == 0){
            weakSelf.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1){
            weakSelf.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [weakSelf presentViewController:weakSelf.ipc animated:YES completion:nil];
    }];
}

- (UIImagePickerController *)ipc{
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
        _ipc.allowsEditing = YES;
    }
    return _ipc;
}
/** 图片选择器选择完图片代理方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *newImg = image;
    NSString *uploadImageName;
    uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_postResumeInfo_V1",@".jpg"];
    [self saveImage:newImg WithName:uploadImageName];
    [self performSelector:@selector(selectPic:) withObject:newImg afterDelay:0.1];
}

/**
 *  保存图片
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    ELog(@"===TMP_UPLOAD_IMG_PATH===%@",imageName);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    imageName = fullPathToFile;
    __unused NSArray *nameAry = [imageName componentsSeparatedByString:@"/"];
    DLog(@"===new fullPathToFile===%@",fullPathToFile);
    DLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count] - 1]);
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/**
 *  设置图片尺寸
 */
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height = image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

//设置头像显示
-(void)selectPic:(UIImage*)image{
    RequestInfo *headImage = [[RequestInfo alloc]init];
    WEAKSELF
    [headImage uploadImage:image andBlock:^( NSString *headImageUrl) {
        weakSelf.jkModel.profile_url = headImageUrl;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 业务方法

//年龄
-(void)chooseBirthday{
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"选择时间" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    
    NSCalendar *calde = [NSCalendar currentCalendar];
    NSArray *array = [calde longEraSymbols];
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ELog(@"*******%@", obj);
    }];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    datepicker.maximumDate = [NSDate date];
    // 值不为空时  为时间控件赋值为当前的值
    if (self.jkModel.birthday.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:self.jkModel.birthday];
        [datepicker setDate:date];
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:@"1996-01-01"];
        [datepicker setDate:date];
    }
    
    self.tmpDate = datepicker.date;
    [datepicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    alertView.contentView = datepicker;
    
    [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) { // 取消
            return ;
        }else if (buttonIndex == 1){  // 确定
            self.jkModel.birthday = [DateHelper getDateDesc:self.tmpDate withFormat:@"yyyy-MM-dd"];
            [self.tableView reloadData];
        }
    }];
}

//datePicker改变
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    if (datePicker.date) {
        self.tmpDate = datePicker.date;
    }
}

//常驻区域
- (void)getAdress{
    //选择城市
    CitySelectController* cityVC = [[CitySelectController alloc] init];
    
    WEAKSELF
    cityVC.showSubArea = YES;
    cityVC.showParentArea = NO;//关闭父级区域
    cityVC.didSelectCompleteBlock = ^(CityModel *area){
        if ([area isKindOfClass:[CityModel class]]) {
            _selectCity = area;
            if (area) {
                if (area.parent_id) {
                    weakSelf.jkModel.city_id = area.parent_id;
                    weakSelf.jkModel.city_name = area.parent_name;
                    weakSelf.jkModel.address_area_id = area.id;
                    weakSelf.jkModel.address_area_name = area.name;
                }else{
                    weakSelf.jkModel.city_id = area.id;
                    weakSelf.jkModel.city_name = area.name;
                    weakSelf.jkModel.address_area_id = nil;
                    weakSelf.jkModel.address_area_name = nil;
                }
                [weakSelf.tableView reloadData];
            }else{
                [UIHelper toast:@"没有城市信息"];
            }
        }
    };
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//定位位置
- (void)getLocale{
    WEAKSELF
    [CityTool getLocalisShowLoading:YES block:^(LocalModel *local) {
        if (local) {
            weakSelf.jkModel.lat = local.latitude;
            weakSelf.jkModel.lng = local.longitude;
            
            NSString *address = nil;
            if (local.address.length > 0) {
                address = [local.address stringByReplacingOccurrencesOfString:local.country withString:@""];
                address = [address stringByReplacingOccurrencesOfString:local.administrativeArea withString:@""];
                address = [address stringByReplacingOccurrencesOfString:local.locality withString:@""];
                address = [address stringByReplacingOccurrencesOfString:local.subLocality withString:@""];
            }
            
            weakSelf.jkModel.obode = address;
            [weakSelf.tableView reloadData];
        }
    }];
}

//学历
- (void)setEducation{
    NSArray *arrayids = @[@0, @1, @2, @3, @4, @5];
    NSArray *array = @[@"高中",@"大专", @"本科", @"硕士", @"博士", @"其他"];
    [MKActionSheet sheetWithTitle:@"选择学历" buttonTitleArray:array isNeedCancelButton:NO maxShowButtonCount:6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        self.jkModel.education = [arrayids objectAtIndex:buttonIndex];
        [self.tableView reloadData];
    }];
}

// 学校
- (void)setSchool{
    SchoolSelectController *vc = [[SchoolSelectController alloc] init];
    if (self.jkModel.city_id) {
        vc.cityId = [NSString stringWithFormat:@"%@",self.jkModel.city_id];
    }else{
        vc.cityId = [NSString stringWithFormat:@"%@", _jkModel.city_id];
    }
    WEAKSELF
    vc.didSelectCompleteBlock = ^(SchoolModel *school){
        weakSelf.jkModel.school_id = school.id;
        weakSelf.jkModel.school_name = school.schoolName;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 联系方式
- (void)setTel{
    WEAKSELF
    self.telView = [[AlertTelVIew alloc]initWithFrame:[UIScreen mainScreen].bounds block:^(UIButton* sender) {
        
        switch (sender.tag) {
            case AlertTelBtnTag_code:
                [weakSelf getTelCode];
                
                break;
            case AlertTelBtnTag_cancel:
                
                weakSelf.telView.hidden = YES;
                [weakSelf cancelKeyboard];
                
                break;
            case AlertTelBtnTag_update:
                [weakSelf updateTel];
                break;
                
            default:
                break;
        }
        
    }];
    [self.view addSubview:self.telView];

}
- (void)getTelCode{
    if (self.telView.editTelView.textFiedTel.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位电话号码"];
        return;
    }
    [self cancelKeyboard];
    
    NSNumber* userType = [[UserData sharedInstance] getLoginType];
    WEAKSELF
    [[XSJRequestHelper sharedInstance]getAuthNumWithPhoneNum:self.telView.editTelView.textFiedTel.text andBlock:^(id result) {
        _bGetAuthNum = YES;
        [UIHelper toast:@"获取验证码成功"];
        weakSelf.telView.editTelView.btnGetCode.enabled = NO;
        _countdown = 60; //倒计时时间
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerFired:) userInfo:nil repeats:YES];

    } withOPT:WdVarifyCodeOptTypeEditResumeTel userType:userType];
    
    
}

- (void)timerFired:(id)sender{
    if (_countdown <= 0) {
        [_timer invalidate];
        _timer = nil;

        self.telView.editTelView.labMiao.hidden = YES;
        self.telView.editTelView.btnGetCode.enabled = YES;
    }else{
         self.telView.editTelView.labMiao.hidden = NO;
        self.telView.editTelView.labMiao.text = [NSString stringWithFormat:@"%.2d", _countdown];
        [self.telView.editTelView.btnGetCode setTitle:@"秒后重试" forState:UIControlStateDisabled];
        _countdown--;
    }
}
- (void)updateTel{
    [self cancelKeyboard];
    
    if (self.telView.editTelView.textFiedTel.text.length != 11) {
        [UIHelper toast:@"请输入正确的11位手机号码"];
        return;
    }else if (self.telView.editTelView.textFiedCode.text.length != 6) {
        [UIHelper toast:@"请输入正确的验证码"];
        return;
    }else if (!_bGetAuthNum) {
        [UIHelper toast:@"请重新获取验证码"];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"\"phone_num\":\"%@\",\"sms_authentication_code\":\"%@\"",self.telView.editTelView.textFiedTel.text,self.telView.editTelView.textFiedCode.text];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_updateResumeContactTelVerify" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"修改成功"];
            _isRevisePhone = YES;
            weakSelf.telView.hidden = YES;
            weakSelf.jkModel.telphone = self.telView.editTelView.textFiedTel.text;
            [weakSelf.tableView reloadData];
        }else{
            [UIHelper toast:response.errMsg];
        }
    }];
}
- (void)cancelKeyboard{
    
    [self.telView.editTelView.textFiedTel resignFirstResponder];
    [self.telView.editTelView.textFiedCode resignFirstResponder];

}
#pragma end mark
- (void)rightItemOnClick{
    
    if (!self.jkModel.true_name.length) {
        [UIHelper toast:@"请填写您的姓名"];
        return;
    }
    
    if (!self.jkModel.sex) {
        [UIHelper toast:@"请选择您的性别"];
        return;
    }
    
    if (!_jkModel.city_id){
        [UIHelper toast:@"请填写您的常驻城区"];
        return;
    }
    
    if (!_jkModel.birthday.length) {
        [UIHelper toast:@"请填写您的年龄"];
        return;
    }
    if(!self.jkModel.telphone.length){
        [UIHelper toast:@"请填写联系方式"];
        return;
    }
    PostResumeInfoPM* model = [[PostResumeInfoPM alloc] init];
    model.true_name = self.jkModel.true_name;
    model.profile_url = self.jkModel.profile_url;
    model.sex = self.jkModel.sex;
    model.birthday = self.jkModel.birthday;
    model.city_id = self.jkModel.city_id;
    model.address_area_id = self.jkModel.address_area_id;
    model.obode = self.jkModel.obode;
    model.user_type = self.jkModel.user_type;
    model.education = self.jkModel.education;
    model.school_id = self.jkModel.school_id;
    model.profession = self.jkModel.profession;
    model.specialty = self.jkModel.specialty;
    model.height = self.jkModel.height;
    model.weight = self.jkModel.weight;
    model.contact_tel = self.jkModel.telphone;
    
    
    NSString* content = [model getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postResumeInfo_V1" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"保存成功"];
            [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
            if (_isRevisePhone) {
                MKBlockExec(self.block, response.content);
            }else{
                MKBlockExec(self.block, nil);
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [UIHelper toast:response.errMsg];
        }
    }];

}

- (void)dealloc{
    DLog(@"dealloc");
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
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
