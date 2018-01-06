//
//  UploadCard_VC.m
//  jianke
//
//  Created by 时现 on 15/11/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "UploadCard_VC.h"
#import "ParamModel.h"
#import "WDConst.h"
#import "UIImageView+WebCache.h"
#import "JKModel.h"


@interface UploadCard_VC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    
    JKModel *_JKModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic ,copy) NSString *photo_url;//证件地址
@property (weak, nonatomic) IBOutlet UIButton *tempBtn;
@property (weak, nonatomic) IBOutlet UITextField *certificateNum;
@property (weak, nonatomic) IBOutlet UILabel *labPhotoName;
@property (nonatomic,assign) BOOL stuHasUpload;;
@property (nonatomic,assign) BOOL healthHasUpload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end

@implementation UploadCard_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tempBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.photo_type.intValue == 2) {
        self.labPhotoName.text = @"学生证照";
        self.title = @"上传学生证";
        self.certificateNum.placeholder = @"学生证号";
    }else if (self.photo_type.intValue == 3){
        self.labPhotoName.text = @"健康证照";
        self.title = @"上传健康证";
        self.certificateNum.placeholder = @"健康证号";
    }
    [self getData];
    //初始化界面
    self.certificateNum.font = [UIFont fontWithName:kFont_RSR size:16];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (doneButtonshow:) name: UIKeyboardDidShowNotification object:nil];
    self.viewHeight.constant = (SCREEN_WIDTH - 32) * 284/694;


}
-(void) doneButtonshow: (NSNotification *)notification {
    [self.tempBtn addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
}

-(void)hideKeyboard
{
    [self.certificateNum resignFirstResponder];
}

-(void)getData
{
    DLog(@"=======getJKModelWithBlock");
    [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *model) {
        if (!model) {
            [UIHelper toast:@"获取个人信息失败!"];
        }
        //设置数据显示
        if (model) {
            _JKModel = model;
            
            UIBarButtonItem *rightBarBtn;
            //设置右上角button
            if ( self.photo_type.intValue == 2) {
                
                if (_JKModel.stu_id_card_url.length > 0) {
                    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(btnSaveOnClick:)];
                }else{
                    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnSaveOnClick:)];
                }
            }
            if (self.photo_type.intValue == 3) {
                
                if (_JKModel.health_cer_url.length > 0) {
                    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(btnSaveOnClick:)];
                }else{
                    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnSaveOnClick:)];
                }
            }
            
            self.navigationItem.rightBarButtonItem = rightBarBtn;
            
            if (self.photo_type.intValue == 2 && _JKModel.stu_id_card_url.length > 0) {
//                self.imageView.image = [self getImage:_JKModel.stu_id_card_url];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:_JKModel.stu_id_card_url] placeholderImage:nil];
                self.photo_url = _JKModel.stu_id_card_url;
                self.certificateNum.text = _JKModel.stu_id_card_no ? _JKModel.stu_id_card_no : @"";
            }else if (self.photo_type.intValue == 3 && _JKModel.health_cer_url.length > 0){
//                self.imageView.image = [self getImage:_JKModel.health_cer_url];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:_JKModel.health_cer_url] placeholderImage:nil];
                self.photo_url = _JKModel.health_cer_url;
                self.certificateNum.text = _JKModel.health_cer_no ? _JKModel.health_cer_no : @"";
            }
        }
        }];

}


- (IBAction)certificateNumChanged:(UITextField *)sender {
    
    if (sender.text.length > 20) {
        sender.text = [sender.text substringToIndex:20];
    }
}
#pragma mark - 网络交互

-(void)btnSaveOnClick:(UIButton *)button
{
    
    if (self.certificateNum.text.length == 0) {
        [UIHelper toast:@"请输入证件号"];
    }else if (self.photo_url == nil) {
        [UIHelper toast:@"请选择图片"];
    }else{
        
    StuUploadPhotoPM *model = [[StuUploadPhotoPM alloc]init];

        model.photo_url = _photo_url;
        model.photo_type = self.photo_type;
        model.card_no = self.certificateNum.text;
        NSString *content = [model getContent];

    content = [content stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuUploadPhoto" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            [UIHelper toast:@"操作成功"];
            if (self.photo_type.intValue == 2) {
                _stuHasUpload = YES;
            }
            if (self.photo_type.intValue == 3) {
                _healthHasUpload = YES;
            }
            MKBlockExec(self.block, nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    }
}

#pragma mark - 选择图片
-(void)change:(UIButton*)sender
{
    [sender resignFirstResponder];
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //按了取消
    if (buttonIndex == 2) {
        return;
    }
    
    [UIDeviceHardware getCameraAuthorization:^(id obj) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        
        if(buttonIndex == 0){
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1){
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:ipc animated:YES completion:nil];
    }];
    
 
}
/** 图片选择器选择完图片代理方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *newImg = image;
    NSString *uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_stuUploadPhoto",@".jpg"];
    
    [self saveImage:newImg WithName:uploadImageName];
    [self performSelector:@selector(selectPic:) withObject:newImg afterDelay:0.1];
}
//设置头像显示
-(void)selectPic:(UIImage*)image
{
    self.imageView.image = image;
    RequestInfo *photo = [[RequestInfo alloc]init];
    [photo uploadImage:image andBlock:^( NSString *photoURL) {
        self.photo_url = photoURL;
        ELog(@"图片地址==========.....%@",photoURL);
    }];
}

/**
 *  设置图片尺寸
 */
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize
{
    newSize.height = image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
/**
 *  保存图片
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",imageName);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    imageName = fullPathToFile;
    __unused NSArray *nameAry = [imageName componentsSeparatedByString:@"/"];
    DLog(@"===new fullPathToFile===%@",fullPathToFile);
    DLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count] - 1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}


-(UIImage *)getImage:(NSString *)urlStr
{
    return [UIImage imageWithContentsOfFile:urlStr];
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
