//
//  TVAlertView.m
//  jianke
//
//  Created by xiaomk on 16/1/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TVAlertView.h"
#import "WDConst.h"

@interface TVAlertView() <DLAVAlertViewDelegate, UITextViewDelegate>{
    CGFloat _tvEditHeight;
    CGFloat _edgeWidth;
    CGFloat _contentViewOriginy;
    CGFloat _tvEdgeWidth;
    CGFloat _tvOriginY;
    UIFont* _tvFont;
    
    TVAlertViewCompletion _completion;
}

@property (nonatomic, strong) DLAVAlertView *exportAlertView;
@property (nonatomic, strong) UITextView* tvEdit;
@property (nonatomic, strong) UILabel* labPlaceholder;

@end

@implementation TVAlertView
Impl_SharedInstance(TVAlertView);

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        ELog(@"====TVAlertView init");
//        _edgeWidth = 32;
//        _contentViewOriginy = 0;
//        _tvEdgeWidth = 8;
//        _tvOriginY = 0;
//    }
//    return self;
//}

- (void)showWithTitle:(NSString*)title content:(NSString *)content placeholder:(NSString*)placeholder completion:(TVAlertViewCompletion)completion{
    _completion = completion;
    _edgeWidth = 32;
    _contentViewOriginy = 0;
    _tvEdgeWidth = 16;
    _tvOriginY = -8;
    _tvFont = [UIFont systemFontOfSize:16];
    
    if (self.exportAlertView) {
        [self.exportAlertView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.exportAlertView removeFromSuperview];
        self.exportAlertView = nil;
    }
    
    if (!self.exportAlertView) {
        DLAVAlertView* exportAlertView = [[DLAVAlertView alloc] initWithTitle:title
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"确定", nil];
        
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, _tvOriginY, SCREEN_WIDTH - _edgeWidth*2 - _tvEdgeWidth*2, 80)];
        textView.backgroundColor = [UIColor clearColor];
        textView.delegate = self;
        textView.editable = YES;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.tag = 200;
        textView.font = _tvFont;
        textView.textColor = [UIColor darkGrayColor];
        textView.showsVerticalScrollIndicator = YES;
        textView.text = content;
        self.tvEdit = textView;
        
        CGSize labSize =[UIHelper getSizeWithString:placeholder width:textView.frame.size.width-8 font:_tvFont];
        _labPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, textView.frame.size.width-8, labSize.height)];
        _labPlaceholder.numberOfLines = 0;
        _labPlaceholder.text = placeholder;
        _labPlaceholder.textColor = [UIColor lightGrayColor];
        _labPlaceholder.hidden = (content && content.length);
        _labPlaceholder.font = _tvFont;
        
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentViewOriginy, SCREEN_WIDTH - _edgeWidth*2 - _tvEdgeWidth*2, textView.frame.size.height)];
        [contentView addSubview:textView];
        [contentView addSubview:_labPlaceholder];
        
        exportAlertView.contentView = contentView;
        self.exportAlertView = exportAlertView;
    }
    [self.exportAlertView show];
}

- (void)showWithTitle:(NSString*)title placeholder:(NSString*)placeholder completion:(TVAlertViewCompletion)completion{
    [self showWithTitle:title content:nil placeholder:placeholder completion:completion];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    ELog(@"======0");
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (_tvEdit.text.length > 0) {
        _labPlaceholder.hidden = YES;
    }else if (_tvEdit.text.length <= 0){
        _labPlaceholder.hidden = NO;
    }
    
    if (textView.text.length > 120) {
        textView.text = [textView.text substringToIndex:120];
        [UIHelper toast:@"不能超过120个字"];
    }
//    ELog(@"");
//    CGSize labSize = [UIHelper getSizeWithString:self.tvEdit.text width:SCREEN_HEIGHT - _edgeWidth*2 - _tvEdgeWidth*2 font:_tvFont];
//    ELog(@"labSize:%f", labSize.height);
//    if (labSize.height > 36) {
//        ELog(@"=--");
//        CGRect frame = self.tvEdit.frame;
//        frame.size.height = labSize.height;
//        self.tvEdit.frame = frame;
//        
//        CGRect expFrame = self.exportAlertView.contentView.frame;
//        expFrame.size.height = labSize.height;
//        self.tvEdit.frame = expFrame;
//        
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    ELog(@"======3");
}

- (NSString*)getContentWithTextView{
    if (_tvEdit) {
        return _tvEdit.text;
    }
    return nil;
}

#pragma alertView delegate
- (void)alertView:(DLAVAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (_completion && _tvEdit) {
        _completion(alertView, buttonIndex, _tvEdit.text);
    }
}

- (void)dealloc{
    _tvFont = nil;
}
@end
