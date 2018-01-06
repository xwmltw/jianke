//
//  WelcomeJoinJK_VC.m
//  jianke
//
//  Created by yanqb on 2016/12/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WelcomeJoinJK_VC.h"
#import "RegisterGuide_VC.h"
#import "CitySelectController.h"

#import "JoinJKCell_Name.h"
#import "JoinJKCell_custome.h"

#import "CityTool.h"
#import "MKActionSheet.h"
#import "EPActionSheetItem.h"

@interface WelcomeJoinJK_VC () <JoinJKCell_NameDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PostResumeInfoPM *resumeInfoPM;
@property (nonatomic, strong) UIActionSheet  *menu;
@property (nonatomic, strong) UIImagePickerController *ipc;
@property (nonatomic, strong) JKModel *epModel;

@property (nonatomic, copy) NSArray *areaArr;
@property (nonatomic, strong) NSDate    *tmpDate;

@end

@implementation WelcomeJoinJK_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadDatas];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)loadDatas{
    self.resumeInfoPM = [[PostResumeInfoPM alloc] init];
    self.resumeInfoPM.sex = @0;
    
    [self.dataSource addObject:@(JoinJKCellType_Name)];
    [self.dataSource addObject:@(JoinJKCellType_Birthday)];
    [self.dataSource addObject:@(JoinJKCellType_City)];
//    [self.dataSource addObject:@(JoinJKCellType_Area)];
    
    if (self.isNotShowJobTrends) {
        WEAKSELF
        [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkInfo) {
            if (jkInfo) {
                weakSelf.epModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:jkInfo]];
                weakSelf.resumeInfoPM.true_name = weakSelf.epModel.true_name;
                weakSelf.resumeInfoPM.sex = weakSelf.epModel.sex ? weakSelf.epModel.sex : @0;
                weakSelf.resumeInfoPM.birthday = weakSelf.epModel.birthday;
                weakSelf.resumeInfoPM.city_id = weakSelf.epModel.city_id;
                weakSelf.resumeInfoPM.city_name = weakSelf.epModel.city_name;
                weakSelf.resumeInfoPM.address_area_id = weakSelf.epModel.address_area_id;
                weakSelf.resumeInfoPM.area_name = weakSelf.epModel.address_area_name;
                weakSelf.resumeInfoPM.profile_url = weakSelf.epModel.profile_url;
                weakSelf.resumeInfoPM.id_card_verify_status = weakSelf.epModel.id_card_verify_status;
                if (!weakSelf.epModel.city_id || !weakSelf.epModel.address_area_id) {
                    weakSelf.resumeInfoPM.address_area_id = nil;
                    weakSelf.resumeInfoPM.area_name = nil;
                    weakSelf.resumeInfoPM.city_id = nil;
                    weakSelf.resumeInfoPM.city_name = nil;
                }
//                if (weakSelf.epModel.city_id && weakSelf.epModel.address_area_id) {
//                    [weakSelf loadCityAreaWithCityId:weakSelf.epModel.city_id];
//                }
                [weakSelf.tableView reloadData];
            }
        }];
    }
    
    [self.tableView reloadData];
}

- (void)setupViews{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.leftBarButtonItems = @[backItem];
    
    NSString *itemTitle = @"下一步" ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(forwardStep)];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self getHeaderTableView];
    [self.tableView registerNib:nib(@"JoinJKCell_Name") forCellReuseIdentifier:@"JoinJKCell_Name"];
    [self.tableView registerClass:[JoinJKCell_custome class] forCellReuseIdentifier:@"JoinJKCell_custome"];
}

- (UIView *)getHeaderTableView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154)];
    
    UILabel *labTitle = [UILabel labelWithText:@"请完善您的基础信息" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:28];
    labTitle.numberOfLines = 0;
    UILabel *labSubTitle = [UILabel labelWithText:@"让雇主更好地了解您" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:16];
    labSubTitle.numberOfLines = 0;
    
    UILabel *labNext = [UILabel labelWithText:@"1/2" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:24.0f];
    labNext.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent003];
    labNext.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"1/2" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]} range:NSRangeFromString(@"{1, 2}")];
    labNext.attributedText = mutableAttStr;
    [labNext setCornerValue:26.0f];
    
    [headerView addSubview:labTitle];
    [headerView addSubview:labSubTitle];
    [headerView addSubview:labNext];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(40);
        make.left.equalTo(headerView).offset(16);
        make.right.equalTo(headerView).offset(-68);
    }];
    
    [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(8);
        make.left.equalTo(labTitle);
        make.right.equalTo(headerView).offset(-68);
    }];
    
    [labNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle);
        make.right.equalTo(headerView).offset(-16);
        make.width.height.equalTo(@52);
    }];
    
    return headerView;
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinJKCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case JoinJKCellType_Name:{
            JoinJKCell_Name *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinJKCell_Name" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.resumeInfoPM];
            return cell;
        }
        case JoinJKCellType_Birthday:
        case JoinJKCellType_City:
        case JoinJKCellType_Area:{
            JoinJKCell_custome *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinJKCell_custome" forIndexPath:indexPath];
            [cell setModel:self.resumeInfoPM cellType:cellType];
            return cell;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinJKCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case JoinJKCellType_Name:
            return 116.0f;
        default:
            return 75.0f;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JoinJKCellType cellType = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    switch (cellType) {
        case JoinJKCellType_Birthday:{
            [self chooseBirthday];
        }
            break;
        case JoinJKCellType_City:{
            [self selectCity];
        }
            break;
        case JoinJKCellType_Area:{
            [self selectArea];
        }
            break;
        default:
            break;
    }
}

#pragma mark - JoinJKCell_NameDelegate

- (void)joinJKCell:(JoinJKCell_Name *)cell actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_uploadHeadImg:{ //上传头像
            [self getHeadImage];
        }
            break;
            
        default:
            break;
    }
}

- (void)getHeadImage{
    [self.view endEditing:YES];
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

//    uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_postResumeInfo_V1",@".jpg"];
//        [self saveImage:newImg WithName:uploadImageName];
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
        weakSelf.resumeInfoPM.profile_url = headImageUrl;
        [weakSelf.tableView reloadData];
        ELog(@"图片地址==========.....%@",headImageUrl);
    }];
}


#pragma mark - 其他
- (void)forwardStep{
    
    //判定名字不能为空
    if (!self.resumeInfoPM.true_name.length) {
         [UIHelper toast:@"姓名不能为空"];
        return;
    }
    
    if (self.resumeInfoPM.true_name.length < 2) {
        [UIHelper toast:@"姓名长度不能小于2位"];
        return;
    }
    
    if (!self.resumeInfoPM.sex) {
        [UIHelper toast:@"请选择性别"];
        return;
    }
    
    if (!self.resumeInfoPM.birthday.length) {
        [UIHelper toast:@"年龄不能为空"];
        return;
    }
    
    if (!self.resumeInfoPM.city_id){           //城市id
        [UIHelper toast:@"常驻城市不能为空"];
        return;
    }
    
    self.resumeInfoPM.lat = [UserData sharedInstance].local.latitude;
    self.resumeInfoPM.lng = [UserData sharedInstance].local.longitude;
    
    NSString* content = [self.resumeInfoPM getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_improveResumeInfo" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            RegisterGuide_VC *viewCtrl = [[RegisterGuide_VC alloc] init];
            viewCtrl.city_id = weakSelf.resumeInfoPM.city_id;
            viewCtrl.block = weakSelf.block;
            [weakSelf.navigationController pushViewController:viewCtrl animated:YES];
        }
    }];
    
}

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
    if (self.resumeInfoPM.birthday != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:self.resumeInfoPM.birthday];
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
            self.resumeInfoPM.birthday = [DateHelper getDateDesc:self.tmpDate withFormat:@"yyyy-MM-dd"];
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

- (void)selectCity{
    CitySelectController* cityVC = [[CitySelectController alloc] init];
    cityVC.isFromNewFeature = self.isFromNewFeature;
    cityVC.showSubArea = YES;
    cityVC.showCityWide = YES;
    WEAKSELF
    cityVC.didSelectCompleteBlock = ^(CityModel *area){
        if ([area isKindOfClass:[CityModel class]]) {
            if (area.parent_id) {
                weakSelf.resumeInfoPM.address_area_id = area.id;
                weakSelf.resumeInfoPM.area_name = area.name;
                weakSelf.resumeInfoPM.city_id = area.parent_id;
                weakSelf.resumeInfoPM.city_name = area.parent_name;
            }else{
                weakSelf.resumeInfoPM.address_area_id = nil;
                weakSelf.resumeInfoPM.area_name = nil;
                weakSelf.resumeInfoPM.city_id = area.id;
                weakSelf.resumeInfoPM.city_name = area.name;
            }
            [weakSelf.tableView reloadData];
        }
    };
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)selectArea{
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (CityModel *area in self.areaArr) {
        EPActionSheetItem *item = [[EPActionSheetItem alloc] initWithTitle:area.name arg:area];
        [items addObject:item];
    }
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"请选择常驻区域" objArray:items titleKey:@"title"];
    sheet.maxShowButtonCount = 5.6;
    [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex < items.count) {
            EPActionSheetItem *item = [items objectAtIndex:buttonIndex];
            CityModel *area = item.arg;
            self.resumeInfoPM.address_area_id = area.id;
            self.resumeInfoPM.area_name = area.name;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadCityAreaWithCityId:(NSNumber *)cityId{
    WEAKSELF
    [CityTool getAreasWithCityId:cityId block:^(NSArray *cityArr) {
        weakSelf.areaArr = cityArr;
        [weakSelf selectArea];
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
