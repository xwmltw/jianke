//
//  XSJPictureView.h
//  jianke
//
//  Created by fire on 16/1/6.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@class XSJPictureView;
@protocol XSJPictureViewDelegate <NSObject>
- (void)pictureView:(XSJPictureView *)pictureView didSelected:(NSArray *)pictures clickSendBtn:(UIButton *)sendBtn;
- (void)pictureViewDidClickPictureBtn:(XSJPictureView *)pictureView;
@end


@interface XSJPictureView : UIView
@property (nonatomic, assign) id<XSJPictureViewDelegate> delegate;

/** 设置图片状态为未选中 */
- (void)setPicturesUnSelected;
@end


@interface XSJPictureCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *selectBtn;
@end


@interface XSJPictureCellModel : NSObject

@property (nonatomic, strong) PHAsset *imageAsset;
@property (nonatomic, assign) BOOL selected;

@end
