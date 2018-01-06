//
//  TwoScreenBase_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TwoScreenBase_VC.h"

@interface TwoScreenBase_VC ()<UIScrollViewDelegate>{
    CGFloat _btnHeight;     /*!< 顶部按钮高度 */
    CGFloat _layoutLineForLeft; /*!< 线离左边距离 */
}

@property (nonatomic, strong) UIView* viewBtnBg;    /*!< 顶部按钮背景 */
@property (nonatomic, strong) UIButton* btnLeft;    /*!< 左边按钮 */
@property (nonatomic, strong) UIButton* btnRight;   /*!< 右边按钮 */
@property (nonatomic, strong) UIView* viewBtnLine;  /*!< 按钮底部线 */
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView *leftView;     /*!< 左边View */
@property (nonatomic, strong) UIView* rightView;    /*!< 右边View */
@end

@implementation TwoScreenBase_VC

- (instancetype)init{
    ELog(@" TwoScreenBase_VC init");
    self = [super init];
    if (self) {
        _btnHeight = 36;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setBtnHeigth:(CGFloat)height{
    _btnHeight = height;
}

- (void)setLeftTitle:(NSString*)title{
    [self.btnLeft setTitle:title forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString*)title{
    [self.btnRight setTitle:title forState:UIControlStateNormal];
}

- (void)setLView:(UIView *)view{
    self.leftView = view;
    [self.scrollView addSubview:self.leftView];
    
    WEAKSELF
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.viewBtnBg.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.scrollView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)setRView:(UIView *)view{
    self.rightView = view;
    [self.scrollView addSubview:self.rightView];
    WEAKSELF
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.viewBtnBg.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.leftView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}



- (void)initTopWithLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle{
    self.viewBtnBg = [[UIView alloc] init];
    self.viewBtnBg.backgroundColor = [UIColor XSJColor_blackBase];
    [self.view addSubview:self.viewBtnBg];
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnLeft addTarget:self action:@selector(btnLeftOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLeft setTitleColor:MKCOLOR_RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
    [self.btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.btnLeft setTitle:leftTitle forState:UIControlStateNormal];
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight addTarget:self action:@selector(btnRightOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight setTitleColor:MKCOLOR_RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
    [self.btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.btnRight setTitle:rightTitle forState:UIControlStateNormal];
    
    self.viewBtnLine = [[UIView alloc] init];
    self.viewBtnLine.backgroundColor = [UIColor XSJColor_base];
    
    [self.viewBtnBg addSubview:self.btnLeft];
    [self.viewBtnBg addSubview:self.btnRight];
    [self.viewBtnBg addSubview:self.viewBtnLine];
    
    WEAKSELF
    [self.viewBtnBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0);
        make.height.mas_equalTo(_btnHeight);
    }];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewBtnBg.mas_left);
        make.top.equalTo(weakSelf.viewBtnBg.mas_top);
        make.bottom.equalTo(weakSelf.viewBtnBg.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.btnLeft.mas_right);
        make.right.equalTo(weakSelf.viewBtnBg.mas_right);
        make.top.equalTo(weakSelf.viewBtnBg.mas_top);
        make.bottom.equalTo(weakSelf.viewBtnBg.mas_bottom);
    }];
    [self.viewBtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewBtnBg.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.viewBtnBg.mas_bottom).offset(0);
        make.height.mas_equalTo(@3);
        make.width.mas_equalTo(weakSelf.btnLeft.mas_width);
    }];
    
    [self initScrollView];
    [self moveLineToLeft:YES];
}

/** 初始化 scrollView */
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _btnHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-_btnHeight)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-64-_btnHeight);
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor grayColor];
}

- (void)btnLeftOnclick:(UIButton*)sender{
    [self moveLineToLeft:YES];
}

- (void)btnRightOnclick:(UIButton*)sender{
    [self moveLineToLeft:NO];
}

- (void)moveLineToLeft:(BOOL)bLeft{
    if (bLeft) {
        self.btnLeft.selected = YES;
        self.btnRight.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        self.btnLeft.selected = NO;
        self.btnRight.selected = YES;
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

#pragma mark - ***** UIScrollView Delegate ******
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p = scrollView.contentOffset;
    
    if (p.x <= SCREEN_WIDTH/4) {
        self.btnLeft.selected = YES;
        self.btnRight.selected = NO;
    }else if (p.x >= SCREEN_WIDTH/4*3){
        self.btnLeft.selected = NO;
        self.btnRight.selected = YES;
    }
    
    _layoutLineForLeft = p.x/2;
    
    WEAKSELF
    [self.viewBtnLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewBtnBg.mas_left).with.offset(_layoutLineForLeft);
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
