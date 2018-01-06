//
//  IMListBase.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "IMListBase.h"

@implementation IMListBase

- (void)setView:(UIView *)view{
    _view = view;
    [self setupListView];
}

- (instancetype)initWithHome:(IMHome_VC *)home{
    self = [super init];
    if (self) {
        self.home = home;
    }
    return self;
}

- (void)setupListView{
    
}

- (void)viewDidLayoutSubviews{
    
}

- (void)viewWillAppear{
    
}

- (void)viewWillDisappear{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
