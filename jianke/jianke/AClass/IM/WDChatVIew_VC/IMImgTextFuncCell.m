//
//  IMImgTextFuncCell.m
//  jianke
//
//  Created by xiaomk on 15/12/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "IMImgTextFuncCell.h"
#import "WdMessage.h"
#import "ImMessage.h"
#import "UIHelper.h"
#import "WDConst.h"
#import "WebView_VC.h"

@interface IMImgTextFuncCell(){
    
}

@property (weak, nonatomic) UIViewController* parentVC;
@property (nonatomic, strong) ImImgAndTextMessage* msgModel;

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIView *viewBoxBg;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgHeight;
@end

@implementation IMImgTextFuncCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"IMImgTextFuncCell";
    IMImgTextFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"IMImgTextFuncCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)refreshWithData:(ImImgAndTextMessage*)model and:(UIViewController *)vc{
    if (model && vc) {
        self.parentVC = vc;
        self.msgModel = model;
        
        [self.viewBoxBg setCorner];
        
        model.cellHeight = 142;
        
        NSString* timeStr = [DateHelper getimgTextStringFromDate:[NSNumber numberWithLongLong:model.sendTime.longLongValue]];
        self.labDate.text = timeStr;
        [UIHelper setCorner:self.labDate];
        
        NSString* dateStr = [DateHelper getDateFromTimeNumber:[NSNumber numberWithLongLong:model.sendTime.longLongValue] withFormat:@"M月dd日"];
        self.labTime.text = dateStr;
        
        ImImgAndTextMessageSub* msgModel = [model.messageList objectAtIndex:0];
        self.labTitle.text = msgModel.title;
        self.labContent.text = msgModel.message;
        
        CGSize contentSize = [self.labContent contentSizeWithWidth:SCREEN_WIDTH-(8+12)*2];
        [self.imgViewPic sd_setImageWithURL:[NSURL URLWithString:msgModel.imageUrl] placeholderImage:[UIHelper getDefaultImage]];
        
        CGFloat heightOfImg = (SCREEN_WIDTH - 16 - 24) * 0.55;
        self.layoutImgHeight.constant = heightOfImg;
        
        model.cellHeight = model.cellHeight + contentSize.height + heightOfImg;
        
        CGRect cellFrame = CGRectMake(0, 0, SCREEN_WIDTH, model.cellHeight);
        self.frame = cellFrame;
    }
}
- (IBAction)btnFirstBgOnclick:(UIButton *)sender {
    
    //            "type" :  int,  // 类型，1：跳转网页类型，2：app内跳转
    //            "code" :  " app内跳转code定义",  //type=2时，此参数必须有值
    //            “app_param”: {}, // app内跳转的参数，type=2时必须有值，值的内容根据code不同而不同
    //            "linkUrl" : "点击图片后跳转的URL,type=1时此参数必须有值"
    //            NSString *url=[NSString stringWithFormat:@"%@/wap/entPromise", @"http://api.jianke.cc"];
    ImImgAndTextMessageSub* msgModel = [self.msgModel.messageList objectAtIndex:0];

    NSNumber* type = msgModel.type;
    NSString* linkUrl = msgModel.linkUrl;
    __unused NSNumber* code = msgModel.code;
    __unused NSString* app_param = msgModel.app_param;
//    ELog(@"====type:%@",type);
//    ELog(@"====linkUrl:%@",linkUrl);
//    ELog(@"====code:%@",code);
//    ELog(@"====app_param:%@",app_param);
    if (type.intValue == 1) {               //跳到网页
        [[XSJRequestHelper sharedInstance] graphicPushLogClickRecord:msgModel.content_id.stringValue block:^(id result) {
            
        }];
        WebView_VC* vc = [[WebView_VC alloc] init];
        vc.url = linkUrl;
        vc.title = msgModel.title;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 2){
        ELog(@"=== type = 2     没做处理");
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
