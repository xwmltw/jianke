//
//  JobRedBaoSuccessView.m
//  jianke
//
//  Created by yanqb on 2017/7/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobRedBaoSuccessView.h"
#import "WDConst.h"

typedef NS_ENUM(NSInteger , RedBaoClickOnBtn) {
    RedBaoBtn_cancel = 1,
    RedBaoBtn_share,
    RedBaoBtn_rules,

};

@implementation JobRedBaoSuccessView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"RedBaoSuccess" owner:nil options:nil].firstObject;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"活动细则"];
        NSDictionary * dict1 = @{NSForegroundColorAttributeName:MKCOLOR_RGB(252, 231, 167), NSUnderlineStyleAttributeName:@"1"};
        [str addAttributes:dict1 range:NSMakeRange(0, 4)];
        [self.DetailRule setAttributedTitle:str forState:UIControlStateNormal];
    }
    return self;
}
- (IBAction)clickOnBtn:(UIButton *)sender {
    MKBlockExec(self.block, sender);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface RedBaoSuccessView ()
@property (nonatomic, strong)JobRedBaoSuccessView *redBaoSuccessView;

@end

@implementation RedBaoSuccessView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content money:(NSString *)money block:(MKBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
        
        self.redBaoSuccessView = [[JobRedBaoSuccessView alloc]init];
        self.redBaoSuccessView.labMoney.text = money;
        self.redBaoSuccessView.labTitle.text = title;
        self.redBaoSuccessView.labContent.text = content;
        self.redBaoSuccessView.block = block;
        self.redBaoSuccessView.layout0.constant = (10*SCREEN_HEIGHT)/667;
        self.redBaoSuccessView.layout1.constant = (16*SCREEN_HEIGHT)/667;
        self.redBaoSuccessView.layout2.constant = (20*SCREEN_HEIGHT)/667;
        self.redBaoSuccessView.layout3.constant = (20*SCREEN_HEIGHT)/667;
        self.redBaoSuccessView.layout4.constant = (25*SCREEN_HEIGHT)/667;
        [self addSubview:self.redBaoSuccessView];
        
        CGFloat height1 =(SCREEN_WIDTH/4)*5;
        [self.redBaoSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-50);
            make.left.equalTo(self).offset((SCREEN_WIDTH / 8));
            make.right.equalTo(self).offset(-(SCREEN_WIDTH / 8));
            make.height.equalTo(@(height1));
            
        }];
        
    }
    return self;
}

@end
