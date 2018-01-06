//
//  AVPlay_VC.m
//  JKHire
//
//  Created by yanqb on 2017/1/21.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "AVPlay_VC.h"

@interface AVPlay_VC () <AVPlayerViewControllerDelegate>

@end

@implementation AVPlay_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    ELog(@"playerViewControllerWillStartPictureInPicture(即将开始图片)");
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    ELog(@"playerViewControllerDidStartPictureInPicture");
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error{
    ELog(@"error: %@", [error localizedDescription]);
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    ELog(@"playerViewControllerWillStopPictureInPicture");
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    ELog(@"playerViewControllerDidStopPictureInPicture");
}

- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController{
    return NO;
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    ELog(@"restoreUserInterfaceForPictureInPictureStopWithCompletionHandler");
}

- (void)dealloc{
    ELog(@"AVPlay_VC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
