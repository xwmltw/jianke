//
//  JobExpressCell.h
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol JobExpressCellDelegate <NSObject>

- (void)jobExpressCell_closeSSPAD;

@end

@interface JobExpressCell : UITableViewCell


@property (nonatomic, weak) id <JobExpressCellDelegate> delegate;
@property (nonatomic, assign) BOOL isFromEpProfile;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data;
- (void)refreshWithData:(id)model andSearchStr:(NSString*)searchStr;

@end
