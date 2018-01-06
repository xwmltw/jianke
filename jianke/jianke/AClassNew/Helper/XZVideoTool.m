//
//  XZVideoTool.m
//  jianke
//
//  Created by yanqb on 2016/11/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZVideoTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UIHelper.h"
#import "RequestInfo.h"
#import "UserData.h"

@interface XZVideoTool () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) MKBlock competeBlock;
@property (nonatomic, copy) MKBlock failBlock;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *outfilePath;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSURL *filePathURL;

@end

@implementation XZVideoTool
Impl_SharedInstance(XZVideoTool)

- (void)uploadVideoOnVC:(UIViewController *)viewCtrl compeleteBlock:(MKBlock)competeBlock failBlock:(MKBlock)failBlock{
    self.competeBlock = competeBlock;
    self.failBlock = failBlock;
    
    UIImagePickerController *imgPickerContrl = [[UIImagePickerController alloc] init];
    imgPickerContrl.delegate = self;
    imgPickerContrl.mediaTypes = @[(NSString *)kUTTypeMovie];
    imgPickerContrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewCtrl presentViewController:imgPickerContrl animated:YES completion:^{
        
    }];
}

//- (void)getThumbnailImage:(NSNotification *)notification{
//    ELog(@"%@", notification.userInfo);
//    [WDNotificationCenter removeObserver:self];
//    _moviePlayer = nil;
//    UIImage *image = [notification.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
//    
//    _filePath = _outfilePath;
//    _filePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",_outfilePath]];
//    ELog(@"转换完成_filePath = %@\n_filePathURL = %@",_filePath,_filePathURL);
//    
//    //图片长传
//    dispatch_async(dispatch_get_main_queue(), ^{
//        RequestInfo* infoimg = [[RequestInfo alloc] init];
//        [infoimg uploadImage:image andBlock:^(NSString *imageUrl) {
//            //视频长传
//            RequestInfo* infoVideo = [[RequestInfo alloc] init];
//            NSData *tmpData = [[NSData alloc] initWithContentsOfURL:_filePathURL];
//            [infoVideo uploadVideo:tmpData andBlock:^(NSString *videoUrl) {
//                [self ClearMovieFromDoucments];;
//                NSDictionary *dic = @{XZBlockImageUrlKey: imageUrl, XZBlockVideoUrlKey: videoUrl};
//                MKBlockExec(self.competeBlock, dic);
//            }];
//        }];
//    });
//}

#pragma mark - uiimagepickercontroller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
    if (url) {        
        //存储沙盒
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        _fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
         NSString *tmpOutFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _outfilePath = [tmpOutFilePath stringByAppendingFormat:@"/%@", _fileName];
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        [UserData delayTask:1.0f onTimeEnd:^{
            if ([NSThread isMainThread]) {
                ELog(@"上传视频开始--在主线程中");
            }
            [UIHelper showLoading:YES withMessage:@"上传视频中"];
        }];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        {
            ELog(@"outPath = %@",_outfilePath);
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            exportSession.outputURL = [NSURL fileURLWithPath:_outfilePath];
            exportSession.outputFileType = AVFileTypeMPEG4;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                    ELog(@"AVAssetExportSessionStatusCompleted---转换成功");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *image = [self getThumbnailImageWithUrl:url];
                        if (image == nil) {
                            [UIHelper toast:@"转码错误，请重新上传"];
                            return;
                        }
                        _filePath = _outfilePath;
                        _filePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",_outfilePath]];
                        ELog(@"转换完成_filePath = %@\n_filePathURL = %@",_filePath,_filePathURL);
                        
                        //图片长传
                        RequestInfo* infoimg = [[RequestInfo alloc] init];
                        [infoimg uploadImage:image isShowLoding:NO andBlock:^(NSString *imageUrl) {
                            //视频长传
                            RequestInfo* infoVideo = [[RequestInfo alloc] init];
                            NSData *tmpData = [[NSData alloc] initWithContentsOfURL:_filePathURL];
                            [infoVideo uploadVideo:tmpData isShowLoding:NO andBlock:^(NSString *videoUrl) {
                                if ([NSThread isMainThread]) {
                                    ELog(@"上传视频结束--在主线程中");
                                }
                                [UIHelper showLoading:NO withMessage:nil];
                                [self ClearMovieFromDoucments];;
                                NSDictionary *dic = @{XZVideoToolImageUrlKey: imageUrl, XZVideoToolVideoUrlKey: videoUrl};
                                MKBlockExec(self.competeBlock, dic);
                            }];
                        }];
                    });
                }else{
                    [UIHelper showLoading:NO withMessage:nil];
                    ELog(@"转换失败,值为:%li,可能的原因:%@",(long)[exportSession status],[[exportSession error] localizedDescription]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MKBlockExec(self.failBlock, nil);
                    });
                    
                }
            }];
        }
    }
    
}

- (UIImage *)getThumbnailImageWithUrl:(NSURL *)url{
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(1136, 640);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage:img];
    return image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)ClearMovieFromDoucments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        ELog(@"%@",filename);
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]) {
            ELog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

@end
