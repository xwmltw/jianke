//
//  UIViewController+XZExtension.m
//  jianke
//
//  Created by yanqb on 2016/11/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "UIViewController+XZExtension.h"
#import "ServiceMange_VC.h"

@implementation UIViewController (XZExtension)

- (ToolBarItem *)toolBarItem{
    ToolBarItem *toolBarItem;
    if (self.parentViewController != nil && [self.parentViewController isKindOfClass:[ServiceMange_VC class]]) {
        
        ServiceMange_VC *vc = (ServiceMange_VC *)self.parentViewController;
        NSUInteger index = [vc.childVCs indexOfObject:self];
        if (index != NSNotFound) {
            toolBarItem = vc.customToolBar.subviews[index];
        }
    }
    return toolBarItem;
}

- (void)setToolBarItem:(ToolBarItem *)toolBarItem{
    
}

@end
