//
//  LookupResume_VC.m
//  jianke
//
//  Created by 时现 on 16/1/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "LookupResume_VC.h"
#import "JKModel.h"
#import "WDConst.h"
#import "UIImageView+WebCache.h"
#import "EditResumeNew_VC.h"
#import "IdentityCardAuth_VC.h"
#import "SchoolModel.h"
#import "WDChatView_VC.h"
#import "Masonry.h"
#import "WorkHistoryController.h"
#import "UploadCard_VC.h"
#import "PictureBrowser.h"
#import "XSJRequestHelper.h"
#import "XZImgPreviewView.h"
#import "EvaluationViewController.h"
#import "InterestJob_VC.h"
#import "WorkExperienceList_VC.h"
#import "PostWorkExpe_VC.h"
#import "GuideMaskView.h"
#import "ChangePhoneNum_VC.h"

#import "LookupResumeCell_Info.h"
#import "LookupResumeCell_compete.h"
#import "LookupResumeCell_iDCer.h"
#import "LookupResumeCell_WorkExperience.h"
#import "LookupResumeCell_card.h"
#import "LookupResumeCell_previewCompete.h"
#import "LookupResumeCell_PreviewCard.h"
#import "LookupResumeCell_selfApprisa.h"
#import "LookupResumeHeaderView.h"

#import "NSString+XZExtension.h"

#define FONTCOLOR MKCOLOR_RGB(51, 51, 51)
#define BACKGROUNDCOLOR MKCOLOR_RGB(240, 240, 240)
#define SEPARATECOLOR MKCOLOR_RGB(234, 234, 234)
#define TITLECOLOR MKCOLOR_RGB(89, 89, 89)

#define LIFEPHOTO_WITH SCREEN_WIDTH/5

typedef NS_ENUM(NSInteger, Inform) {
    InformName = 1,
    InformEmail = 2,
    InformBirthday = 3,
    InformArea = 4,
    InformSchool = 5,
    InformSex = 6,
    InformHeight = 7,
    InformWeight = 8,
};

@interface LookupResume_VC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, LookupResumeCell_competeDelegate, LookupResumeHeaderViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LookupResumeCell_previewCompeteDelegate>

@property (nonatomic, strong) JKModel   *jkModel;/*!< 兼客简历模型 */

//去完善btn
@property (weak, nonatomic) UIView *btnBackView;
@property (weak, nonatomic) UIButton *btnToPerfect;    //去完善  移出本群  公用按钮

//生活照View
@property (nonatomic, copy) NSArray *imgArr;
@property (nonatomic, copy) NSArray *viewArr;

@property (nonatomic, strong) UIView *allLifeView;
@property (nonatomic, strong) UIView *lifePhotoView_1;
@property (nonatomic, strong) UIView *lifePhotoView_2;
@property (nonatomic, strong) UIView *lifePhotoView_3;
@property (nonatomic, strong) UIView *lifePhotoView_4;
@property (nonatomic, strong) UIView *lifePhotoView_5;

@property (nonatomic, strong) UIImageView *lifePhoto_1;
@property (nonatomic, strong) UIImageView *lifePhoto_2;
@property (nonatomic, strong) UIImageView *lifePhoto_3;
@property (nonatomic, strong) UIImageView *lifePhoto_4;
@property (nonatomic, strong) UIImageView *lifePhoto_5;

//added by kizy from V3.2.4

//头部
@property (nonatomic, strong) LookupResumeHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableArray *resumeArr;    //简历信息数组
@property (nonatomic, strong) NSMutableArray *jobTrendArr;  //兼职意向数组
@property (nonatomic, strong) NSMutableArray *idCerArr; //实名认证数组
@property (nonatomic, strong) NSMutableArray *infoArr;  //个人信息数组
@property (nonatomic, strong) NSMutableArray *lifePhotoArr; //生活照数组
@property (nonatomic, strong) NSMutableArray *workExperience;   //工作经历数组
@property (nonatomic, strong) NSMutableArray *selfApparisa; //自我评价数组
@property (nonatomic, strong) NSMutableArray *studentIdArr;   //学生证数组
@property (nonatomic, strong) NSMutableArray *healthIdArr;  //健康证数组
@property (nonatomic, strong) NSMutableArray *workHistoryArr;   //放鸽子etc
@property (nonatomic, strong) NSMutableArray *newlineArr; //最新在线数组
@property (nonatomic, strong) NSMutableArray *cardArr;  //证件信息

@property (nonatomic, strong) UIImagePickerController *ipc;
@property (nonatomic, strong) UIActionSheet  *menu;

@end

@implementation LookupResume_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    [self getData];
}

#pragma mark - 获取数据
/** 获取简历模型 */
- (void)getData{
    // 直接传递模型进来
    if (self.otherJkModel) {
        self.jkModel = self.otherJkModel;
        if (self.jkModel.school_id.intValue == -1) {
            self.jkModel.school_name = @"其他学校";
        }
        [self setData];
        return;
    }
    WEAKSELF
    if (self.isLookOther) { // 雇主视角
        if (self.isFromGroupMembers && self.accountId) {
            [[UserData sharedInstance] getJKModelWithAccountId:self.accountId block:^(JKModel *jkModel) {
                if (!jkModel) {
                    [UIHelper toast:@"获取简历信息失败!"];
                } else {
                    weakSelf.jkModel = jkModel;
                    if (weakSelf.jkModel.school_id.intValue == -1) {
                        weakSelf.jkModel.school_name = @"其他学校";
                    }
                    [weakSelf setData];
                }
            }];
        }else if (self.resumeId){
            [[UserData sharedInstance] getJKModelWithResumeId:self.resumeId.description block:^(JKModel *jkModel) {
                if (!jkModel) {
                    [UIHelper toast:@"获取简历信息失败!"];
                } else {
                    weakSelf.jkModel = jkModel;
                    if (weakSelf.jkModel.school_id.intValue == -1) {
                        weakSelf.jkModel.school_name = @"其他学校";
                    }
                    [weakSelf setData];
                }
            }];
        }
    } else { // 兼客视角
        [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
            if (!jkModel) {
                [UIHelper toast:@"获取个人信息失败!"];
            } else {
                weakSelf.jkModel = jkModel;
                if (weakSelf.jkModel.school_id.intValue == -1) {
                    weakSelf.jkModel.school_name = @"其他学校";
                }
                [weakSelf setData];
            }
        }];
    }
}
//设置数据
-(void)setData{
    [self loadData];
    
    [self.headerView setModel:self.jkModel isLookOther:self.isLookOther];
    
    //简历完整度
    [self.newlineArr removeAllObjects];
    [self.workHistoryArr removeAllObjects];
    [self.resumeArr removeAllObjects];
    if (self.isLookOther) {
        [self.workHistoryArr addObject:@(LookupResumeCellType_previewWorkInfo)];
        [self.newlineArr addObject:@(LookupResumeCellType_newLine)];
        
    }else{
        [self.resumeArr addObject:@(LookupResumeCellType_resumeIntegrity)];
    }
    
    //实名认证
    [self.idCerArr removeAllObjects];
    [self.idCerArr addObject:@(LookupResumeCellType_idCertification)];
    
    //生活照
    [self.lifePhotoArr removeAllObjects];
//    if (self.jkModel.life_photo.count) {
        [self.lifePhotoArr addObject:@(LookupResumeCellType_lifePhotos)];
//    }
    
    //工作经历
    [self.workExperience removeAllObjects];
    if (self.jkModel.resume_experience_list.count) {
        if (self.jkModel.resume_experience_list.count <= 5) {
            self.workExperience = [self.jkModel.resume_experience_list mutableCopy];
        }else{
            self.workExperience = [[self.jkModel.resume_experience_list subarrayWithRange:NSMakeRange(0, 5)] mutableCopy];
        }
    }
    
    //自我评价
    [self.selfApparisa removeAllObjects];
    if (self.jkModel.desc.length) {
        [self.selfApparisa addObject:@(LookupResumeCellType_selfAppraisa)];
    }
    
    //学生证
    [self.studentIdArr removeAllObjects];
    if (self.jkModel.stu_id_card_no) {
        [self.studentIdArr addObject:@(LookupResumeCellType_studentId)];
    }
    
    //健康证
    [self.healthIdArr removeAllObjects];
    if (self.jkModel.health_cer_no) {
        [self.healthIdArr addObject:@(LookupResumeCellType_healthId)];
    }
    
    //证件信息
    [self.cardArr removeAllObjects];
    [self.cardArr addObject:@(LookupResumeCellType_previewStudentId)];
    [self.cardArr addObject:@(LookupResumeCellType_previewHealthId)];
    
    [self.tableView reloadData];
}

#pragma mark - setupUI
- (void)setupUI{
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.delegate = self;
    if (!self.isLookOther)  { // 兼客视角
        self.title = @"我的简历";
        // 编辑按钮
        UIButton *button = [UIButton buttonWithTitle:@"预览" bgColor:nil image:nil target:self sector:@selector(previewResume)];
        button.width = 50;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }else{
        if (self.presentingViewController) {
            // 编辑按钮
            UIButton *button = [UIButton buttonWithTitle:@"返回" bgColor:nil image:nil target:self sector:@selector(backResumeVC)];
            button.width = 50;
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        
    }
    [self.tableView registerNib:nib(@"LookupResumeCell_Info") forCellReuseIdentifier:@"LookupResumeCell_Info"];
    [self.tableView registerNib:nib(@"LookupResumeCell_compete") forCellReuseIdentifier:@"LookupResumeCell_compete"];
    [self.tableView registerNib:nib(@"LookupResumeCell_iDCer") forCellReuseIdentifier:@"LookupResumeCell_iDCer"];
    [self.tableView registerNib:nib(@"LookupResumeCell_WorkExperience") forCellReuseIdentifier:@"LookupResumeCell_WorkExperience"];
    [self.tableView registerNib:nib(@"LookupResumeCell_card") forCellReuseIdentifier:@"LookupResumeCell_card"];
    [self.tableView registerNib:nib(@"LookupResumeCell_previewCompete") forCellReuseIdentifier:@"LookupResumeCell_previewCompete"];
    [self.tableView registerNib:nib(@"LookupResumeCell_PreviewCard") forCellReuseIdentifier:@"LookupResumeCell_PreviewCard"];
    [self.tableView registerClass:[LookupResumeCell_selfApprisa class] forCellReuseIdentifier:@"LookupResumeCell_selfApprisa"];
}

- (void)loadData{
    self.workHistoryArr = [NSMutableArray array];
    [self.workHistoryArr addObject:@(LookupResumeCellType_previewWorkInfo)];
    
    self.newlineArr = [NSMutableArray array];
    [self.newlineArr addObject:@(LookupResumeCellType_newLine)];
    
    self.resumeArr = [NSMutableArray array];
    [self.resumeArr addObject:@(LookupResumeCellType_resumeIntegrity)];
    
    self.jobTrendArr = [NSMutableArray array];
    [self.jobTrendArr addObject:@(LookupResumeCellType_jobType)];
    [self.jobTrendArr addObject:@(LookupResumeCellType_jobArea)];
    
    self.idCerArr = [NSMutableArray array];
    
    self.infoArr = [NSMutableArray array];
    if (!self.isLookOther) {
        [self.infoArr addObject:@(LookupResumeCellType_name)];
        [self.infoArr addObject:@(LookupResumeCellType_sex)];
        [self.infoArr addObject:@(LookupResumeCellType_live)];
        
    }
    if (self.isLookOther) {
        if (self.jkModel.telphone.length) {
//            [self.infoArr addObject:@(LookupResumeCellType_account)];
        }
        if (self.jkModel.user_type) {
            [self.infoArr addObject:@(LookupResumeCellType_personnelCategories)];
        }else if(!self.jkModel.user_type && !self.jkModel.education && !self.jkModel.school_name.length && !self.jkModel.profession.length && !self.jkModel.specialty.length && !self.jkModel.height ){
            [self.infoArr addObject:@(LookupResumeCellType_personnelCategories)];
        }
        if (self.jkModel.education) {
            [self.infoArr addObject:@(LookupResumeCellType_education)];
        }
        if (self.jkModel.school_name.length) {
            [self.infoArr addObject:@(LookupResumeCellType_school)];
        }
        if (self.jkModel.profession.length) {
            [self.infoArr addObject:@(LookupResumeCellType_professional)];
        }
        if (self.jkModel.specialty.length) {
            [self.infoArr addObject:@(LookupResumeCellType_speciality)];
        }
        if (self.jkModel.height) {
            [self.infoArr addObject:@(LookupResumeCellType_height)];
        }
    }else{
        [self.infoArr addObject:@(LookupResumeCellType_account)];
        [self.infoArr addObject:@(LookupResumeCellType_personnelCategories)];
        [self.infoArr addObject:@(LookupResumeCellType_education)];
        [self.infoArr addObject:@(LookupResumeCellType_school)];
        [self.infoArr addObject:@(LookupResumeCellType_professional)];
        [self.infoArr addObject:@(LookupResumeCellType_speciality)];
        [self.infoArr addObject:@(LookupResumeCellType_height)];
    }
    
    self.lifePhotoArr = [NSMutableArray array];
    self.workExperience = [NSMutableArray array];
    self.selfApparisa = [NSMutableArray array];
    self.studentIdArr = [NSMutableArray array];
    self.healthIdArr = [NSMutableArray array];
    self.cardArr = [NSMutableArray array];
    
    self.sectionArr = [NSMutableArray array];
    if (self.isLookOther) {
        [self.sectionArr addObject:@(LookupResumeSectionType_previewResume)];
        [self.sectionArr addObject:@(LookupResumeSectionType_newLine)];
    }else{
        [self.sectionArr addObject:@(LookupResumeSectionType_resumeIntegrity)];
    }
    [self.sectionArr addObject:@(LookupResumeSectionType_applyTrends)];
    if (!self.isLookOther) {
        [self.sectionArr addObject:@(LookupResumeSectionType_idCertification)];
    }
    [self.sectionArr addObject:@(LookupResumeSectionType_personalInfo)];
    if (self.isLookOther) {
        if (self.jkModel.life_photo.count) {
            [self.sectionArr addObject:@(LookupResumeSectionType_lifePhotos)];
        }
        if (self.jkModel.resume_experience_list.count) {
            [self.sectionArr addObject:@(LookupResumeSectionType_workExperience)];
        }
        if (self.jkModel.desc.length) {
            [self.sectionArr addObject:@(LookupResumeSectionType_selfAppraisa)];
        }
        if (self.jkModel.stu_id_card_no || self.jkModel.health_cer_no) {
            [self.sectionArr addObject:@(LookupResumeSectionType_previewCards)];
        }
    }else{
        [self.sectionArr addObject:@(LookupResumeSectionType_lifePhotos)];
        if (self.jkModel.resume_experience_list.count) {
            [self.sectionArr addObject:@(LookupResumeSectionType_workExperience)];
        }else{
            [self.sectionArr addObject:@(LookupResumeSectionType_workExperienceNoData)];
        }
        [self.sectionArr addObject:@(LookupResumeSectionType_selfAppraisa)];
        [self.sectionArr addObject:@(LookupResumeSectionType_studentId)];
        [self.sectionArr addObject:@(LookupResumeSectionType_healthId)];
    }
}

#pragma mark - 业务方法

//    生活照
- (void)lifePhotoUI{
    self.imgArr = @[self.lifePhoto_1, self.lifePhoto_2, self.lifePhoto_3, self.lifePhoto_4, self.lifePhoto_5];
    self.viewArr = @[self.lifePhotoView_1, self.lifePhotoView_2, self.lifePhotoView_3, self.lifePhotoView_4, self.lifePhotoView_5];
    if (self.jkModel.life_photo.count > 0) {
        self.lifePhotoView_1.hidden = self.jkModel.life_photo.count < 1;
        self.lifePhotoView_2.hidden = self.jkModel.life_photo.count < 2;
        self.lifePhotoView_3.hidden = self.jkModel.life_photo.count < 3;
        self.lifePhotoView_4.hidden = self.jkModel.life_photo.count < 4;
        self.lifePhotoView_5.hidden = self.jkModel.life_photo.count < 5;
    }else{
        if (!self.isLookOther) {
            UIButton *btnAddLifePhoto = [[UIButton alloc]initWithFrame:CGRectMake((LIFEPHOTO_WITH - 52)/2, 7, 52, 52)];
            [btnAddLifePhoto setBackgroundImage:[UIImage imageNamed:@"v250_add_btm"] forState:UIControlStateNormal];
            [btnAddLifePhoto setBackgroundImage:[UIImage imageNamed:@"v250_add_btmp"] forState:UIControlStateHighlighted];
            [btnAddLifePhoto addTarget:self action:@selector(addLifePicture) forControlEvents:UIControlEventTouchUpInside];
            self.lifePhotoView_1.hidden = NO;
            self.lifePhotoView_2.hidden = YES;
            self.lifePhotoView_3.hidden = YES;
            self.lifePhotoView_4.hidden = YES;
            self.lifePhotoView_5.hidden = YES;
            [self.lifePhotoView_1 addSubview:btnAddLifePhoto];
        }
    }
}

#pragma  mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = [self getArrayInSection:indexPath.section];
    id model = [array objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ResumeExperience class]]) {
        LookupResumeCell_WorkExperience *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_WorkExperience" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }else{
        LookupResumeCellType cellType = [model integerValue];
        switch (cellType) {
            case LookupResumeCellType_resumeIntegrity:{ //简历完整度
                LookupResumeCell_compete *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_compete" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setModel:self.jkModel];
                return cell;
            }
            case LookupResumeCellType_previewWorkInfo:{ //预览-放鸽子etc
                LookupResumeCell_previewCompete *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_previewCompete" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setModel:self.jkModel];
                return cell;
            }
            case LookupResumeCellType_newLine:{//最新在线
                NSString * dentifier = @"newlineDentifier";
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dentifier];
                [cell.textLabel setTextColor:MKCOLOR_RGB(34, 58, 80)];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
                cell.textLabel.text = self.jkModel.last_login_time_str;
                return cell;
            }
    
            case LookupResumeCellType_idCertification:{ //实名认证
                LookupResumeCell_iDCer *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_iDCer" forIndexPath:indexPath];
                [cell setModel:self.jkModel];
                return cell;
            }
            //个人信息部分
            case LookupResumeCellType_account:
            case LookupResumeCellType_live:
            case LookupResumeCellType_sex:
            case LookupResumeCellType_name:
            case LookupResumeCellType_jobArea:
            case LookupResumeCellType_jobType:
            case LookupResumeCellType_personnelCategories:
            case LookupResumeCellType_education:
            case LookupResumeCellType_school:
            case LookupResumeCellType_professional:
            case LookupResumeCellType_speciality:
            case LookupResumeCellType_height:{
                LookupResumeCell_Info *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_Info" forIndexPath:indexPath];
                cell.cellType = cellType;
                cell.isLookOther = self.isLookOther;
                [cell setModel:self.jkModel];
                return cell;
            }
            case LookupResumeCellType_lifePhotos:{  //生活照
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]init];
                    cell.backgroundColor = [UIColor XSJColor_newGray];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    self.allLifeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
                    
                    self.lifePhotoView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, 66)];
                    self.lifePhotoView_2 = [[UIView alloc]initWithFrame:CGRectMake(LIFEPHOTO_WITH, 0, SCREEN_WIDTH/5, 66)];
                    self.lifePhotoView_3 = [[UIView alloc]initWithFrame:CGRectMake(LIFEPHOTO_WITH*2, 0, SCREEN_WIDTH/5, 66)];
                    self.lifePhotoView_4 = [[UIView alloc]initWithFrame:CGRectMake(LIFEPHOTO_WITH*3, 0, SCREEN_WIDTH/5, 66)];
                    self.lifePhotoView_5 = [[UIView alloc]initWithFrame:CGRectMake(LIFEPHOTO_WITH*4, 0, SCREEN_WIDTH/5, 66)];
                    
                    [self.allLifeView addSubview:self.lifePhotoView_1];
                    [self.allLifeView addSubview:self.lifePhotoView_2];
                    [self.allLifeView addSubview:self.lifePhotoView_3];
                    [self.allLifeView addSubview:self.lifePhotoView_4];
                    [self.allLifeView addSubview:self.lifePhotoView_5];
                    [cell.contentView addSubview:self.allLifeView];
                    
                    self.lifePhoto_1 = [[UIImageView alloc]init];
                    self.lifePhoto_2 = [[UIImageView alloc]init];
                    self.lifePhoto_3 = [[UIImageView alloc]init];
                    self.lifePhoto_4 = [[UIImageView alloc]init];
                    self.lifePhoto_5 = [[UIImageView alloc]init];
                    
                    [self.lifePhoto_1 setCornerValue:3.0f];
                    [self.lifePhoto_2 setCornerValue:3.0f];
                    [self.lifePhoto_3 setCornerValue:3.0f];
                    [self.lifePhoto_4 setCornerValue:3.0f];
                    [self.lifePhoto_5 setCornerValue:3.0f];
                    
                    [self.lifePhotoView_1 addSubview:self.lifePhoto_1];
                    [self.lifePhotoView_2 addSubview:self.lifePhoto_2];
                    [self.lifePhotoView_3 addSubview:self.lifePhoto_3];
                    [self.lifePhotoView_4 addSubview:self.lifePhoto_4];
                    [self.lifePhotoView_5 addSubview:self.lifePhoto_5];
                    
                    self.lifePhoto_1.frame = CGRectMake((LIFEPHOTO_WITH-52)/2, (66-52)/2, 52, 52);
                    self.lifePhoto_2.frame = CGRectMake((LIFEPHOTO_WITH-52)/2, (66-52)/2, 52, 52);
                    self.lifePhoto_3.frame = CGRectMake((LIFEPHOTO_WITH-52)/2, (66-52)/2, 52, 52);
                    self.lifePhoto_4.frame = CGRectMake((LIFEPHOTO_WITH-52)/2, (66-52)/2, 52, 52);
                    self.lifePhoto_5.frame = CGRectMake((LIFEPHOTO_WITH-52)/2, (66-52)/2, 52, 52);
                    
                    if (!self.isLookOther) {
                        UIButton *btnAddLifePhoto = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, 52, 52)];
                        [btnAddLifePhoto setBackgroundImage:[UIImage imageNamed:@"v250_add_btm"] forState:UIControlStateNormal];
                        [btnAddLifePhoto setBackgroundImage:[UIImage imageNamed:@"v250_add_btmp"] forState:UIControlStateHighlighted];
                        [btnAddLifePhoto addTarget:self action:@selector(addLifePicture) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btnAddLifePhoto];
                        btnAddLifePhoto.hidden = YES;
                        btnAddLifePhoto.tag = 669;
                    }
                    [self lifePhotoUI];
                }
                //生活照添加手势
                [self.lifePhoto_1 setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture_1:)];
                [self.lifePhoto_1 addGestureRecognizer:tap_1];
                tap_1.delegate = self;
                
                [self.lifePhoto_2 setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture_2:)];
                [self.lifePhoto_2 addGestureRecognizer:tap_2];
                tap_2.delegate = self;
                
                [self.lifePhoto_3 setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap_3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture_3:)];
                [self.lifePhoto_3 addGestureRecognizer:tap_3];
                tap_3.delegate = self;
                
                [self.lifePhoto_4 setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap_4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture_4:)];
                [self.lifePhoto_4 addGestureRecognizer:tap_4];
                tap_4.delegate = self;
                
                [self.lifePhoto_5 setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap_5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture_5:)];
                [self.lifePhoto_5 addGestureRecognizer:tap_5];
                tap_5.delegate = self;
                
                NSArray *imgViewArr = [NSArray arrayWithObjects:self.lifePhoto_1,self.lifePhoto_2,self.lifePhoto_3,self.lifePhoto_4,self.lifePhoto_5,nil];
                NSMutableArray *lifePhotoArray = [[NSMutableArray alloc] initWithArray:self.jkModel.life_photo];
                NSUInteger count = lifePhotoArray.count <= 5 ? lifePhotoArray.count : 5;
                for (NSUInteger i = 0; i < count; i ++) {
                    NSDictionary* dic = [lifePhotoArray objectAtIndex:i];
                    UIImageView* tempImgV = [imgViewArr objectAtIndex:i];
                    NSString *lifePhoto1 = [dic valueForKey:@"life_photo"];
                    [tempImgV sd_setImageWithURL:[NSURL URLWithString:lifePhoto1] placeholderImage:[UIHelper getDefaultImage]];
                }
                if (!self.isLookOther) {
                    UIButton *btn = [cell viewWithTag:669];
                    btn.x = (LIFEPHOTO_WITH * count) + (LIFEPHOTO_WITH - 52)/2;
                    btn.hidden = (count >= 5);
                }
                return cell;
            }
            case LookupResumeCellType_selfAppraisa:{    //自我评价
                LookupResumeCell_selfApprisa *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_selfApprisa" forIndexPath:indexPath];
                [cell setModel:self.jkModel];
                return cell;
            }
            case LookupResumeCellType_studentId:    //学生证
            case LookupResumeCellType_healthId:{    //健康证
                LookupResumeCell_card *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_card" forIndexPath:indexPath];
                cell.cellType = cellType;
                [cell setModel:self.jkModel];
                return cell;
            }
            case LookupResumeCellType_previewStudentId: //预览-学生证
            case LookupResumeCellType_previewHealthId:{ //预览-健康证
                LookupResumeCell_PreviewCard *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupResumeCell_PreviewCard" forIndexPath:indexPath];
                cell.cellType = cellType;
                [cell setModel:self.jkModel];
                return cell;
            }
            default:
                break;
        }
    }
    return nil;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = [self getArrayInSection:section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LookupResumeSectionType sectionType = [[self.sectionArr objectAtIndex:section] integerValue];
    switch (sectionType) {
        case LookupResumeSectionType_healthId:  //健康证
        case LookupResumeSectionType_studentId: //学生证
        case LookupResumeSectionType_selfAppraisa:  //自我评价
        case LookupResumeSectionType_workExperience:    //工作经历
        case LookupResumeSectionType_lifePhotos:    //生活照
        case LookupResumeSectionType_personalInfo:  //个人信息
        case LookupResumeSectionType_applyTrends:   //兼职意向
        case LookupResumeSectionType_previewCards:{
            return 56.0f;
        }
        case LookupResumeSectionType_newLine:{//最先在线时间
            return 45;
        }
        case LookupResumeSectionType_workExperienceNoData:{ //工作经历 - 无数据
            return 85.0f;
        }
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self getArrayInSection:indexPath.section];
    id model = [array objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ResumeExperience class]]) {
        ResumeExperience *tmpModel = (ResumeExperience *)model;
        return tmpModel.cellHeight;
    }else{
        LookupResumeCellType cellType = [model integerValue];
        switch (cellType) {
            case LookupResumeCellType_resumeIntegrity:{ //简历完整度
                return 72.0f;
            }
            case LookupResumeCellType_previewWorkInfo:{ //预览-放鸽子etc
                return 90.0f;
            }
            case LookupResumeCellType_idCertification:{ //实名认证
                return 56.0f;
            }
            case LookupResumeCellType_jobType:{
                NSString *str = self.jkModel.subscribe_job_classify_str.length ? self.jkModel.subscribe_job_classify_str: @"-";
                CGFloat height = [str contentSizeWithWidth:SCREEN_WIDTH - 107 fontSize:15.0f].height + 12;
                height = (height <= 33) ? 33: height;
                return height;
            }
            case LookupResumeCellType_jobArea:{
                NSString *str = self.jkModel.subscribe_address_area_str.length ? self.jkModel.subscribe_address_area_str: @"-";
                CGFloat height = [str contentSizeWithWidth:SCREEN_WIDTH - 107 fontSize:15.0f].height + 12;
                height = (height <= 33) ? 33: height;
                return height;
            }
                //个人信息部分
            case LookupResumeCellType_account:
            case LookupResumeCellType_live:
            case LookupResumeCellType_sex:
            case LookupResumeCellType_name:
            case LookupResumeCellType_personnelCategories:
            case LookupResumeCellType_education:
            case LookupResumeCellType_school:
            case LookupResumeCellType_professional:
            case LookupResumeCellType_speciality:
            case LookupResumeCellType_height:{
                return 33.0f;
            }
            case LookupResumeCellType_lifePhotos:{  //生活照
                return 91.0f;
            }
            case LookupResumeCellType_selfAppraisa:{    //自我评价
                NSString *str = self.jkModel.desc.length ? self.jkModel.desc: @"独特的自我评价能加深雇主对你的印象";
                CGFloat height = [str contentSizeWithWidth:SCREEN_WIDTH - 32 fontSize:15.0f].height + 16;
                height = (height <= 37) ? 37: height;
                return height;
            }
            case LookupResumeCellType_studentId:    //学生证
            case LookupResumeCellType_healthId:{    //健康证
                return ((SCREEN_WIDTH - 32) * 200 / 343) + 61.0f - 16.0f;
            }
            case LookupResumeCellType_previewStudentId: //预览-学生证
            case LookupResumeCellType_previewHealthId:{ //预览-健康证
                return 53.0f;
            }
            default:
                break;
        }
    }
    return 33.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LookupResumeSectionType sectionType = [[self.sectionArr objectAtIndex:section] integerValue];
    switch (sectionType) {
        case LookupResumeSectionType_newLine:
        case LookupResumeSectionType_applyTrends:
        case LookupResumeSectionType_personalInfo:
        case LookupResumeSectionType_selfAppraisa:
        case LookupResumeSectionType_studentId:
        case LookupResumeSectionType_healthId:
        case LookupResumeSectionType_previewCards:
        case LookupResumeSectionType_lifePhotos:
        case LookupResumeSectionType_workExperience:
        {
            return [self getSetionViewWithType:sectionType];
        }
        case LookupResumeSectionType_workExperienceNoData:{
            return [self getWorkExpWithNodata:sectionType];
        }
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (!self.isLookOther) {
        NSArray *array = [self getArrayInSection:indexPath.section];
        id model = [array objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[NSNumber class]]) {
            LookupResumeCellType cellType = [model integerValue];
            switch (cellType) {
                case LookupResumeCellType_idCertification:{ //实名认证
                    if (self.jkModel.id_card_verify_status.integerValue == 1 || self.jkModel.id_card_verify_status.integerValue == 4) {
                        [self tureNameAuth];
                    }else if(self.jkModel.id_card_verify_status.integerValue == 2){
                        [UIHelper toast:@"认证中不能修改"];
                    }else if (self.jkModel.id_card_verify_status.integerValue == 3){
                        [UIHelper toast:@"已认证不能修改"];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}
#pragma mark - LookupResumeCell_competeDelegate
- (void)LookupResumeCell_compete:(NSInteger )tag{
    if (tag == 100) {
        NSNumber *isPublick = (self.jkModel.is_public.integerValue == 1) ? @0: @1;
        WEAKSELF
        [[XSJRequestHelper sharedInstance] postResumeOtherInfoWithDes:nil isPublick:isPublick block:^(id result) {
            if (result) {
                weakSelf.jkModel.is_public = isPublick;
                [weakSelf.tableView reloadData];
            }
        }];
    }
    if (tag == 200) {
               
        [GuideMaskView showTitle:@"提示" content:@"“简历公开”：允许雇主主动查看您的简历并与您联系.(推荐!)\n\n“简历保密”：雇主无法在人才库搜索到您的简历，个人联系方式保密。" cancel:nil commit:@"知道了" block:^(NSInteger result) {
            
        }];
        
    }
    
}

#pragma mark - LookupResumeHeaderViewDelegate
- (void)LookupResumeHeaderView:(LookupResumeHeaderView *)headerView actionType:(LookupResumeHeaderViewActionType)actionType{
    switch (actionType) {
        case LookupResumeHeaderViewActionType_compete:{
            [self completeBtn];
        }
            break;
        case LookupResumeHeaderViewActionType_break:{
            [self breakBtn];
        }
        default:
            break;
    }
}

#pragma mark - LookupResumeCell_previewCompeteDelegate
- (void)LookupResumeCell_previewCompete:(LookupResumeCell_previewCompete *)cell{
    [self completeBtn];
}

#pragma mark - 按钮事件****弃用
/** 打电话 */
- (void)phoneClick{
    if (self.isLookOther && [[UserData sharedInstance] getLoginType].integerValue == 1 && [[UserData sharedInstance] getEpModelFromHave].identity_mark.integerValue == 2) {
        [[XSJRequestHelper sharedInstance] callFreePhoneWithCalled:self.jkModel.contact.phone_num block:nil];
    }else{
        [[MKOpenUrlHelper sharedInstance] callWithPhone:self.jkModel.contact.phone_num];
    }
}

/** IM聊天 */
- (void)chatClick{
    if (self.jkModel.account_im_open_status) { // 有开通IM
        NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", self.jkModel.account_id];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
        request.isShowLoading = NO;
        WEAKSELF
        [request sendRequestToImServer:^(ResponseInfo* response) {
            if (response && [response success]) {
                int type = [[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe ? WDLoginType_Employer : WDLoginType_JianKe;
                [WDChatView_VC openPrivateChatOn:weakSelf accountId:weakSelf.jkModel.account_id.description withType:type jobTitle:weakSelf.jobTitle jobId:weakSelf.jobId.stringValue resumeId:weakSelf.jkModel.resume_id.description hideTabBar:NO];
            }
        }];
    } else {
        [UIHelper toast:@"对不起,该用户未开通IM功能"];
    }
}

//实名认证
- (void)tureNameAuth{
    IdentityCardAuth_VC* vc = [[IdentityCardAuth_VC alloc] init];
    vc.block = ^(BOOL result){
        [self getData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 生活照

//添加生活照
-(void)addLifePicture
{
    [self getLifePhotoImage];
}

//上传生活照
- (void)getLifePhotoImage{
    if (!self.menu) {
        self.menu = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
        self.menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
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

/** 图片选择器选择完图片代理方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *newImg = image;
    NSString *uploadImageName;
    uploadImageName = [NSString stringWithFormat:@"%@%@",@"shijianke_stuUploadPhoto",@".jpg"];
    //    [self saveImage:newImg WithName:uploadImageName];
    [self performSelector:@selector(selectPhotoPic:) withObject:newImg afterDelay:0.1];
}

//设置生活照显示
- (void)selectPhotoPic:(UIImage *)image{
    RequestInfo *lifePhoto = [[RequestInfo alloc]init];
    WEAKSELF
    [lifePhoto uploadImage:image andBlock:^( NSString *lifePhotoUrl) {
        [weakSelf uploadAgainGetData:lifePhotoUrl];
    }];
    
}

- (void)uploadAgainGetData:(NSString *)lifePhotoUrl{
    StuUploadPhotoPM *model = [[StuUploadPhotoPM alloc]init];
    model.photo_url = lifePhotoUrl;
    model.photo_type = @(1);
    NSString *content = [model getContent];
    
    content = [content stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuUploadPhoto" andContent:content];
    request.isShowLoading = YES;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            [weakSelf getData];
            [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
        }
    }];
}

//删除生活照
- (void)deletePhotoPicWithIndex:(NSInteger)index completeBlock:(MKBlock)block{
    NSDictionary* dic = [self.jkModel.life_photo objectAtIndex:index];
    NSString *lifePhotoID = [dic valueForKey:@"id"];
    NSString *content = [NSString stringWithFormat:@"life_photo_id:%@",lifePhotoID];
    
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuDeletePhoto" andContent:content];
    [UIHelper showLoading:YES withMessage:nil inView:self.view.window];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [UIHelper showLoading:NO withMessage:nil inView:nil];
        if (response && response.success) {
            [UIHelper toast:@"删除成功" inView:self.view.window];
            MKBlockExec(block, nil);
        }
    }];
}

#pragma mark - 图片放大
//点击放大图片显示
-(void)tapGesture_1:(UITapGestureRecognizer *)sender{
    if (self.lifePhoto_1) {
        [self showImgAtIndex:0];
    }
}
-(void)tapGesture_2:(UITapGestureRecognizer *)sender{
    if (self.lifePhoto_2) {
        [self showImgAtIndex:1];
    }
}
-(void)tapGesture_3:(UITapGestureRecognizer *)sender{
    if (self.lifePhoto_3) {
        [self showImgAtIndex:2];
    }
}
-(void)tapGesture_4:(UITapGestureRecognizer *)sender{
    if (self.lifePhoto_4) {
        [self showImgAtIndex:3];
    }
}
-(void)tapGesture_5:(UITapGestureRecognizer *)sender{
    if (self.lifePhoto_5) {
        [self showImgAtIndex:4];
    }
}

- (void)showImgAtIndex:(NSInteger)index{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSArray *viewArray = [self.viewArr filteredArrayUsingPredicate:pre];
    if (viewArray.count) {
        __block BOOL isNeedUpdate = NO;
        
        NSArray *array = [self.imgArr subarrayWithRange:NSMakeRange(0, viewArray.count)];
        showType type = self.isLookOther ? showType_default: showType_delete;
        XZImgPreviewView *preView = [XZImgPreviewView showViewWithArray:array beginWithIndex:index showType:type];
        WEAKSELF
        preView.deleteBlock = ^(XZImgPreviewView *pre, NSInteger currentIndex){
            [weakSelf deletePhotoPicWithIndex:currentIndex completeBlock:^(id result) {
                isNeedUpdate = YES;
                [pre deleteImgWithIndex:currentIndex];
                NSMutableArray *array = [self.jkModel.life_photo mutableCopy];
                [array removeObjectAtIndex:index];
                weakSelf.jkModel.life_photo = array;
                [weakSelf.tableView reloadData];
            }];
        };
        preView.dismissBlock = ^(id result){
            if (type == showType_delete && isNeedUpdate) {
                [weakSelf getData];
                [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
            }
        };
        [preView show];
    }

}

#pragma mark - lazy
- (LookupResumeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LookupResumeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 106.0f)];
        _headerView.backgroundColor = MKCOLOR_RGBA(39, 39, 39, 0.94);
    }
    return _headerView;
}


- (UIImagePickerController *)ipc{
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
        _ipc.allowsEditing = YES;
    }
    return _ipc;
}

#pragma mark - 业务方法

- (NSMutableArray *)getArrayInSection:(NSInteger)section{
    LookupResumeSectionType sectionType = [[self.sectionArr objectAtIndex:section] integerValue];
    switch (sectionType) {
        case LookupResumeSectionType_resumeIntegrity:
            return self.resumeArr;
        case LookupResumeSectionType_applyTrends:
            return self.jobTrendArr;
        case LookupResumeSectionType_idCertification:
            return self.idCerArr;
        case LookupResumeSectionType_personalInfo:
            return self.infoArr;
        case LookupResumeSectionType_lifePhotos:
            return self.lifePhotoArr;
        case LookupResumeSectionType_workExperience:
        case LookupResumeSectionType_workExperienceNoData:
            return self.workExperience;
        case LookupResumeSectionType_selfAppraisa:
            return self.selfApparisa;
        case LookupResumeSectionType_studentId:
            return self.studentIdArr;
        case LookupResumeSectionType_healthId:
            return self.healthIdArr;
        case LookupResumeSectionType_previewResume:
            return self.workHistoryArr;
        case LookupResumeSectionType_previewCards:
            return self.cardArr;
        case LookupResumeSectionType_newLine:
            return self.newlineArr;
        default:
            break;
    }
    return [NSMutableArray array];
}

- (UIView *)getSetionViewWithType:(LookupResumeSectionType)type{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    UILabel *lab = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_tGrayDeepTinge1] fontSize:17.0f];
    UILabel *lab1 = [UILabel labelWithText:@"" textColor:[UIColor XSJColor_tGrayDeepTinge1] fontSize:17.0f];
    lab1.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithTitle:nil bgColor:nil image:@"v324_edit_mode_icon" target:self sector:@selector(btnEditOnClick:)];
    btn.tag = type;
    btn.hidden = self.isLookOther;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = type;
    btn1.hidden = YES;
    [btn1 addTarget:self action:@selector(btnEditOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job_icon_push"]];
    imgView.hidden = YES;
    
    [view addSubview:lab];
    [view addSubview:btn];
    [view addSubview:lab1];
    [view addSubview:btn1];
    [view addSubview:imgView];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.centerY.equalTo(view);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-16);
        make.centerY.equalTo(view);
        make.width.height.equalTo(@28);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-16);
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-16);
        make.centerY.equalTo(view);
    }];
    
    switch (type) {
        case LookupResumeSectionType_newLine:{
            lab.text = @"最新在线时间";
        }
            break;
        case LookupResumeSectionType_applyTrends:{
            view.backgroundColor =  MKCOLOR_RGB(248, 249, 250);
            lab.text = @"兼职意向";
        }
            break;
        case LookupResumeSectionType_personalInfo:{
            lab.text = @"个人信息";
        }
            break;
        case LookupResumeSectionType_lifePhotos:{
            view.backgroundColor = [UIColor XSJColor_newGray];
            if (self.isLookOther) {
                lab.text = @"生活照";
            }else{
                lab1.hidden = NO;
                lab.hidden = YES;
                btn.hidden = YES;
                NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"生活照" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge1]}];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"(上传良好形象的生活照,提高兼职录取率)" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent2]}];
                [mutableAttStr appendAttributedString:attStr];
                lab1.attributedText = mutableAttStr;
            }
        }
            break;
        case LookupResumeSectionType_selfAppraisa:{
            view.backgroundColor = [UIColor XSJColor_newGray];
            lab.text = @"自我评价";
        }
            break;
        case LookupResumeSectionType_studentId:{
            lab.text = @"学生证";
        }
            break;
        case LookupResumeSectionType_healthId:{
            lab.text = @"健康证";
        }
            break;
        case LookupResumeSectionType_previewCards:{
            lab.text = @"证件信息";
        }
            break;
        case LookupResumeSectionType_workExperience:{
            lab.text = @"工作经历";
            if (self.isLookOther) {
                btn1.hidden = YES;
                imgView.hidden = YES;
            }else{
                btn1.hidden = NO;
                imgView.hidden = NO;
            }
            btn.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (UIView *)getWorkExpWithNodata:(LookupResumeSectionType)type{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    UILabel *lab = [UILabel labelWithText:@"工作经历" textColor:[UIColor XSJColor_tGrayDeepTinge1] fontSize:17.0f];
    UILabel *lab1 = [UILabel labelWithText:@"丰富的工作经历能提升简历质量" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:15.0f];
    
    UIButton *btn = [UIButton buttonWithTitle:nil bgColor:nil image:@"c324_post_icon_blue" target:self sector:@selector(btnEditOnClick:)];
    btn.tag = type;
    btn.hidden = self.isLookOther;
    
    [view addSubview:lab];
    [view addSubview:btn];
    [view addSubview:lab1];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(view).offset(16);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-16);
        make.centerY.equalTo(lab);
        make.width.height.equalTo(@28);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.top.equalTo(lab.mas_bottom).offset(8);
        make.right.equalTo(view).offset(-16);
    }];
    return view;
}

- (void)enterInterestJob{
    InterestJob_VC *vc = [[InterestJob_VC alloc] init];
    vc.isFromResume = YES;
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterSelfApparisa{
    EvaluationViewController *vc = [[EvaluationViewController alloc] init];
    vc.str = self.jkModel.desc;
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterStudentId{
    UploadCard_VC *vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_UploadCard_VC"];
    vc.photo_type = @(2);
    vc.block = ^(id result){
        [self getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterHeathlId{
    UploadCard_VC *vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_UploadCard_VC"];
    vc.photo_type = @(3);
    vc.block = ^(id result){
        [self getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnEditOnClick:(UIButton *)sender{
    switch (sender.tag) {
        case LookupResumeSectionType_applyTrends:{  //兼职意向
            [self enterInterestJob];
        }
            break;
        case LookupResumeSectionType_personalInfo:{ //个人信息
            [self editResume];
        }
            break;
        case LookupResumeSectionType_selfAppraisa:{ //自我评价
            [self enterSelfApparisa];
        }
            break;
        case LookupResumeSectionType_studentId:{    //学生证
            [self enterStudentId];
        }
            break;
        case LookupResumeSectionType_healthId:{ //健康证
            [self enterHeathlId];
        }
            break;
        case LookupResumeSectionType_workExperience:{   //工作经历
            [self enterWorkExperience];
        }
            break;
        case LookupResumeSectionType_workExperienceNoData:{ //工作经历-无数据
            [self enterPostWork];
        }
        default:
            break;
    }
}

//完工
- (void)completeBtn{
    WorkHistoryController *vc = [[WorkHistoryController alloc] init];
    vc.title = @"完工经历";
    vc.isFromResume = YES;
    vc.stu_work_history_type = @(1);
    [self.navigationController pushViewController:vc animated:YES];
}
//放鸽子
- (void)breakBtn{
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            WorkHistoryController *vc = [[WorkHistoryController alloc] init];
            vc.title = @"放鸽子经历";
            vc.isFromResume = YES;
            vc.stu_work_history_type = @(2);
            if (self.isLookOther) {
                vc.resume_id = self.resumeId;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

/** 编辑简历 */
- (void)editResume{
    
    EditResumeNew_VC *vc = [[EditResumeNew_VC alloc] init];
    vc.jkModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.jkModel]];
    WEAKSELF
    vc.block = ^(NSDictionary *dic){
        [weakSelf getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
        if (dic) {
            [weakSelf alertSureAccount:dic];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertSureAccount:(NSDictionary *)dic{
    NSString *telphone1 = dic[@"curr_account_telphone"];
    NSString *telphone2 = dic[@"curr_resume_telphone"];
    if (![telphone1 isEqualToString:telphone2]) {
        WEAKSELF
        [GuideMaskView showTitle:@"提示" content:@"您当前的联系方式与登录账号不一致,是否更改绑定账号" cancel:@"不用" commit:@"更换" block:^(NSInteger result) {
            if (result == 1) {
                ChangePhoneNum_VC* vc = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_changePhoneNumber"];
                [weakSelf.navigationController pushViewController:vc animated:YES];

            }
            
        }];
    }
}

- (void)previewResume{
    LookupResume_VC *vc = [[LookupResume_VC alloc] init];
    vc.title = @"预览简历";
    vc.isLookOther = YES;
    vc.otherJkModel = self.jkModel;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.isRootVC = YES;
    
    MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)backResumeVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enterWorkExperience{
    WorkExperienceList_VC *vc = [[WorkExperienceList_VC alloc] init];
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterPostWork{
    PostWorkExpe_VC *vc = [[PostWorkExpe_VC alloc] init];
    WEAKSELF
    vc.block = ^(id result){
        [weakSelf getData];
        [UserData sharedInstance].isRefreshTableViewWithMyInfo = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
