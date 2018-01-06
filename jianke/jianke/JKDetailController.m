//
//  JKDetailController.m
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKDetailController.h"
#import "SYMutiTabsNavController.h"
#import "JKDetailApplyController.h"
#import "JKDetailCompleteController.h"
#import "JobDetail_VC.h"

@interface JKDetailController ()

@end

@implementation JKDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"兼客详情";
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 12;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"岗位" style:UIBarButtonItemStylePlain target:self action:@selector(pushDetailVC)];
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];

    JKDetailApplyController *applyController =  [[JKDetailApplyController alloc] init];
    applyController.controllerType = JKDetailApplyControllerTypeApply;
    applyController.jobId = self.jobId;
//    applyController.title = @"已报名";
    
    JKDetailApplyController *employController = [[JKDetailApplyController alloc] init];
    employController.controllerType = JKDetailApplyControllerTypeEmploy;
    employController.jobId = self.jobId;
//    employController.title = @"已录用";
    
    JKDetailCompleteController *completeController = [[JKDetailCompleteController alloc] init];
    completeController.jobId = self.jobId;
//    completeController.title = @"已完成";
    
    SYMutiTabsNavController *mutiTabNavController = [[SYMutiTabsNavController alloc] initWithsubControllers:@[applyController, employController, completeController] titleArray:@[@"已报名", @"已录用", @"已完成"]];
    
    [self addChildViewController:mutiTabNavController];
    mutiTabNavController.view.frame = self.view.bounds;
    [self.view addSubview:mutiTabNavController.view];
}

- (void)pushDetailVC{
    ELog(@"进入岗位详情");
    JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
    viewCtrl.jobId = self.jobId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
