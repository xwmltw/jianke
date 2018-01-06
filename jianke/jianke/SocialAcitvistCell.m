//
//  SocialAcitvistCell.m
//  jianke
//
//  Created by 时现 on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SocialAcitvistCell.h"
#import "WDConst.h"
#import "SociaAcitvistModel.h"


#define HUISE MKCOLOR_RGB(229, 229, 229)
#define LVSE  MKCOLOR_RGB(158, 233, 143)
#define HUISEZITI  MKCOLOR_RGB(159, 159, 159)

@interface SocialAcitvistCell()
{
    SociaAcitvistModel *_saModel;
    BOOL _isApply;
    NSIndexPath *_indexPath;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel     *labName;//标题
@property (weak, nonatomic) IBOutlet UILabel     *labSalary;//薪水
//进度条View
@property (weak, nonatomic) IBOutlet UIView      *ApplyView;
@property (weak, nonatomic) IBOutlet UIView      *HireView;
@property (weak, nonatomic) IBOutlet UIView      *FinishView;
//进度条Label
@property (weak, nonatomic) IBOutlet UILabel     *labNumOfApply;//报名人数
@property (weak, nonatomic) IBOutlet UILabel     *labNumOfHire;//录用人数
@property (weak, nonatomic) IBOutlet UILabel     *labNumOfFinish;//完工人数
//进度条
@property (weak, nonatomic) IBOutlet UIView      *guage_1;
@property (weak, nonatomic) IBOutlet UIImageView *guageCircle_1;
@property (weak, nonatomic) IBOutlet UIView      *guage_2;
@property (weak, nonatomic) IBOutlet UIView      *guage_3;
@property (weak, nonatomic) IBOutlet UIImageView *guageCircle_2;
@property (weak, nonatomic) IBOutlet UIView      *guage_4;
@property (weak, nonatomic) IBOutlet UIView      *guage_5;
@property (weak, nonatomic) IBOutlet UIImageView *guageCircle_3;
@property (weak, nonatomic) IBOutlet UIView      *guage_6;
//灰色圈
@property (weak, nonatomic) IBOutlet UIImageView *huiseO_1;
@property (weak, nonatomic) IBOutlet UIImageView *huiseO_2;
@property (weak, nonatomic) IBOutlet UIImageView *huiseO_3;


//分割线一下
@property (weak, nonatomic) IBOutlet UILabel     *labMarker;//注：xxxxx
//button
@property (weak, nonatomic) IBOutlet UIButton    *btnReject;//拒绝btn
@property (weak, nonatomic) IBOutlet UILabel     *labAlreadyReject;//已经拒绝
@property (weak, nonatomic) IBOutlet UIButton    *btnShare;//分享
@property (weak, nonatomic) IBOutlet UIButton    *btnAccept;//接单
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToLabNameConstraint;//分割线到标题的距离


@end
@implementation SocialAcitvistCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"SocialAcitvistCell";
    SocialAcitvistCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"SocialAcitvistCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)refreshWithData:(SociaAcitvistModel *)model andIndexPath:(NSIndexPath *)indexPath{

    if (model) {
        
        [self.bgView setCornerValue:3];
        [self.bgView setBorderWidth:0.7 andColor:MKCOLOR_RGBA(0, 0, 0, 0.05)];
        
        _saModel = model;
        _indexPath = indexPath;
        //标题
        self.labName.text = _saModel.job_title;
        //人脉王赏金
        self.labSalary.text = [NSString stringWithFormat:@"%.2f",_saModel.social_activist_reward.intValue * 0.01];
        //进度条上的label
        self.labNumOfApply.text = [NSString stringWithFormat:@"%@人已报名",_saModel.apply_num];
        self.labNumOfHire.text = [NSString stringWithFormat:@"%@人被录用",_saModel.hire_num];
        self.labNumOfFinish.text = [NSString stringWithFormat:@"%@人已完工",_saModel.finish_work_num];

        //设置cell高度
        [self setUpCellHeight];
        //注：xxxxx
        if (_saModel.task_status.intValue == 1 || _saModel.task_status.intValue == 3) {//未接单，已拒绝
            self.labMarker.hidden = YES;
        }else{
            self.labMarker.hidden = NO;
            self.labMarker.attributedText = [self serveFeeAttributedTextWithPay:[NSString stringWithFormat:@"%.2f",_saModel.expect_reward.intValue * 0.01]];
        }
        //按钮设置
        [self.btnShare setCornerValue:3];
        [self.btnAccept setCornerValue:3];
        if (_saModel.task_status.intValue == 1) {//未接单
            self.btnShare.hidden = YES;
            self.labAlreadyReject.hidden = YES;
            self.btnAccept.hidden = NO;
            self.btnReject.hidden = NO;
        }else if (_saModel.task_status.intValue == 2){//接单

            self.btnShare.hidden = NO;
            self.labAlreadyReject.hidden = YES;
            self.btnAccept.hidden = YES;
            self.btnReject.hidden = YES;
            //设置进度条
            if (_saModel.apply_num.intValue == 0) {//全灰色
                [self.guage_1 setBackgroundColor:HUISE];
                [self.guage_2 setBackgroundColor:HUISE];
                [self.guage_3 setBackgroundColor:HUISE];
                [self.guage_4 setBackgroundColor:HUISE];
                [self.guage_5 setBackgroundColor:HUISE];
                [self.guage_6 setBackgroundColor:HUISE];
                self.huiseO_1.hidden = NO;
                self.huiseO_2.hidden = NO;
                self.huiseO_3.hidden = NO;
                self.guageCircle_1.hidden = YES;
                self.guageCircle_2.hidden = YES;
                self.guageCircle_3.hidden = YES;
                self.labNumOfApply.textColor = HUISEZITI;
                self.labNumOfHire.textColor = HUISEZITI;
                self.labNumOfFinish.textColor = HUISEZITI;
            }
            if (_saModel.apply_num.intValue != 0 && _saModel.hire_num.intValue == 0) {//第一个点之前绿色
                
                [self.guage_1 setBackgroundColor:LVSE];
                [self.guage_2 setBackgroundColor:HUISE];
                [self.guage_3 setBackgroundColor:HUISE];
                [self.guage_4 setBackgroundColor:HUISE];
                [self.guage_5 setBackgroundColor:HUISE];
                [self.guage_6 setBackgroundColor:HUISE];
                self.huiseO_1.hidden = YES;
                self.huiseO_2.hidden = NO;
                self.huiseO_3.hidden = NO;
                self.guageCircle_1.hidden = NO;
                self.guageCircle_2.hidden = YES;
                self.guageCircle_3.hidden = YES;
                self.labNumOfApply.textColor = LVSE;
                self.labNumOfHire.textColor = HUISEZITI;
                self.labNumOfFinish.textColor = HUISEZITI;

            }
            if (_saModel.hire_num.intValue != 0 && _saModel.finish_work_num.intValue == 0){//第二个点前绿色
                
                [self.guage_1 setBackgroundColor:LVSE];
                [self.guage_2 setBackgroundColor:LVSE];
                [self.guage_3 setBackgroundColor:LVSE];
                [self.guage_4 setBackgroundColor:HUISE];
                [self.guage_5 setBackgroundColor:HUISE];
                [self.guage_6 setBackgroundColor:HUISE];
                self.huiseO_1.hidden = YES;
                self.huiseO_2.hidden = YES;
                self.huiseO_3.hidden = NO;
                self.guageCircle_1.hidden = NO;
                self.guageCircle_2.hidden = NO;
                self.guageCircle_3.hidden = YES;
                self.labNumOfApply.textColor = LVSE;
                self.labNumOfHire.textColor = LVSE;
                self.labNumOfFinish.textColor = HUISEZITI;
            }
            if (_saModel.finish_work_num.intValue != 0) { //纯绿色
                
                [self.guage_1 setBackgroundColor:LVSE];
                [self.guage_2 setBackgroundColor:LVSE];
                [self.guage_3 setBackgroundColor:LVSE];
                [self.guage_4 setBackgroundColor:LVSE];
                [self.guage_5 setBackgroundColor:LVSE];
                [self.guage_6 setBackgroundColor:LVSE];
                self.huiseO_1.hidden = YES;
                self.huiseO_2.hidden = YES;
                self.huiseO_3.hidden = YES;
                self.guageCircle_1.hidden = NO;
                self.guageCircle_2.hidden = NO;
                self.guageCircle_3.hidden = NO;
                self.labNumOfApply.textColor = LVSE;
                self.labNumOfHire.textColor = LVSE;
                self.labNumOfFinish.textColor = LVSE;
                
            }
        }else if (_saModel.task_status.intValue == 3){//拒绝
            
            self.btnShare.hidden = YES;
            self.labAlreadyReject.hidden = NO;
            self.btnAccept.hidden = YES;
            self.btnReject.hidden = YES;
        }
        
        //已经被撤销人脉王 但是有之前的订单信息
        if (self.isNotSocialActivist) {
            self.btnAccept.enabled = NO;
            self.btnReject.enabled = NO;
            self.btnShare.enabled = NO;
            [self.btnReject setTitleColor:HUISE forState:UIControlStateDisabled];
        }
    }

}
//设置cell高度
- (void)setUpCellHeight{
    _saModel.cellHeight = 104;
    if (_saModel.task_status.intValue == 1 || _saModel.task_status.intValue == 3) {
        _saModel.cellHeight = 104;
        self.ApplyView.hidden = YES;
        self.HireView.hidden = YES;
        self.FinishView.hidden = YES;
        self.lineToLabNameConstraint.constant = 15;
    }else{
        _saModel.cellHeight = 154;
        self.ApplyView.hidden = NO;
        self.HireView.hidden = NO;
        self.FinishView.hidden = NO;
        self.lineToLabNameConstraint.constant = 60;
    }    
}
/**
 * 分享
 */
- (IBAction)btnShareOnClick:(UIButton *)sender {
    [_delegate shareWihtModel:_saModel];
    
}
- (IBAction)btnAcceptOnClick:(UIButton *)sender {
//    DLog(@"接单");
    [self Accept];
}

- (IBAction)btnRejectOnClick:(UIButton *)sender {
//    DLog(@"拒绝");
    [self Reject];
}
//接单
-(void)Accept{
    NSString *content = [NSString stringWithFormat:@"task_id:\"%@\",task_status:\"%@\"",_saModel.task_id,@(1)];
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_dealSocialActivistTask" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            [weakSelf updateUI];
        }
    }];
}
//拒绝
-(void)Reject{
    NSString *content = [NSString stringWithFormat:@"task_id:\"%@\",task_status:\"%@\"",_saModel.task_id,@(0)];
    
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_dealSocialActivistTask" andContent:content];
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            [weakSelf updateUI];
        }
    }];
}
- (void)updateUI{
    [self.delegate sa_Cell_updateCellIndex:_indexPath withModel:_saModel];
}
//红色数字显示
- (NSMutableAttributedString *)serveFeeAttributedTextWithPay:(NSString *)salary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = MKCOLOR_RGB(255, 87, 34);
    dic[NSFontAttributeName] = [UIFont fontWithName:kFont_RSR size:14];
    NSMutableAttributedString *tempPaySalary = [[NSMutableAttributedString alloc] initWithString:salary attributes:dic];
    NSMutableAttributedString *aStrM = [[NSMutableAttributedString alloc] initWithString:@"注:预计赏金"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"元"];
    [aStrM appendAttributedString:tempPaySalary];
    [aStrM appendAttributedString:str];
    
    return aStrM;
}
@end
