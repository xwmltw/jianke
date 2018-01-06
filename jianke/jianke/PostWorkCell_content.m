//
//  PostWorkCell_content.m
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "PostWorkCell_content.h"
#import "UIPlaceHolderTextView.h"

@interface PostWorkCell_content ()

@property (nonatomic, weak) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) UILabel *labTip;

@end

@implementation PostWorkCell_content

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    UILabel *lab = [UILabel labelWithText:@"工作内容" textColor:[UIColor XSJColor_tGrayHistoyTransparent64] fontSize:12.0f];
    
    self.labTip = [UILabel labelWithText:@"还能输入60个字" textColor:[UIColor XSJColor_tGrayDeepTransparent32] fontSize:12.0f];
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] init];
    textView.placeholder = @"输入您的工作内容，限60个字";
    textView.placeholderColor = [UIColor XSJColor_tGrayDeepTransparent32];
    textView.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    textView.backgroundColor = [UIColor XSJColor_newGray];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.maxLength = 60;
    WEAKSELF
    textView.block = ^(NSString *str){
        self.labTip.attributedText = [weakSelf getLeftInputNum];
        weakSelf.model.job_content = str;
    };
    self.textView = textView;
    
    [self.contentView addSubview:lab];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.labTip];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(16);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.equalTo(@140);
    }];
    
    [self.labTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}

- (NSMutableAttributedString *)getLeftInputNum{
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"还能输入" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]}];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", 60 - self.textView.text.length] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: [UIColor XSJColor_middelRed]}];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:@"个字" attributes:@{NSForegroundColorAttributeName: [UIColor XSJColor_tGrayDeepTransparent32]}];
    [mutableAttStr appendAttributedString:attStr];
    [mutableAttStr appendAttributedString:attStr1];
    return mutableAttStr;
}

- (void)setModel:(ResumeExperienceModel *)model{
    _model = model;
    self.textView.text = (model.job_content.length) ? model.job_content: nil;
    self.labTip.attributedText = [self getLeftInputNum];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
