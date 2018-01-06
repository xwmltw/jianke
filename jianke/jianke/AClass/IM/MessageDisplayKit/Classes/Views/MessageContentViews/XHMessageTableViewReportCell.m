//
//  XHMessageTableViewReportCell.m
//  jianke
//
//  Created by fire on 15/10/29.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "XHMessageTableViewReportCell.h"
#import "Masonry.h"
#import "WdMessage.h"
#import "ImMessage.h"
#import "DateTools.h"
#import "ImConst.h"
#import "UIColor+Extension.h"

@interface XHMessageTableViewReportCell()

@property (nonatomic, weak) UILabel *reportLabel;

@end


@implementation XHMessageTableViewReportCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reportCell = @"reportCell";
    
    XHMessageTableViewReportCell *cell = [tableView dequeueReusableCellWithIdentifier:reportCell];
    
    if (!cell) {
        cell = [[XHMessageTableViewReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reportCell];
    }
    
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}


- (void)setup
{
//    self.contentView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    self.contentView.backgroundColor = [UIColor XSJColor_grayDeep];

    UILabel *reportLabel = [[UILabel alloc] init];
    reportLabel.backgroundColor = MKCOLOR_RGB(212, 212, 212);
    reportLabel.layer.cornerRadius = 2;
    reportLabel.clipsToBounds = YES;
    reportLabel.textColor = [UIColor whiteColor];
    reportLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:reportLabel];
    self.reportLabel = reportLabel;
    
    WEAKSELF
    [reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.height.mas_equalTo(@(21));
        make.center.equalTo(weakSelf.contentView);
    }];    
}


- (void)setMessage:(WdMessage *)message
{
    _message = message;
    
    NSString *reportStr = [NSString stringWithFormat:@"  %@  ", ((RCTextMessage *)message.rcMsg.content).content];
    self.reportLabel.text = reportStr;
}


@end
