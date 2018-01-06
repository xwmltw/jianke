//
//  MKSlideBase_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKSlideBase_VC.h"

@interface MKSlideBase_VC ()<UIScrollViewDelegate>{

    CGFloat     _layoutLineForLeft;     /*!< 线离左边距离 */
    NSInteger   _currentSelectBtnIndex; /*!< 当前选中的btn index */

}
@property (nonatomic, strong) NSArray *titleArray;              /*!< 按钮标题列表 */
@property (nonatomic, strong) NSMutableArray *titleBtnArray;

@property (nonatomic, assign) CGFloat scorllViewH;              /*!< View height */
@property (nonatomic, strong) UIScrollView *topScrollView;      /*!< 顶部按钮scrollView */
@property (nonatomic, weak) UIButton *currentBtn;               /*!< 当前选中按钮 */
@property (nonatomic, strong) UIScrollView *mainScrollView;     /*!< scorll View */


@end

@implementation MKSlideBase_VC

- (instancetype)init{
    if (self = [super init]) {
        _slideVCType = MKSlideVCType_scrollView;
        _maxShowBtnCount = 4;
        _topBtnHeight = 44;
        _scorllViewH = SCREEN_HEIGHT-64-_topBtnHeight;
        _currentSelectBtnIndex = 0;
        _titleBtnArray = [[NSMutableArray alloc] init];
        _vcArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - ***** public method ******
- (void)initUIWithTitleArray:(NSArray *)titleArray{
    if (!titleArray || titleArray.count == 0) {
        return;
    }
    self.titleArray = [[NSArray alloc] initWithArray:titleArray];
    
    [self initTopView];
    
    if (self.slideVCType == MKSlideVCType_scrollView) {
        [self.view addSubview:self.mainScrollView];
    }else if (self.slideVCType == MKSlideVCType_singleVC){
        [self.view addSubview:self.mainSingleView];
    }
    
    [self updateSelectBtn];
}

/** 初始化 self.vcArray 后调用此方法 */
- (void)initVcArrayOverAndShowFirstVCWithIndex:(NSInteger)index{
    if (self.vcArray.count == 0) {
        NSAssert(self.vcArray.count > 0, @"vcArray 必须大于0");
        return;
    }
    
    if (index < 0 || index >= self.titleBtnArray.count) {
        index = 0;
    }
    _currentSelectBtnIndex = index;
    
    if (self.slideVCType == MKSlideVCType_scrollView) {
        for (NSInteger i = 0; i < _titleBtnArray.count; i++) {
            if (self.vcArray.count > i) {
                UIViewController *vc = [self.vcArray objectAtIndex:i];
                [self addChildViewController:vc];
                vc.view.frame = CGRectMake(self.view.width*i, 0, self.view.width, self.scorllViewH);
                [self.mainScrollView addSubview:vc.view];
            }
        }
        [self updateSelectBtn_scrollView];
    }
}

- (NSInteger)getCurrentSelectBtnIndex{
    return _currentSelectBtnIndex;
}

- (void)setSelectVcWithIndex:(NSInteger)index{    /*!< 设置显示的 vc */
    if (index < self.titleBtnArray.count) {
        _currentSelectBtnIndex = index;
        [self updateSelectBtn];
    }
}

- (void)setBtnTitle:(NSString *)title withIndex:(NSInteger)index{
    if (index < self.titleBtnArray.count) {
        UIButton *btn = [self.titleBtnArray objectAtIndex:index];
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

/** 点击 title button */
- (void)btnOnclick:(UIButton *)sender{
    _currentSelectBtnIndex = sender.tag;
    [self updateSelectBtn];
}

- (void)scrollViewDidEventWithScroll:(UIScrollView *)scrollView{
    //重写此方法调用 自定义 事件
}


#pragma mark - ***** privately method ******
#pragma mark - ***** 初始化顶部按钮列表 ******
- (void)initTopView{
    [self.view addSubview:self.topBtnBgView];
    
    [self.topBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(_topBtnHeight);
    }];

    [self.topBtnBgView addSubview:self.topScrollView];
    
    
    CGFloat topSVWidth;       //top scrollView width
    if (_titleArray.count <= _maxShowBtnCount) {
        _topBtnWidth = self.view.width/self.titleArray.count;
        topSVWidth = self.view.width;
    }else{
        _topBtnWidth = self.view.width/_maxShowBtnCount;
        topSVWidth = _topBtnWidth * _titleArray.count;
    }
    self.topScrollView.contentSize = CGSizeMake(topSVWidth, _topBtnHeight);

    [self createHeadBtnListWithTitleArray:self.titleArray];
    
    [self creatBtnLine];
}

- (void)createHeadBtnListWithTitleArray:(NSArray<NSString *> *)titleArray{
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSString *title = [titleArray objectAtIndex:i];
        UIButton *btn = [self createHeadBtnWithTitle:title];
        btn.tag = i;
        btn.frame = CGRectMake(_topBtnWidth*i, 0, _topBtnWidth, _topBtnHeight);
        [self.topScrollView addSubview:btn];
        [self.titleBtnArray addObject:btn];
    }
}

- (UIButton *)createHeadBtnWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:self.topBtnNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.topBtnSelectColor forState:UIControlStateSelected];
    [btn setTitleColor:self.topBtnSelectColor forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)creatBtnLine{
    [self.topBtnBgView addSubview:self.viewBtnLine];
    
    [self.viewBtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.topBtnBgView);
        make.height.mas_equalTo(@3);
        make.width.mas_equalTo(_topBtnWidth);
    }];
}

/** 初始话选择按钮 */
- (void)updateSelectBtn{
    if (self.slideVCType == MKSlideVCType_singleVC) {
        [self updateSelectBtn_singleVC];
    }else if (self.slideVCType == MKSlideVCType_scrollView){
        [self updateSelectBtn_scrollView];
    }
}


#pragma mark - ***** init viewController ******


/** MKSlideVCType_scrollView */
- (void)updateSelectBtn_scrollView{
    if (self.currentBtn) {
        self.currentBtn.selected = NO;
    }
    self.currentBtn = _titleBtnArray[_currentSelectBtnIndex];
    self.currentBtn.selected = YES;
    [self.mainScrollView setContentOffset:CGPointMake(self.view.width*_currentSelectBtnIndex, 0) animated:YES];
}

/** MKSlideVCType_singleVC */
- (void)updateSelectBtn_singleVC{
    if (self.currentBtn) {
        self.currentBtn.selected = NO;
    }
    self.currentBtn = _titleBtnArray[_currentSelectBtnIndex];
    self.currentBtn.selected = YES;
    
    if (_currentSelectBtnIndex <= 1) {
        [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (_currentSelectBtnIndex > 1 && _currentSelectBtnIndex <= _titleBtnArray.count-3){
        [self.topScrollView setContentOffset:CGPointMake(_topBtnWidth*(_currentSelectBtnIndex-1), 0) animated:YES];
    }else{
        CGFloat offset = self.topScrollView.contentSize.width - self.topScrollView.bounds.size.width;
        [self.topScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
    if (_currentSelectBtnIndex <= 1) {  //前两个
        _layoutLineForLeft = _topBtnWidth * _currentSelectBtnIndex;
    }else if (_currentSelectBtnIndex == _titleBtnArray.count - 1){   //最后一个
        _layoutLineForLeft = _titleBtnArray.count > 3 ? _topBtnWidth*3 : _topBtnWidth*(_titleBtnArray.count-1);
    }else if (_currentSelectBtnIndex == _titleBtnArray.count - 2){   //倒数第二个
        _layoutLineForLeft = _topBtnWidth*2;
    }else{
        _layoutLineForLeft = _topBtnWidth;
    }
    
    [self.viewBtnLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBtnBgView.mas_left).offset(_layoutLineForLeft);
    }];
}

#pragma mark - ***** UIScrollView Delegate ******
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 101) {
        CGPoint p = scrollView.contentOffset;

        NSInteger showBtnCount = self.titleBtnArray.count > _maxShowBtnCount ? _maxShowBtnCount : self.titleBtnArray.count;

        
        //控制 按钮条
        if (p.x <= self.view.width) {
            _layoutLineForLeft = p.x/showBtnCount;
        }else if (p.x > self.view.width * (_titleBtnArray.count-showBtnCount+1)){
            _layoutLineForLeft = (p.x - self.view.width * (_titleBtnArray.count - showBtnCount))/showBtnCount;
        }else{
            _layoutLineForLeft = self.view.width/showBtnCount;
        }
        
        [self.viewBtnLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topBtnBgView.mas_left).offset(_layoutLineForLeft);
        }];
        

        //滚动 topScrollView
        if (p.x >= self.view.width ) {
            if (p.x > self.view.width * (_titleBtnArray.count - showBtnCount + 1)) {
                [self.topScrollView setContentOffset:CGPointMake(self.topScrollView.contentSize.width-self.view.width, 0)];
            }else{
                [self.topScrollView setContentOffset:CGPointMake((p.x-self.view.width)/showBtnCount, 0)];
            }
        }
        
        [self scrollViewDidEventWithScroll:scrollView];
        NSInteger index = (NSInteger)round(p.x/self.view.width);
        if (index == _currentSelectBtnIndex) {
            return;
        }
        
        //设置选中按钮
        _currentSelectBtnIndex = index;
        if (self.currentBtn) {
            self.currentBtn.selected = NO;
        }
        self.currentBtn = _titleBtnArray[_currentSelectBtnIndex];
        self.currentBtn.selected = YES;
    }
}





#pragma mark - ***** lazy ******
- (UIView *)topBtnBgView{
    if (!_topBtnBgView) {
        _topBtnBgView = [[UIView alloc] init];
        _topBtnBgView.backgroundColor = [UIColor XSJColor_blackBase];
    }
    return _topBtnBgView;
}

- (UIView *)viewBtnLine{
    if (!_viewBtnLine) {
        _viewBtnLine = [[UIView alloc] init];
        _viewBtnLine.backgroundColor = [UIColor XSJColor_base];
    }
    return _viewBtnLine;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topBtnHeight, self.view.width, _scorllViewH)];
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.contentSize = CGSizeMake(self.view.width*_titleBtnArray.count, _scorllViewH);
        _mainScrollView.backgroundColor = [UIColor grayColor];
        _mainScrollView.tag = 101;
    }
    return _mainScrollView;
}

- (UIView *)mainSingleView{
    if (!_mainSingleView) {
        _mainSingleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topBtnHeight, self.view.width, _scorllViewH)];
        _mainSingleView.backgroundColor = [UIColor XSJColor_grayTinge];
    }
    return _mainSingleView;
}


- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _topBtnHeight)];
        _topScrollView.pagingEnabled = NO;
        _topScrollView.bounces = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.backgroundColor = [UIColor clearColor];
    }
    return _topScrollView;
}

- (UIColor *)topBtnNormalColor{
    if (!_topBtnNormalColor) {
        _topBtnNormalColor = MKCOLOR_RGBA(255, 255, 255, 0.7);
    }
    return _topBtnNormalColor;
}

- (UIColor *)topBtnSelectColor{
    if (!_topBtnSelectColor) {
        _topBtnSelectColor = [UIColor whiteColor];;
    }
    return _topBtnSelectColor;
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
