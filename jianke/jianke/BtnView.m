//
//  self.m
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "BtnView.h"
#import "UIView+MKExtension.h"
#import "JobClassifierModel.h"
#import "JobTopicModel.h"
#import "DataBtn.h"

const CGFloat kPadding = 10;
const CGFloat kBtnHeight = 34;

@interface BtnView ()

@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, assign) CGFloat currentY;

@end


@implementation BtnView

- (instancetype)initWithWidth:(CGFloat)width dataType:(DataType)type dataArray:(NSArray *)dataArray
{
    
    if (self = [super init]) {
        
        self.x = 0;
        self.y = 0;
        self.width = width;
        
        self.currentX = 0;
        self.currentY = 0;
        
        // 添加按钮
        NSInteger count = dataArray.count;
        for (NSInteger i = 0; i < count; i++) {
            
            NSString *title = nil;
            if (type == DataTypeJobClass) {
                
                JobClassifierModel *jobClass = dataArray[i];
                title = jobClass.job_classfier_name;
                
            } else if (type == DataTypeTopic) {
                
                JobTopicModel *jobTopic = dataArray[i];
                title = jobTopic.topic_name;
            }
            
            // 添加按钮
            DataBtn *dataBtn = [[DataBtn alloc] init];
            dataBtn.dataModel = dataArray[i];
            [dataBtn setTitle:title forState:UIControlStateNormal];
            [dataBtn setTitleColor:MKCOLOR_RGB(23, 75, 136) forState:UIControlStateNormal];
            dataBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [dataBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            [dataBtn addTarget:self action:@selector(dataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            dataBtn.height = kBtnHeight;
            
            CGSize maxSize = CGSizeMake(width, kBtnHeight);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
            CGFloat btnWidth = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width + 16;
            
            dataBtn.width = btnWidth;
            
            // 判断是否要换行
            if (self.currentX + btnWidth + kPadding > width) {
                self.currentX = 0;
                self.currentY += kBtnHeight + 10;
                
            }
            
            dataBtn.x = self.currentX;
            dataBtn.y = self.currentY;
            
            self.currentX += btnWidth + kPadding;
            
            [self addSubview:dataBtn];
        }
        
        self.height = self.currentY + kPadding + kBtnHeight;
    }
    
    return self;
}


- (void)dataBtnClick:(DataBtn *)btn{
    if ([self.delegate respondsToSelector:@selector(btnView:didClickBtn:)]) {
        [self.delegate btnView:self didClickBtn:btn];
    }
}

@end
