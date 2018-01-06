//
//  xwmAlertViewController.m
//  jianke
//
//  Created by yanqb on 2017/6/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "xwmAlertViewController.h"

@interface xwmAlertViewController ()

@end

@implementation xwmAlertViewController

- (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel okBtn:(NSString *)okBtn cancelBlock:(MKBlock)cancelBlock okBlock:(MKBlock)okBlock controller:(MKBlock)block{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:cancelBlock];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:okBtn style:UIAlertActionStyleDefault handler:okBlock];
    [alert addAction:cel];
    [alert addAction:ok];
    
    
    block(self);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
