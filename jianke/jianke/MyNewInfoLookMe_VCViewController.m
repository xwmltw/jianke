//
//  MyNewInfoLookMe_VCViewController.m
//  jianke
//
//  Created by yanqb on 2017/7/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyNewInfoLookMe_VCViewController.h"
#import "LookMeModel.h"
#import "MyNewInfoLookMeCell.h"
#import "LookupResume_VC.h"
#import "JKHome_VC.h"
#import "WebView_VC.h"
#import "EpProfile_VC.h"

@interface MyNewInfoLookMe_VCViewController ()
{
    QueryParamModel *_queryParam;//分页
    NSNumber *_lookMeNum;//被查看次数
    NSString *_qaListUrl; //简历相关链接
}
@property(nonatomic, strong) NSMutableArray *helpCellArray;//存放雇主模型
@end

@implementation MyNewInfoLookMe_VCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"谁看过我";
    self.helpCellArray = [NSMutableArray array];
    _queryParam = [[QueryParamModel alloc] init];

    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 68;
    [self.tableView.header beginRefreshing];

    UIButton *btnProblem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 38)];
    [btnProblem addTarget:self action:@selector(btnProbleHelp:) forControlEvents:UIControlEventTouchUpInside];
    [btnProblem setImage:[UIImage imageNamed:@"MyNewInfo_LookMeHelp"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnProblem];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
}

#pragma mark -btn
- (void)btnProbleHelp:(UIButton *)sender{
    
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@", _qaListUrl];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)btnRefish:(UIButton *)sender{

    [[UserData sharedInstance]refreshResumeWithblock:^(ResponseInfo *response) {
        
        [UIHelper toast:@"刷新成功" ];
    }];
}
#pragma mark 刷新
- (void)headerRefresh{
    _queryParam.page_num = @1;
    
    WEAKSELF
    [[UserData sharedInstance]queryLookMeWithParam:_queryParam isShowLoding:NO block:^(NSDictionary *dic) {
        if (dic) {
            NSArray *arr = [LookMeModel objectArrayWithKeyValuesArray:dic[@"ent_list"]];
            _lookMeNum = dic[@"list_count"];
            _qaListUrl = dic[@"resume_qa_list_url"];
            weakSelf.helpCellArray = [arr mutableCopy];
            [weakSelf.tableView reloadData];

        }
        [weakSelf.tableView.header endRefreshing];
    }];

}
-(void)footerRefresh{

    
    if (_queryParam.page_num.integerValue == 1) {
        _queryParam.page_num = @(_queryParam.page_num.integerValue+1);
    }
    WEAKSELF
    [[UserData sharedInstance]queryLookMeWithParam:_queryParam isShowLoding:YES block:^(NSDictionary *dic) {
        if (dic) {
            NSArray *arr = [LookMeModel objectArrayWithKeyValuesArray:dic[@"ent_list"]];
            _lookMeNum = dic[@"list_count"];
             _qaListUrl = dic[@"resume_qa_list_url"];
            [weakSelf.helpCellArray addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            
        }
        [weakSelf.tableView.footer endRefreshing];

    }];
}
#pragma mark- tableview deletage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_lookMeNum.integerValue > 0){
        return 71;
    }else{
        return 0;
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = MKCOLOR_RGB(248, 249, 250);
    
    UILabel *lab = [[UILabel alloc]init];
    
    
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:@"您的简历最近30天被雇主查看了" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: MKCOLOR_RGB(77, 96, 114)}];
    NSString *str = [NSString stringWithFormat:@"%@",_lookMeNum];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: MKCOLOR_RGB(255, 97, 142)}];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"次。如何让雇主更快找到你？去刷新简历 →" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: MKCOLOR_RGB(77, 96, 114)}];
    [mutableAttStr appendAttributedString:attStr1];
    [mutableAttStr appendAttributedString:attStr2];

    
    lab.attributedText = mutableAttStr;
    [lab setNumberOfLines:0];
    [lab setFont:[UIFont systemFontOfSize:14.0f]];
    [view addSubview:lab];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"myNewInfo_refresh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnRefish:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(22);
        make.right.equalTo(view).offset(-16);
        make.width.height.equalTo(@28);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(16);
        make.left.equalTo(view).offset(16);
        make.right.equalTo(btn).offset(-30);
        make.bottom.equalTo(view).offset(-16);
    }];
    
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_lookMeNum.integerValue > 0) {
        return self.helpCellArray.count;
    }else{
        return 4;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_lookMeNum.integerValue > 0) {
        MyNewInfoLookMeCell *cell = [[NSBundle mainBundle]loadNibNamed:@"MyNewInfoLookMeCell" owner:nil options:nil].firstObject;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.model = self.helpCellArray[indexPath.row];
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"LookMeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [cell.textLabel setTextColor:MKCOLOR_RGB(34, 58, 80)];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
            [cell.detailTextLabel setTextColor:MKCOLOR_RGBA(34, 58, 80, 0.48)];
        }
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = MKCOLOR_RGBA(34, 58, 80, 0.03);
        [cell.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(1);
            make.left.equalTo(cell).offset(8);
            make.right.equalTo(cell).offset(-8);
            make.bottom.equalTo(cell).offset(-1);
            
        }];

        
        if (indexPath.row == 0) {
            view.hidden = YES;
            
            cell.backgroundColor = [UIColor whiteColor];
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"MyNewInfoLookMe_nil"];
            
            UILabel *lab1 = [[UILabel alloc]init];
            [lab1 setFont:[UIFont systemFontOfSize:20.0f]];
            [lab1 setTextColor:MKCOLOR_RGB(0, 188, 212)];
            [lab1 setText:@"无人问津"];
            
            UILabel *lab2 = [[UILabel alloc]init];
            [lab2 setFont:[UIFont systemFontOfSize:14.0f]];
            [lab2 setTextColor:MKCOLOR_RGB(0, 188, 212)];
            [lab2 setText:@"您的简历最近30天被雇主查看了0次"];
            
            [cell addSubview:image];
            [cell addSubview:lab1];
            [cell addSubview:lab2];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell);
                make.width.height.mas_equalTo(100);
            }];
            
            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell);
                make.top.equalTo(image.mas_bottom).offset(12);
            }];
            
            [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell);
                 make.top.equalTo(lab1.mas_bottom).offset(8);
            }];
        }
        
        
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"刷新简历";
            
            UIImageView *refish = [[UIImageView alloc]init];
            refish.image = [UIImage imageNamed:@"myNewInfo_refresh"];
            [cell addSubview:refish];
            
            [refish mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-8);
                make.height.width.mas_equalTo(28);
            }];
            
        }
        if (indexPath.row == 2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = @"投递中意岗位";
            cell.detailTextLabel.text = @"你这么优秀,投递岗位就好";
            
        }
        if (indexPath.row == 3) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = @"完善我的简历";
            cell.detailTextLabel.text = @"你这么好看,完整展示自己就好";
        }
        return cell;
        
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_lookMeNum.integerValue > 0) {
        return 96;
    }else{
        if (indexPath.row == 0) {
            return 280;
        }else{
            return 76;
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_lookMeNum.integerValue > 0){
        LookMeModel *model  = self.helpCellArray[indexPath.row];
        EpProfile_VC *vc = [[EpProfile_VC alloc] init];
        vc.isLookForJK = YES;
        vc.enterpriseId = [NSString stringWithFormat:@"%@",model.ent_id];
        [self.navigationController pushViewController:vc animated:YES];
        
    
    }else{
        if (indexPath.row == 1) {
            
            [[UserData sharedInstance]refreshResumeWithblock:^(ResponseInfo *response) {
               
                    [UIHelper toast:@"刷新成功" ];
            }];
            
        }
        if (indexPath.row == 2) {
            
            [XSJUIHelper showMainScene];
            
        }
        if (indexPath.row == 3) {
            LookupResume_VC *vc = [[LookupResume_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }

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
