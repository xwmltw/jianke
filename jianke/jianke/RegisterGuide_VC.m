//
//  RegisterGuide_VC.m
//  jianke
//
//  Created by yanqb on 2016/12/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "RegisterGuide_VC.h"
#import "JobClassifyInfoModel.h"
#import "DaySelectView.h"


@interface RegisterGuide_VC (){
    StuSubscribeModel* _ssModel;
    NSArray *_jobClassifierArray;
    NSMutableArray *_dayArray;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RegisterGuide_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(btnBeginOnClick)];
    [self createCloseBtn];
    [self creatDayArray];
    [self getData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)getData{
    NSNumber *cityId = [UserData sharedInstance].city.id ? [UserData sharedInstance].city.id : @(211);
    WEAKSELF
    NSString* content = [NSString stringWithFormat:@"\"city_id\":%@", cityId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryStuSubscribeConfig" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            _ssModel = [StuSubscribeModel objectWithKeyValues:response.content];
            _jobClassifierArray = _ssModel.job_classifier_list;
            [weakSelf setupViews:_jobClassifierArray];
        }
    }];
}

- (void)createCloseBtn{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 44, 44);
//    [backBtn setImage:[UIImage imageNamed:@"v3_public_close"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];;
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nevgativeSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceLeft.width = -16;
    self.navigationItem.leftBarButtonItems = @[nevgativeSpaceLeft,backItem];
}

- (void)setupViews:(NSArray *)classifyArr{
    [self.view removeAllSubviews];
    self.view.userInteractionEnabled = YES;
    CGFloat scrollViewH = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    UILabel *labTitle = [UILabel labelWithText:@"选择您的兼职意向，" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:28.0f];
    labTitle.numberOfLines = 0;
    UILabel *labSubTitle = [UILabel labelWithText:@"好工作主动来找您" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:16.0f];
    labSubTitle.numberOfLines = 0;
    
    UILabel *labNext = [UILabel labelWithText:@"2/2" textColor:[UIColor XSJColor_tGrayDeepTinge] fontSize:24.0f];
    labNext.backgroundColor = [UIColor XSJColor_tGrayDeepTransparent003];
    labNext.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"2/2" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTinge]}];
    [mutableAttStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]} range:NSRangeFromString(@"{1, 2}")];
    labNext.attributedText = mutableAttStr;
    [labNext setCornerValue:26.0f];
    
    UILabel *labTip = [UILabel labelWithText:@"最多可选5个" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    
    UIView *tagView = [[UIView alloc] init];
    CGFloat width = (SCREEN_WIDTH - 40) / 3;
    CGFloat height = 44;
    UIButton *button = nil;
    NSInteger count = classifyArr.count;
    NSInteger row;
    NSInteger column;
    JobClassifyInfoModel *tagModel;
    CGFloat tagViewH = 0;
    for (NSInteger index = 0; index < count; index++) {
        tagModel = classifyArr[index];
        column = index % 3;
        row = index / 3;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:tagModel.job_classfier_name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        button.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        [button setCornerValue:2.0f];
        [button setBorderWidth:1.0f andColor:[UIColor XSJColor_newWhite]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.frame = CGRectMake(16 + ((width + 4) * column), ((height + 4) * row), width, height);
        [button addTarget:self action:@selector(tagBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagViewH = (height + 4) * row + 44;
        [tagView addSubview:button];
    }
    
//    UIButton *btnBegin = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnBegin setTitle:@"开启兼职之旅" forState:UIControlStateNormal];
//    [btnBegin addTarget:self action:@selector(btnBeginOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    btnBegin.titleLabel.font = [UIFont systemFontOfSize:17.0f];
//    [btnBegin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnBegin.backgroundColor = [UIColor XSJColor_base];
//    [btnBegin setCornerValue:2.0f];
    [_scrollView addSubview:labNext];
    [_scrollView addSubview:labTitle];
    [_scrollView addSubview:labSubTitle];
    [_scrollView addSubview:labTip];
    [_scrollView addSubview:tagView];
//    [_scrollView addSubview:btnBegin];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView).offset(40);
        make.left.equalTo(_scrollView).offset(16);
        make.width.equalTo(@(SCREEN_WIDTH - 16 - 68));
    }];
    scrollViewH += 40;
    scrollViewH += ([labTitle contentSizeWithWidth:SCREEN_WIDTH - 16 - 68].height);
    
    [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(8);
        make.left.equalTo(_scrollView).offset(16);
        make.width.equalTo(@(SCREEN_WIDTH - 16 - 68));
    }];
    scrollViewH += 8;
    scrollViewH += ([labSubTitle contentSizeWithWidth:SCREEN_WIDTH - 16 - 68].height);
    
    [labNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle);
        make.right.equalTo(self.view).offset(-16);
        make.height.with.equalTo(@52);
    }];
    
    [labTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labSubTitle.mas_bottom).offset(32);
        make.left.equalTo(labSubTitle);
    }];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTip.mas_bottom).offset(8);
        make.left.equalTo(_scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(tagViewH));
        make.bottom.equalTo(_scrollView).offset(-12);
    }];
    scrollViewH += (41 + tagViewH + 12 + 17);
    
//    [btnBegin mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tagView.mas_bottom).offset(20);
//        make.left.equalTo(_scrollView).offset(16);
//        make.width.equalTo(@(SCREEN_WIDTH - 32));
//        make.height.equalTo(@44);
//        make.bottom.equalTo(_scrollView).offset(-12);
//    }];
//    scrollViewH += (20 + 44 + 12);
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewH);
}

- (void)creatDayArray{
    _dayArray = [[NSMutableArray alloc] init];
    int bit = 0;
    
    for (NSInteger i = 0; i < 32; i++){
        DaySelectModel* model = [[DaySelectModel alloc] init];
        model.isSelect = YES;
        NSInteger row = i % 4;
        NSInteger list = i / 4;
        
        if (row == 0) {
            model.isEnable = NO;
            if (list == 1) {
                model.title = @"一";
            }else if (list == 2){
                model.title = @"二";
            }else if (list == 3){
                model.title = @"三";
            }else if (list == 4){
                model.title = @"四";
            }else if (list == 5){
                model.title = @"五";
            }else if (list == 6){
                model.title = @"六";
            }else if (list == 7){
                model.title = @"日";
            }
        }else if (list == 0){
            model.isEnable = NO;
            if (row == 1) {
                model.title = @"上午";
            } if (row == 2) {
                model.title = @"下午";
            } if (row == 3) {
                model.title = @"晚上";
            }
        }else{
            model.value = 1 << bit;
            model.isEnable = YES;
            bit++;
        }
        
        [_dayArray addObject:model];
    }
}

- (void)tagBtnOnClick:(UIButton *)sender{
    if (!sender.selected) {
        NSPredicate *precidate = [NSPredicate predicateWithFormat:@"isSelect=YES"];
        NSArray *array = [_jobClassifierArray filteredArrayUsingPredicate:precidate];
        if (array.count >= 5) {
            [UIHelper toast:@"已选5个，不能再多咯~"];
            return;
        }
    }
    sender.selected = !sender.selected;
    JobClassifyInfoModel* model = [_jobClassifierArray objectAtIndex:sender.tag];
    model.isSelect = sender.selected;
    if (sender.selected) {
        [sender setBorderColor:[UIColor XSJColor_base]];
        [sender setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
        [sender setBackgroundColor:MKCOLOR_RGBA(0, 188, 212, 0.03)];
    }else{
        [sender setBorderColor:[UIColor XSJColor_newWhite]];
        [sender setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        [sender setBackgroundColor:MKCOLOR_RGBA(34, 58, 80, 0.03)];
    }
}

//- (void)ignoreAction{
//    MKBlockExec(self.block, @"超级无敌霹雳金刚大跳转！");
//}

- (void)btnBeginOnClick{
    
    NSMutableArray* jcIdArray = [[NSMutableArray alloc] init];
    for (JobClassifyInfoModel* model in _jobClassifierArray) {
        if (model.isSelect) {
            [jcIdArray addObject:model.job_classfier_id.stringValue];
        }
    }
    
    if (!jcIdArray.count) {
        [UIHelper toast:@"请选择您的兼职意向"];
//        MKBlockExec(self.block, @"超级无敌霹雳金刚大跳转！");
        return;
    }

    long workTime = 0;
    for (DaySelectModel *model in _dayArray) {
        if (model.isSelect) {
            workTime += model.value;
        }
    }
    
    UpdateStuSubscribeModel* usModel = [[UpdateStuSubscribeModel alloc] init];
    usModel.work_time = workTime;
    usModel.job_classify_id_list = jcIdArray;
//    usModel.city_id = ([UserData sharedInstance].city.id) ? [UserData sharedInstance].city.id: self.city_id;
    
    NSString* content = [usModel getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_updateStuSubscribeConfig" andContent:content];
    request.isShowLoading = YES;
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        MKBlockExec(self.block, self);
        
//        if (!self.isLogin) {
//            [WDNotificationCenter postNotificationName:PerfectResumeAlertViewNotification object:nil];
//        }
        
    }];
}

- (void)dismissVC{
    MKBlockExec(self.block, @"超级无敌霹雳金刚大跳转！");
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
