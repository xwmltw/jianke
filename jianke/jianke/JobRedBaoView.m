//
//  JobRedBaoView.m
//  jianke
//
//  Created by yanqb on 2017/7/3.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobRedBaoView.h"
#import "WDConst.h"

@implementation JobRedBaoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"RedbaoNil" owner:nil options:nil].firstObject;
       
    }
    return self;
}
- (IBAction)cancelBtn:(UIButton *)sender {
    
    MKBlockExec(self.block,nil);
}

@end

@interface RedBaoAlert ()

@end
@implementation RedBaoAlert

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
        
        self.redBaoView = [[JobRedBaoView alloc]init];
        WEAKSELF
        self.redBaoView.block = ^(id result){
        
            [weakSelf dismiss];
        };
        self.redBaoView.labTitle.text = title;
        self.redBaoView.labContent.text = content;
        self.redBaoView.cancelLayout.constant = (40*SCREEN_HEIGHT)/667;
        [self addSubview:self.redBaoView];
        
        CGFloat height1 =(SCREEN_WIDTH/4)*4.5;
        [self.redBaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-40);
            make.left.equalTo(self).offset((SCREEN_WIDTH / 8));
            make.right.equalTo(self).offset(-(SCREEN_WIDTH / 8));
            make.height.equalTo(@(height1));
        }];
        
        
    }
    return self;
}
- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end


