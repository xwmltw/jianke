//
//  LookupResumeHeaderView.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeHeaderView.h"
#import "WDConst.h"
#import "NSString+XZExtension.h"
#import "XZImgPreviewView.h"

@interface LookupResumeHeaderView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgStatus;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labSex;
@property (nonatomic, strong) UILabel *labAge;
@property (nonatomic, strong) UILabel *labArea;
@property (nonatomic, strong) UIButton *btnCompete;
@property (nonatomic, strong) UIButton *btnLate;
@property (nonatomic, strong) UIButton *btnImgView;

@end

@implementation LookupResumeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.imgView = [[UIImageView alloc] initWithImage:[UIHelper getDefaultHead]];
    [self.imgView setUserInteractionEnabled:YES];
    [self.imgView setCornerValue:30.0f];
    
    self.btnImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnImgView addTarget:self action:@selector(btnImgViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.labName = [UILabel labelWithText:nil textColor:[UIColor whiteColor] fontSize:24.0f];
    self.labSex = [UILabel labelWithText:nil textColor:[UIColor whiteColor] fontSize:14.0f];
    self.labAge = [UILabel labelWithText:nil textColor:[UIColor whiteColor] fontSize:14.0f];
    self.labArea = [UILabel labelWithText:nil textColor:[UIColor whiteColor] fontSize:14.0f];
    self.imgStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_service_vertify"]];
    
    UIButton *btnLeft = [UIButton buttonWithTitle:@"0次完工" bgColor:MKCOLOR_RGB(77, 96, 114) image:nil target:self sector:@selector(btnOnClick:)];
    btnLeft.tag = LookupResumeHeaderViewActionType_compete;
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnLeft setCornerValue:14];
    btnLeft.hidden = YES;
    self.btnCompete = btnLeft;
    
    UIButton *btnRight = [UIButton buttonWithTitle:@"0次放鸽子" bgColor:MKCOLOR_RGB(77, 96, 114) image:nil target:self sector:@selector(btnOnClick:)];
    btnRight.tag = LookupResumeHeaderViewActionType_break;
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnRight setCornerValue:14];
    btnRight.hidden = YES;
    self.btnLate = btnRight;
    
    [self addSubview:self.imgView];
    [self addSubview:self.btnImgView];
    [self addSubview:self.labName];
    [self addSubview:self.labSex];
    [self addSubview:self.labAge];
    [self addSubview:self.labArea];
    [self addSubview:self.imgStatus];
    [self addSubview:self.btnCompete];
    [self addSubview:self.btnLate];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    
    [self.btnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgView);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(16);
    }];
    
    [self.imgStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labName);
        make.left.equalTo(self.labName.mas_right).offset(6);
    }];
    
    [self.labSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(16);
    }];
    
    [self.labAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labSex);
        make.left.equalTo(self.labSex.mas_right).offset(25);
    }];
    
    [self.labArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labSex);
        make.left.equalTo(self.labAge.mas_right).offset(25);
    }];
    
    [self.btnLate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@28);
    }];
    [self.btnCompete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.btnLate.mas_left).offset(-16);
        make.height.equalTo(@28);
    }];
}

- (void)setModel:(JKModel *)model isLookOther:(BOOL)isLookOther{
    [self setLookOtherHidden:isLookOther];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.profile_url]] placeholderImage:[UIHelper getDefaultHead]];
    self.labName.text = (model.true_name.length) ? model.true_name: @"";
    self.imgStatus.hidden = (model.id_card_verify_status.integerValue != 3);
    if (!isLookOther) {
        self.imgStatus.hidden = YES;
    }
    self.labSex.text = (model.sex.integerValue) ? @"男": @"女";
    if (model.age) {
        self.labAge.text = [NSString stringWithFormat:@"%@岁", model.age.description];
    }else{
        self.labAge.text = @"-";
    }
    if (model.city_name.length) {
        if (model.address_area_name.length) {
            self.labArea.text = [NSString stringWithFormat:@"%@%@", model.city_name, model.address_area_name];
        }else{
            self.labArea.text = model.city_name;
        }
    }else{
        self.labArea.hidden = YES;
    }
    // 完工次数
    [self.btnCompete setTitle:[NSString stringWithFormat:@"  %@ 次完工  ",[model.work_experice_count description]] forState:UIControlStateNormal];
    
    // 放鸽子数值
    [self.btnLate setTitle:[NSString stringWithFormat:@"  %@ 次放鸽子  ",[model.break_promise_count description]] forState:UIControlStateNormal];
}

- (void)setLookOtherHidden:(BOOL)isHidden{
    self.btnCompete.hidden = isHidden;
    self.btnLate.hidden = isHidden;
    
    self.labName.hidden = !isHidden;
    self.imgStatus.hidden = !isHidden;
    self.labSex.hidden = !isHidden;
    self.labAge.hidden = !isHidden;
    self.labArea.hidden = !isHidden;
}

- (void)btnImgViewOnClick:(UIButton *)sender{
    [XZImgPreviewView showViewWithArray:@[self.imgView] beginWithIndex:0];
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(LookupResumeHeaderView:actionType:)]) {
        [self.delegate LookupResumeHeaderView:self actionType:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
