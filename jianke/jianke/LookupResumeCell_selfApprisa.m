//
//  LookupResumeCell_selfApprisa.m
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "LookupResumeCell_selfApprisa.h"
#import "WDConst.h"

@interface LookupResumeCell_selfApprisa ()

@property (nonatomic, strong) UILabel *labContent;

@end

@implementation LookupResumeCell_selfApprisa

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor XSJColor_newGray];
    }
    return self;
}

- (void)setupViews{
    self.labContent = [UILabel labelWithText:nil textColor:[UIColor XSJColor_tGrayDeepTransparent48] fontSize:15.0f];
    self.labContent.numberOfLines = 0;
    [self.contentView addSubview:self.labContent];
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}

- (void)setModel:(JKModel *)model{
    if (model.desc.length) {
        self.labContent.text = model.desc;
    }else{
        self.labContent.text = @"独特的自我评价能加深雇主对你的印象";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
