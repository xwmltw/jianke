//
//  TagView.m
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "TagView.h"
#import "TagViewModel.h"
#import "TagLabel.h"
#import "UIHelper.h"

static CGFloat side = 4.0;
static CGFloat spece = 8.0;
@interface TagView(){
    NSMutableArray* _tagsArray;
}

@end

@implementation TagView


- (instancetype)initWithWidth:(CGFloat)width{
    CGRect frame = CGRectMake(0, 0, width, 21);
    self = [super initWithFrame:frame];
    if (self) {
        _tagsArray = [[NSMutableArray alloc] init];
        _btnsArray = [[NSMutableArray alloc] init];
    }
    return self;
    
}
//- (instancetype)initWithSize:(CGSize)size{
//    CGRect frame = CGRectMake(0, 0, size.width, size.height);
//    self = [super initWithFrame:frame];
//    if (self) {
//        _tagsArray = [[NSMutableArray alloc] init];
//        _btnsArray = [[NSMutableArray alloc] init];
//        _isBtnEnble = NO;
//    }
//    return self;
//}

- (void)showTagsWithArray:(NSMutableArray*)tags{
    [self showTagsWithArray:tags isEnable:NO];
}

- (void)showTagsWithArray:(NSMutableArray*)tags isEnable:(BOOL)isEnable{
    [self showTagsWithArray:tags isEnable:isEnable isShowCloseIcon:NO];
}


- (void)showTagsWithArray:(NSMutableArray*)tags isEnable:(BOOL)isEnable isShowCloseIcon:(BOOL)isShowCloseIcon{
    [_tagsArray removeAllObjects];
    _tagsArray = tags;
    
    [_btnsArray removeAllObjects];
    CGFloat frameWidth = self.frame.size.width;
    
    CGFloat tagsTotalWidth = side;
    CGFloat tagsTotalHeight = side;
    
    CGFloat tagHeight = 0.0f;
    
    if (isEnable) {
        int i = 0;
        for (NSString* tag in _tagsArray) {
            
            TagButton* fillBtn = [[TagButton alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
            [fillBtn setTag:i];
            i++;
            [fillBtn addTarget:self action:@selector(tagOnClikc:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isShowCloseIcon) {
                [fillBtn setCloseIconAndText:tag];
//                [fillBtn setRadius:10.5];
            } else {
                [fillBtn setText:tag];
            }
            
            fillBtn.enabled = isEnable;
            
            //        TagLabel* fillLab = [[TagLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
            //        fillLab.text = tag;
            
            tagsTotalWidth += fillBtn.frame.size.width + spece;
            tagHeight = fillBtn.frame.size.height;
            
            if (tagsTotalWidth >= frameWidth) {
                tagsTotalHeight += fillBtn.frame.size.height + spece;
                tagsTotalWidth = side;
                fillBtn.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, fillBtn.frame.size.width, fillBtn.frame.size.height);
                tagsTotalWidth += fillBtn.frame.size.width + spece;
            }
            [_btnsArray addObject:fillBtn];
            [self addSubview:fillBtn];
        }
        tagsTotalHeight = tagsTotalHeight + tagHeight + side;
        CGRect frame = self.frame;
        frame.size.height = tagsTotalHeight;
        self.frame = frame;
        //    ELog("====width:%f",frame.size.height);
    }else{
        for (NSString* tag in _tagsArray) {
            TagLabel* fillLab = [[TagLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
            fillLab.text = tag;
            tagsTotalWidth += fillLab.frame.size.width + spece;
            tagHeight = fillLab.frame.size.height;
            if (tagsTotalWidth >= frameWidth) {
                tagsTotalHeight += fillLab.frame.size.height + spece;
                tagsTotalWidth = side;
                fillLab.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, fillLab.frame.size.width, fillLab.frame.size.height);
                tagsTotalWidth += fillLab.frame.size.width + spece;
            }
            [_btnsArray addObject:fillLab];
            [self addSubview:fillLab];
        }
        tagsTotalHeight = tagsTotalHeight + tagHeight + side;
        CGRect frame = self.frame;
        frame.size.height = tagsTotalHeight;
        self.frame = frame;
    }
}


- (CGFloat)getTagViewHeight{
    return self.frame.size.height + 5;
}

- (void)tagOnClikc:(UIButton*)sender{
    if ([self.deletage respondsToSelector:@selector(tagView:didClickWithIndex:)]) {
        [self.deletage tagView:self didClickWithIndex:sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
