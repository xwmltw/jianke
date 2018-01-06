//
//  EditResumeController.m
//  jianke
//
//  Created by fire on 15/9/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "EditResumeController.h"
#import "WDConst.h"
//#import "RightImgButton.h"
#import "JKModel.h"
#import "UIImageView+WebCache.h"
#import "UIHelper.h"
#import "CitySelectController.h"
#import "SchoolSelectController.h"
#import "SchoolModel.h"
#import "CityTool.h"
#import "UploadCard_VC.h"
#import "DateHelper.h"
#import "LookupResume_VC.h"
#import "IdentityCardAuth_VC.h"

@interface EditResumeController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>{

    JKModel* _jkModel;
    NSString* _headImgUrl;

    NSArray* _imgViewArr;
    NSMutableArray *_lifePhotoArray;    //生活照

    CityModel* _selectCity;

    BOOL _sexBool;
    
    SchoolModel* _schoolModel;
    NSString *_lifePhotoUrl;
}
@property (weak, nonatomic  ) IBOutlet UITableView    *tableView;/*!< tableView */
@property (weak, nonatomic) IBOutlet UIButton *headBtn;/*!< 头像 */
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic, strong) UIImagePickerController *ipc;

@property (nonatomic, weak) UIButton       *head1Btn;

//生活照imageView
@property (nonatomic, strong) UIImageView    *lifePhoto_1;
@property (nonatomic, strong) UIImageView    *lifePhoto_2;
@property (nonatomic, strong) UIImageView    *lifePhoto_3;
@property (nonatomic, strong) UIImageView    *lifePhoto_4;
@property (nonatomic, strong) UIImageView    *lifePhoto_5;
//添加照片按钮
@property (nonatomic, strong) UIButton       *btnLiefPhoto_1;
@property (nonatomic, strong) UIButton       *btnLiefPhoto_2;
@property (nonatomic, strong) UIButton       *btnLiefPhoto_3;
@property (nonatomic, strong) UIButton       *btnLiefPhoto_4;
@property (nonatomic, strong) UIButton       *btnLiefPhoto_5;
//删除照片按钮
@property (nonatomic, strong) UIButton       *deletePhotoBtn_1;
@property (nonatomic, strong) UIButton       *deletePhotoBtn_2;
@property (nonatomic, strong) UIButton       *deletePhotoBtn_3;
@property (nonatomic, strong) UIButton       *deletePhotoBtn_4;
@property (nonatomic, strong) UIButton       *deletePhotoBtn_5;

@property (nonatomic, strong) UITextField    *tfTureName;   //姓名
@property (nonatomic, strong) UIButton       *btnIdentity;//认证身份证按钮
@property (nonatomic, strong) UIButton       *btnAlreadyAuth;//认证身份证按钮
@property (nonatomic, strong) UITextField   *tfEmail;
@property (nonatomic, strong) UIButton       *btnGetLocal;  //所在区域
@property (nonatomic, strong) UIButton       *btnGetAdd;    //常在地
@property (nonatomic ,strong) UITextField    *workPlaceTextField;/*!< 详细工作地点 */
@property (nonatomic, strong) UIButton       *btnSchool;
@property (nonatomic, strong) UIButton       *btnMan;
@property (nonatomic, strong) UIButton       *btnWoman;
@property (nonatomic, strong) UITextField    *tfHeight;
@property (nonatomic, strong) UILabel        *labBirthday;//生日
@property (nonatomic, strong) UIButton       *btnBirthday;//选择出生日期
@property (nonatomic, strong) UITextField    *tfWeight;

@property (nonatomic, strong) NSString       *latitude;/*!< 维度 */
@property (nonatomic, strong) NSString       *longitude;/*!< 精度 */
//@property (nonatomic, strong) RightImgButton *btn;
//Ver.2.3.1
@property (nonatomic, strong) UIActionSheet  *menu;
@property (nonatomic, strong) NSDate         *tmpDate;
@end

@implementation EditResumeController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"编辑名片";
    [self initUI];
    _sexBool = YES;
    //获取数据
    _jkModel = [[JKModel alloc] init];
    [self getData];
}

- (void)initUI{
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [self.headBtn setToCircle];
    [self.headBtn addTarget:self action:@selector(getHeadImage) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.backgroundColor = [UIColor XSJColor_grayDeep];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置Footer
    UIView *footer = [[UIView alloc] init];
    UIButton *btn = [[UIButton alloc] init];
    footer.backgroundColor = [UIColor XSJColor_grayDeep];
    [btn addTarget:self action:@selector(btnSaveOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
    [footer addSubview:btn];
    [self.view addSubview:footer];
    
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_top).offset(-8);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(8);
        make.right.bottom.equalTo(footer).offset(-8);
        make.height.equalTo(@44);
    }];
    
    [footer addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_grayLine] isConstraint:YES];
}

/** 获取数据 */
- (void)getData{
    WEAKSELF
    [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *model) {
        if (!model) {
            [UIHelper toast:@"获取个人信息失败!"];
        }
        //加载原有数据
        _jkModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:model]];
        _imgViewArr = nil;
        _imgViewArr = [NSArray arrayWithObjects:weakSelf.lifePhoto_1,weakSelf.lifePhoto_2,weakSelf.lifePhoto_3,weakSelf.lifePhoto_4,weakSelf.lifePhoto_5,nil];
        
        //生活照
        _lifePhotoArray = nil;
        _lifePhotoArray = [NSMutableArray array];
        [_lifePhotoArray addObjectsFromArray:_jkModel.life_photo];
        [weakSelf loadheadBtn];
        [weakSelf.tableView reloadData];
    }];
}

- (void)updateData{
    WEAKSELF
    [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *model) {
        if (!model) {
            [UIHelper toast:@"获取个人信息失败!"];
        }
        //加载原有数据
        _jkModel.life_photo = model.life_photo;
        _imgViewArr = nil;
        _imgViewArr = [NSArray arrayWithObjects:weakSelf.lifePhoto_1,weakSelf.lifePhoto_2,weakSelf.lifePhoto_3,weakSelf.lifePhoto_4,weakSelf.lifePhoto_5,nil];
        
        //生活照
        _lifePhotoArray = nil;
        _lifePhotoArray = [NSMutableArray array];
        [_lifePhotoArray addObjectsFromArray:_jkModel.life_photo];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"cell%ld", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.row) {
        case 0://生活照
        {   
            self.lifePhoto_1 = (UIImageView *)[cell viewWithTag:901];
            self.lifePhoto_2 = (UIImageView *)[cell viewWithTag:902];
            self.lifePhoto_3 = (UIImageView *)[cell viewWithTag:903];
            self.lifePhoto_4 = (UIImageView *)[cell viewWithTag:904];
            self.lifePhoto_5 = (UIImageView *)[cell viewWithTag:905];
            
            self.lifePhoto_1.layer.cornerRadius = 3;
            self.lifePhoto_2.layer.cornerRadius = 3;
            self.lifePhoto_3.layer.cornerRadius = 3;
            self.lifePhoto_4.layer.cornerRadius = 3;
            self.lifePhoto_5.layer.cornerRadius = 3;
            
            self.lifePhoto_1.layer.masksToBounds = YES;
            self.lifePhoto_2.layer.masksToBounds = YES;
            self.lifePhoto_3.layer.masksToBounds = YES;
            self.lifePhoto_4.layer.masksToBounds = YES;
            self.lifePhoto_5.layer.masksToBounds = YES;

            self.btnLiefPhoto_1 = (UIButton *)[cell viewWithTag:801];
            self.btnLiefPhoto_2 = (UIButton *)[cell viewWithTag:802];
            self.btnLiefPhoto_3 = (UIButton *)[cell viewWithTag:803];
            self.btnLiefPhoto_4 = (UIButton *)[cell viewWithTag:804];
            self.btnLiefPhoto_5 = (UIButton *)[cell viewWithTag:805];
            
            self.deletePhotoBtn_1 = (UIButton*)[cell viewWithTag:701];
            self.deletePhotoBtn_2 = (UIButton*)[cell viewWithTag:702];
            self.deletePhotoBtn_3 = (UIButton*)[cell viewWithTag:703];
            self.deletePhotoBtn_4 = (UIButton*)[cell viewWithTag:704];
            self.deletePhotoBtn_5 = (UIButton*)[cell viewWithTag:705];
            
            [self.btnLiefPhoto_1 addTarget:self action:@selector(getLifePhotoImage) forControlEvents:UIControlEventTouchUpInside];
            [self.btnLiefPhoto_2 addTarget:self action:@selector(getLifePhotoImage) forControlEvents:UIControlEventTouchUpInside];
            [self.btnLiefPhoto_3 addTarget:self action:@selector(getLifePhotoImage) forControlEvents:UIControlEventTouchUpInside];
            [self.btnLiefPhoto_4 addTarget:self action:@selector(getLifePhotoImage) forControlEvents:UIControlEventTouchUpInside];
            [self.btnLiefPhoto_5 addTarget:self action:@selector(getLifePhotoImage) forControlEvents:UIControlEventTouchUpInside];
            
            [self.deletePhotoBtn_1 addTarget:self action:@selector(deletePhotoPic:) forControlEvents:UIControlEventTouchUpInside];
            [self.deletePhotoBtn_2 addTarget:self action:@selector(deletePhotoPic:) forControlEvents:UIControlEventTouchUpInside];
            [self.deletePhotoBtn_3 addTarget:self action:@selector(deletePhotoPic:) forControlEvents:UIControlEventTouchUpInside];
            [self.deletePhotoBtn_4 addTarget:self action:@selector(deletePhotoPic:) forControlEvents:UIControlEventTouchUpInside];
            [self.deletePhotoBtn_5 addTarget:self action:@selector(deletePhotoPic:) forControlEvents:UIControlEventTouchUpInside];

            [self btnSelect];
            
            NSUInteger count = _imgViewArr.count < _lifePhotoArray.count ? _imgViewArr.count : _lifePhotoArray.count;
            for (NSUInteger i = 0; i < count; i ++) {
                NSDictionary* dic = [_lifePhotoArray objectAtIndex:i];
                UIImageView* tempImgV = [_imgViewArr objectAtIndex:i];
                NSString *lifePhoto = [dic valueForKey:@"life_photo"];
                [tempImgV sd_setImageWithURL:[NSURL URLWithString:lifePhoto] placeholderImage:nil];
            }
        }
            break;
        case 1: // 姓名
        {
            self.tfTureName = (UITextField*)[cell viewWithTag:102];
            self.btnIdentity = (UIButton *)[cell viewWithTag:104];
            self.btnAlreadyAuth = (UIButton *)[cell viewWithTag:105];
            [self.btnAlreadyAuth addTarget:self action:@selector(alreadyAuth) forControlEvents:UIControlEventTouchUpInside];
            self.btnAlreadyAuth.hidden = YES;
            
            if (_jkModel.true_name.length > 0) {
                self.tfTureName.text = _jkModel.true_name;
            }
            
            if (_jkModel.id_card_verify_status.intValue == 1) {
                [self.btnIdentity setBackgroundImage:[UIImage imageNamed:@"info_auth_no"] forState:UIControlStateNormal];
            }else if(_jkModel.id_card_verify_status.intValue == 2){
                [self.btnIdentity setBackgroundImage:[UIImage imageNamed:@"info_auth_ing"] forState:UIControlStateNormal];
            }else if(_jkModel.id_card_verify_status.intValue == 3){
                [self.btnIdentity setBackgroundImage:[UIImage imageNamed:@"info_auth_yes"] forState:UIControlStateNormal];
            }
            
            //如果已经认证，名字不能修改，并且提示
            if (_jkModel.id_card_verify_status.intValue == 2 || _jkModel.id_card_verify_status.intValue == 3) {
                self.btnAlreadyAuth.hidden = NO;
            }
        }
            break;
        case 2:{
            self.tfEmail = (UITextField*)[cell viewWithTag:201];
            self.tfEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.tfEmail addTarget:self action:@selector(tfEmailOnChange:) forControlEvents:UIControlEventEditingChanged];
            if (_jkModel.email.length > 0) {
                self.tfEmail.text = _jkModel.email;
            }
        }
            break;
        case 3: // 所在区域
        {
            self.btnGetLocal = (UIButton *)[cell viewWithTag:107];
            if (_jkModel.city_name.length > 0 ) {
                if (_jkModel.address_area_name.length > 0) {
                    [self.btnGetLocal setTitle:[NSString stringWithFormat:@"%@ - %@",_jkModel.city_name, _jkModel.address_area_name] forState:UIControlStateNormal];
                }else{
                    [self.btnGetLocal setTitle:_jkModel.city_name forState:UIControlStateNormal];
                }
            }else{
                [self.btnGetLocal setTitle:@"选择所在区域" forState:UIControlStateNormal];
            }
        }
            break;
        case 4: // 常在地
        {
            self.btnGetAdd = (UIButton *)[cell viewWithTag:103];
            self.workPlaceTextField = (UITextField *)[cell viewWithTag:108];
            
            [self.btnGetAdd setTitle:@"获取位置" forState:UIControlStateNormal];
            self.workPlaceTextField.text = _jkModel.obode;
        }
            break;
        case 5: // 学校
        {
            self.btnSchool = (UIButton *)[cell viewWithTag:1025];
            
            [self.btnSchool addTarget:self action:@selector(btnSchoolOnclick:) forControlEvents:UIControlEventTouchUpInside];
            if (_jkModel.school_name.length > 0) {
                [self.btnSchool setTitle:_jkModel.school_name forState:UIControlStateNormal];
            }else if (_jkModel.school_id.intValue == -1){
                [self.btnSchool setTitle:@"其他学校" forState:UIControlStateNormal];
            }
        }
            break;
            
        case 6: // 性别
        {
            self.btnMan = (UIButton *)[cell viewWithTag:105];
            self.btnWoman = (UIButton *)[cell viewWithTag:106];
            [self.btnMan addTarget:self action:@selector(btnSexOnclick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnWoman addTarget:self action:@selector(btnSexOnclick:) forControlEvents:UIControlEventTouchUpInside];
            
            _sexBool = (_jkModel.sex.intValue == 1);
            self.btnMan.selected = _sexBool;
            self.btnWoman.selected = !_sexBool;
        }
            break;
            
        case 7: // 身高
        {
            self.tfHeight = (UITextField*)[cell viewWithTag:102];
            self.tfHeight.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.tfHeight addTarget:self action:@selector(tfHeightOnChange:) forControlEvents:UIControlEventEditingChanged];
            if (_jkModel.height) {
                self.tfHeight.text = _jkModel.height.stringValue;
            }
        }
            break;
        case 8: // 出生年月
        {
            self.labBirthday = (UILabel *)[cell viewWithTag:2017];
            self.btnBirthday = (UIButton *)[cell viewWithTag:2018];
            [self.btnBirthday addTarget:self action:@selector(btnBirthdayOnclick:) forControlEvents:UIControlEventTouchUpInside];
            self.labBirthday.text = _jkModel.birthday ? _jkModel.birthday : @"出生日期";
        }
            break;
        case 9: // 体重
        {
            self.tfWeight = (UITextField*)[cell viewWithTag:102];
            self.tfWeight.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.tfWeight addTarget:self action:@selector(tfWeightOnChange:) forControlEvents:UIControlEventEditingChanged];
            if (_jkModel.weight) {
                self.tfWeight.text = _jkModel.weight.stringValue;
            }
            break;
        }
    }
    
    return cell;
}

-(void)btnSelect{
    self.deletePhotoBtn_1.hidden = _jkModel.life_photo.count < 1;
    self.deletePhotoBtn_2.hidden = _jkModel.life_photo.count < 2;
    self.deletePhotoBtn_3.hidden = _jkModel.life_photo.count < 3;
    self.deletePhotoBtn_4.hidden = _jkModel.life_photo.count < 4;
    self.deletePhotoBtn_5.hidden = _jkModel.life_photo.count < 5;
    
    self.btnLiefPhoto_1.hidden = _jkModel.life_photo.count != 0;
    self.btnLiefPhoto_2.hidden = _jkModel.life_photo.count != 1;
    self.btnLiefPhoto_3.hidden = _jkModel.life_photo.count != 2;
    self.btnLiefPhoto_4.hidden = _jkModel.life_photo.count != 3;
    self.btnLiefPhoto_5.hidden = _jkModel.life_photo.count != 4;
    
    self.lifePhoto_1.hidden = _jkModel.life_photo.count < 1;
    self.lifePhoto_2.hidden = _jkModel.life_photo.count < 2;
    self.lifePhoto_3.hidden = _jkModel.life_photo.count < 3;
    self.lifePhoto_4.hidden = _jkModel.life_photo.count < 4;
    self.lifePhoto_5.hidden = _jkModel.life_photo.count < 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 36, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 36, 0, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 77;
    }
    return 44;
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ELog(@"%f",scrollView.contentOffset.y);
    CGFloat cy = scrollView.contentOffset.y;
    if (cy <= 0) {
        cy = cy * (-1);
        self.topView.transform = CGAffineTransformMakeScale(1 + cy/70, 1+ cy/70);
    }else if(!CGAffineTransformIsIdentity(self.topView.transform)){
        self.topView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 编辑信息操作业务
#pragma mark - 上传头像
- (void)getHeadImage{
    [self.view endEditing:YES];
    [TalkingData trackEvent:@"编辑兼客名片_头像"];
    if (!self.menu) {
        self.menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    }
    self.menu.tag = 101;
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
    if (self.menu.tag == 101) {
        uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_postResumeInfo_V1",@".jpg"];
        [self saveImage:newImg WithName:uploadImageName];
        [self performSelector:@selector(selectPic:) withObject:newImg afterDelay:0.1];
    }
    if (self.menu.tag == 102) {
        uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_stuUploadPhoto",@".jpg"];
        [self saveImage:newImg WithName:uploadImageName];
        [self performSelector:@selector(selectPhotoPic:) withObject:newImg afterDelay:0.1];
    }
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
    [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
    [self.headBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    RequestInfo *headImage = [[RequestInfo alloc]init];
    [headImage uploadImage:image andBlock:^( NSString *headImageUrl) {
        _headImgUrl = headImageUrl;
        ELog(@"图片地址==========.....%@",headImageUrl);
    }];
}



#pragma mark - 生活照
//上传生活照
- (void)getLifePhotoImage{
    if (!self.menu) {
        self.menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
        self.menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    }
    self.menu.tag = 102;
    [self.menu showInView:self.view];
}

//设置生活照显示
- (void)selectPhotoPic:(UIImage *)image{
    RequestInfo *lifePhoto = [[RequestInfo alloc]init];
    WEAKSELF
    [lifePhoto uploadImage:image andBlock:^( NSString *lifePhotoUrl) {
        _lifePhotoUrl = lifePhotoUrl;
        ELog(@"图片地址==========.....%@",_lifePhotoUrl);
        [weakSelf.tableView reloadData];
        [weakSelf uploadAgainGetData];
    }];
    
}

- (void)uploadAgainGetData{
    StuUploadPhotoPM *model = [[StuUploadPhotoPM alloc]init];
    model.photo_url = _lifePhotoUrl;
    model.photo_type = @(1);
    NSString *content = [model getContent];
    
    content = [content stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuUploadPhoto" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            [UIHelper toast:@"操作成功"];
            [weakSelf updateData];
        }
    }];
}

//删除生活照
- (void)deletePhotoPic:(UIButton*)sender{
    NSInteger tag = sender.tag;
    int i = tag%700-1;
    _lifePhotoArray = [NSMutableArray array];
    [_lifePhotoArray addObjectsFromArray:_jkModel.life_photo];
    NSDictionary* dic = [_lifePhotoArray objectAtIndex:i];
    NSString *lifePhotoID = [dic valueForKey:@"id"];
    NSString *content = [NSString stringWithFormat:@"life_photo_id:%@",lifePhotoID];
    
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuDeletePhoto" andContent:content];
    
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            [UIHelper toast:@"删除成功"];
            [weakSelf updateData];
        }
    }];
}

#pragma mark - 姓名
/** 认证身份证 */
- (IBAction)verifyClick:(UIButton *)sender{
    if (_jkModel.id_card_verify_status.intValue == 1) {
        WEAKSELF
        IdentityCardAuth_VC * vc = [[IdentityCardAuth_VC alloc] init];
        vc.block = ^(BOOL bRet){
            _jkModel.id_card_verify_status = @(2);
            [weakSelf.btnIdentity setBackgroundImage:[UIImage imageNamed:@"info_auth_ing"] forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//认证过不能修改
- (void)alreadyAuth{
    if (_jkModel.id_card_verify_status.intValue == 2) {
        [UIHelper toast:@"认证中不能修改"];
    }else if (_jkModel.id_card_verify_status.intValue == 3) {
        [UIHelper toast:@"已完成认证不能修改"];
    }
}

- (IBAction)nameChanged:(UITextField *)sender{
    if (sender.text.length > 10) {
        sender.text = [sender.text substringToIndex:10];
    }
    _jkModel.true_name = sender.text;
}

#pragma mark - 常驻区域
- (IBAction)adressBtn:(id)sender {
    //选择城市
    CitySelectController* cityVC = [[CitySelectController alloc] init];
    
    WEAKSELF
    cityVC.showSubArea = YES;
    cityVC.showParentArea = NO;//关闭父级区域
    cityVC.didSelectCompleteBlock = ^(CityModel *area){
        if ([area isKindOfClass:[CityModel class]]) {
            _selectCity = area;
            [weakSelf updateBtnLocation];
        }
    };
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//显示位置信息
- (void)updateBtnLocation{
    if (_selectCity){
        NSString *temp = @"";
        if (_selectCity.parent_name == nil) {
            temp = [temp stringByAppendingString:_selectCity.name];
        }else{
            temp = [temp stringByAppendingString:_selectCity.parent_name];
            temp = [temp stringByAppendingString:@" - "];
            temp = [temp stringByAppendingString:_selectCity.name];
        }
        [self.btnGetLocal setTitle:temp forState:UIControlStateNormal];
    }else{
        [UIHelper toast:@"没有城市信息"];
    }
}


/** 常在地 */
- (IBAction)addressChanged:(UITextField *)sender{
}

#pragma mark - 位置
/** 获取位置 */
- (IBAction)getLocaleClick:(UIButton *)sender{
    WEAKSELF
    [CityTool getLocalWithBlock:^(LocalModel *local) {
        if (local) {
            weakSelf.latitude = local.latitude;
            weakSelf.longitude = local.longitude;
            
            NSString *address = nil;
            if (local.address.length > 0) {
                address = local.address;
                if (local.country.length) {
                    address = [address stringByReplacingOccurrencesOfString:local.country withString:@""];
                }
                if (local.administrativeArea.length) {
                    address = [address stringByReplacingOccurrencesOfString:local.administrativeArea withString:@""];
                }
                if (local.locality.length) {
                    address = [address stringByReplacingOccurrencesOfString:local.locality withString:@""];
                }
                if (local.subLocality.length) {
                    address = [address stringByReplacingOccurrencesOfString:local.subLocality withString:@""];
                }
            }
          
            weakSelf.workPlaceTextField.text = address;
        }
    }];
}

#pragma mark - 学校
- (void)btnSchoolOnclick:(UIButton*)sender {
    SchoolSelectController *vc = [[SchoolSelectController alloc] init];
    if (_selectCity) {
        vc.cityId = [NSString stringWithFormat:@"%@",_selectCity.parent_id];
    }else{
        vc.cityId = [NSString stringWithFormat:@"%@", _jkModel.city_id];
    }
    vc.didSelectCompleteBlock = ^(SchoolModel *school){
        _schoolModel = school;
        [self.btnSchool setTitle:school.schoolName forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 性别
- (void)btnSexOnclick:(UIButton*)sender{
    if (sender.tag == 105) {
        _sexBool = YES;
        _jkModel.sex = @1;
    }else if (sender.tag == 106){
        _sexBool = NO;
        _jkModel.sex = @0;
    }
    self.btnMan.selected = _sexBool;
    self.btnWoman.selected = !_sexBool;
}


#pragma mark - 身高
- (IBAction)heightChanged:(UITextField *)sender{
    if (sender.text.length > 3) {
        sender.text = [sender.text substringToIndex:3];
    }
}

#pragma mark - 出生日期
-(void)btnBirthdayOnclick:(UIButton*)sender{
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"选择时间" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datepicker setDatePickerMode:UIDatePickerModeDate];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datepicker.locale = locale;
    datepicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    
    // 值不为空时  为时间控件赋值为当前的值
    if (_jkModel.birthday != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:_jkModel.birthday];
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
            self.labBirthday.text =  [DateHelper getDateDesc:self.tmpDate withFormat:@"yyyy-MM-dd"];
        }
    }];
}

//datePicker改变
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    if (datePicker.date) {
        self.tmpDate = datePicker.date;
    }
}

#pragma mark - 体重
- (IBAction)weightChanged:(UITextField *)sender{
    if (sender.text.length > 3) {
        sender.text = [sender.text substringToIndex:3];
    }
}

#pragma mark - 提交
/** 保存按钮点击 */
- (void)btnSaveOnclick:(UIButton*)sender{
    [TalkingData trackEvent:@"编辑兼客名片_保存"];
    //判定名字不能为空
    if (self.tfTureName.text.length <= 0 ) {
        DLAVAlertView *alert = [[DLAVAlertView alloc]initWithTitle:@"提示" message:@"姓名不能为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (!_jkModel.city_id && !_selectCity){           //城市id和区域id
        [UIHelper toast:@"区域不能为空"];
        return;
    }else if (self.tfEmail.text.length > 0){
        if (![MKCommonHelper validateEmail:self.tfEmail.text]) {
            [UIHelper toast:@"你的邮箱格式错误，请使用有效的邮箱"];
            return;
        }
    }
    

    PostResumeInfoPM* model = [[PostResumeInfoPM alloc] init];
    model.profile_url = _headImgUrl;
    model.true_name = self.tfTureName.text;
    model.email = self.tfEmail.text;
    model.obode = self.workPlaceTextField.text;//常在地
    
    if (_selectCity && _selectCity.parent_id) { // 获取到是区域
        model.city_id = _selectCity.parent_id;
        model.address_area_id = _selectCity.id;
    } else if (_selectCity) {
        model.city_id = _selectCity.id;
        model.address_area_id = @(0);
    }
    
    
    model.school_id = _schoolModel.id ? _schoolModel.id : ([_jkModel.school_id isEqual: @(0)]? nil : _jkModel.school_id);
    model.sex = _sexBool ? @(1) : @(0);
    model.weight = [NSNumber numberWithInt:self.tfWeight.text.intValue];
    model.height = [NSNumber numberWithInt:self.tfHeight.text.intValue];
    
    if (![self.labBirthday.text isEqualToString:@"出生日期"]) {
        model.birthday = self.labBirthday.text ? self.labBirthday.text : @"";
    }
    
    //经纬度
    model.lat = self.latitude;
    model.lng = self.longitude;
    NSString* content = [model getContent];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_postResumeInfo_V1" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"保存成功"];
            [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];

}

- (void)loadheadBtn{
    if (_jkModel.profile_url.length > 0) {
        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_jkModel.profile_url] forState:UIControlStateNormal placeholderImage:[UIHelper getDefaultHeadRect]];
    }
}

//邮箱
- (void)tfEmailOnChange:(UITextField *)sender{
    _jkModel.email = sender.text;
}

//身高
- (void)tfHeightOnChange:(UITextField *)sender{
    _jkModel.height = @(sender.text.floatValue);
}

//体重
- (void)tfWeightOnChange:(UITextField *)sender{
    _jkModel.weight = @(sender.text.floatValue);
}

#pragma mark - 按钮事件
//返回提示
- (void)backToLastView{
    [self.view endEditing:YES];
    WEAKSELF
    [UIHelper showConfirmMsg:@"您还未保存，确定要退出吗？" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}


//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
