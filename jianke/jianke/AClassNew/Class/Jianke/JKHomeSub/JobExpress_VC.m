//
//  JobExpress_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobExpress_VC.h"
#import "WDConst.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetail_VC.h"
#import "JobSearchController.h"
#import "JobDetailMgr_VC.h"
#import "DataBaseTool.h"
#import "JobDetail_VC.h"
#import "JKHome_VC.h"
#import "WebView_VC.h"
#import "TopicJobList_VC.h"

@interface JobExpress_VC ()<JobExpressCellDelegate>
@property (nonatomic, strong)RequestParamWrapper *param;
@end

@implementation JobExpress_VC

- (instancetype)init{
    self = [super init];
    if (self) {
        ELog(@"===========JobExpress_VC init ok");
        
    }
    return self;
}

- (void)getHistoryData{
    if (self.isHome) {
        NSArray* jobAry = [[UserData sharedInstance] getHomeJobList];
        if (jobAry && jobAry.count > 0) {
            self.arrayData = [[NSMutableArray alloc] initWithArray:jobAry];
            
            if ([XSJADHelper getAdIsShowWithType:XSJADType_homeJobList]) {
                if (self.arrayData && self.arrayData.count >= 10) {
                    JobModel *adModel = [[JobModel alloc] init];
                    adModel.isSSPAd = YES;
                    [self.arrayData insertObject:adModel atIndex:10];
                }
            }
        }
    }
}
- (void)getAllData{
    
    self.param = [[RequestParamWrapper alloc] init];
    self.param.queryParam = [[QueryParamModel alloc] init];
    
    LocalModel *model = [UserData sharedInstance].local;
    
    if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
        if (model) {
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",[UserData sharedInstance].city.id, model.latitude, model.longitude];
        }else{
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",[UserData sharedInstance].city.id];
        }
    }else{
        if (model) {
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",[UserData sharedInstance].city.id, model.latitude, model.longitude];
        }else{
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",[UserData sharedInstance].city.id];
        }
    }
    WEAKSELF
    self.param.queryParam.page_num = @1;
    [[XSJRequestHelper sharedInstance] queryJobListFromApp:self.param block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            
            if (array.count) {
                weakSelf.arrayData = [NSMutableArray arrayWithArray:array];
                weakSelf.param.queryParam.page_num = @2;
                NSArray *readedJobIdArray = [DataBaseTool readedJobIdArray];
                for (JobModel *obj in array) {
                    // 设置岗位已读/未读状态
                    [obj checkReadStateWithReadedJobIdArray:readedJobIdArray];
                    
                }
            }
            [weakSelf.tableView reloadData];
        }
    }];


}
- (void)jobExpressCell_closeSSPAD{
    if (self.arrayData && self.arrayData.count >= 11) {
        [self.arrayData removeObjectAtIndex:10];
        [self.tableView reloadData];
        [XSJADHelper closeAdWithADType:XSJADType_homeJobList];
    }
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if (!self.arrayData) {
//        [self getAllData];
//        return self.arrayData.count;
//    }
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.arrayData[indexPath.row];
    if ([model isKindOfClass:[JobModel class]]) {
        JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
        cell.delegate = self;
        if (self.arrayData.count <= indexPath.row) {
            
            return cell;
        }
        [cell refreshWithData:model];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adModelCell"];
    if (cell == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"adModelCell"];
    }
    if ([model isKindOfClass:[AdModel class]]) {
        UIImageView *image = [[UIImageView alloc]init];
        AdModel *adModel = model;
        [image sd_setImageWithURL:[NSURL URLWithString:adModel.img_url]];
        [cell addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell);
        }];
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *model = self.arrayData[indexPath.row];
    if(model.today_is_can_apply.integerValue == 0){
        return 133;
    }
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog("====didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 退出编辑
    if ([self.owner isKindOfClass:[JobSearchController class]]) {
        [self.owner.navigationItem.titleView endEditing:YES];
    }
    
    id modelA = self.arrayData[indexPath.row];
    if ([modelA isKindOfClass:[JobModel class]]) {
        JobModel *model = modelA;
        // 设置岗位为已读状态
        model.readed = YES;
        [DataBaseTool saveReadedJobId:model.job_id.stringValue];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        // 跳转到岗位详情
        DLog(@"跳转到有上拉/下拉的岗位详情");
        NSString *jobId = model.job_id.stringValue;
//        NSInteger index = indexPath.row;
        
//        NSMutableArray *jobIdArray = [NSMutableArray array];
//        for (JobModel *model in self.arrayData) {
//            if (!model.isSSPAd) {
//                NSString *jobIdStr = model.job_id.stringValue;
//                [jobIdArray addObject:jobIdStr];
//            }
//        }
        
        //    NSArray *tmpJobIdArray = [self.arrayData valueForKeyPath:@"job_id"];
        //    NSMutableArray *jobIdArray = [NSMutableArray array];
        //    for (NSNumber *num in tmpJobIdArray) {
        //        if (num) {
        //            NSString *jobIdStr = num.stringValue;
        //            [jobIdArray addObject:jobIdStr];
        //        }
        //    }
        
        JobDetail_VC *vc = [[JobDetail_VC alloc] init];
        vc.jobId = jobId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
    
    if ([modelA isKindOfClass:[AdModel class]]) {
        AdModel *model = modelA;
        switch (model.ad_type.intValue) {
            case 1:{
                if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                    return;
                }
                model.ad_detail_url = [model.ad_detail_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                WebView_VC* vc = [[WebView_VC alloc] init];
                vc.url = model.ad_detail_url;
                vc.uiType = WebViewUIType_Banner;
                vc.hidesBottomBarWhenPushed = YES;
                MKBlockExec(self.block,vc);
            }
                break;
            case 2:{
                if (model.ad_detail_id == nil || model.ad_detail_id.intValue == 0) {
                    return;
                }
                //进入岗位详情
                JobDetail_VC* vc = [[JobDetail_VC alloc] init];
                vc.jobId = [NSString stringWithFormat:@"%@",model.ad_detail_id];
                vc.hidesBottomBarWhenPushed = YES;
                MKBlockExec(self.block,vc);
            }
                break;
            case 3:{
                if (model.ad_detail_url == nil || model.ad_detail_url.length < 5) {
                    return;
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.ad_detail_url]];
            }
                break;
            case 4:{
                TopicJobList_VC *vc = [[TopicJobList_VC alloc] init];
                vc.adDetailId = model.ad_detail_id.stringValue;
                vc.hidesBottomBarWhenPushed = YES;
                MKBlockExec(self.block,vc);
            }
                break;
            case 5:{
            
                
            }
                break;
            default:
                break;
        }

    
    }

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isHome) {
        return self.tableSectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isHome) {
        return 45;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.owner) {
        if ([self.owner isKindOfClass:[JKHome_VC class]]) {
            [(JKHome_VC*)self.owner onScrollViewDidScroll:scrollView];
        }
    }
}


@end
