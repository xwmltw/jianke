//
//  UIPickerHelper.m
//  jianke
//
//  Created by xuzhi on 16/8/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "UIPickerHelper.h"
#import "UIHelper.h"

@interface UIPickerHelper () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) MKBlock finishBlock;
@property (nonatomic, copy) MKBlock cancelBlock;

@end

@implementation UIPickerHelper

Impl_SharedInstance(UIPickerHelper)

- (void)presentImagePickerOnVC:(UIViewController *)viewCtrl sourceType:(UIImagePickerControllerSourceType)sourceType finish:(MKBlock)finishBlock{
    [self presentImagePickerOnVC:viewCtrl sourceType:sourceType finish:finishBlock cancel:nil];
}

- (void)presentImagePickerOnVC:(UIViewController *)viewCtrl sourceType:(UIImagePickerControllerSourceType)sourceType finish:(MKBlock)finishBlock cancel:(MKBlock)cancelBlock{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imgviewCtrl = [[UIImagePickerController alloc] init];
        imgviewCtrl.sourceType = sourceType;
        imgviewCtrl.delegate = self;
        imgviewCtrl.allowsEditing = YES;
        self.finishBlock = finishBlock;
        self.cancelBlock = cancelBlock;
        [viewCtrl presentViewController:imgviewCtrl animated:YES completion:nil];
    }else{
        [UIHelper toast:@"您的设备不支持此类型"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    MKBlockExec(self.finishBlock, info);
//    self.finishBlock = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    MKBlockExec(self.cancelBlock, nil);
//    self.cancelBlock = nil;
}

@end
