//
//  JobSearchEpModel_Cell.m
//  jianke
//
//  Created by 徐智 on 2017/5/18.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobSearchEpModel_Cell.h"
#import "GetEnterpriseModel.h"
#import "WDConst.h"
#import "NSString+XZExtension.h"

@interface JobSearchEpModel_Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;



@end

@implementation JobSearchEpModel_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerValue:26.0f];
}

- (void)setModel:(EntInfoModel *)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.item >= 10) {
        self.imgView.image = [UIImage imageNamed:@"v323_joblist_more"];
    }else{
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringNoneNullFromValue:model.profile_url]] placeholderImage:[UIHelper getDefaultHead]];
    }
}

@end
