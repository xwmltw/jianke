//
//  PayDetail_VC.m
//  
//
//  Created by xiaomk on 15/10/10.
//
//

#import "PayDetail_VC.h"
#import "WDConst.h"
#import "PayDetailModel.h"
#import "MJRefresh.h"
#import "UIView+MKExtension.h"
#import "XHPopMenu.h"
#import "UserData.h"
#import "PayDetailCell.h"
#import "MKMessageComposeHelper.h"

@interface PayDetail_VC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,PayDetailCellDelegate>{
    PayDetailModel *_model;  //获取指定cell的数据模型
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) NSMutableArray *oriStuArray;

@end

@implementation PayDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.money_detail_title;
    self.oriStuArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 68;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [self.tableView.header beginRefreshing];
}


- (void)getData{
    self.queryParam = [[QueryParamModel alloc] init];
    
    WEAKSELF
    [[UserData sharedInstance] queryAcctDetailItemWithQueryParam:self.queryParam detailListId:self.detail_list_id block:^(ResponseInfo *result) {
        if (result) {
            NSArray *array = [PayDetailModel objectArrayWithKeyValuesArray:[result.content objectForKey:@"stu_list"]];
            if (array && array.count) {
                weakSelf.oriStuArray = [NSMutableArray arrayWithArray:array];
                weakSelf.queryParam.page_num = @2;
                [weakSelf.tableView reloadData];
            }
        }
        [weakSelf.tableView.header endRefreshing];
    }];
    
}

- (void)getMoreData{
    WEAKSELF
    [[UserData sharedInstance] queryAcctDetailItemWithQueryParam:self.queryParam detailListId:self.detail_list_id block:^(ResponseInfo *result) {
        if (result) {
            NSArray *array = [PayDetailModel objectArrayWithKeyValuesArray:[result.content objectForKey:@"stu_list"]];
            if (array && array.count) {
                QueryParamModel *queryParam = [QueryParamModel objectWithKeyValues:[result.content objectForKey:@"query_param"]];
                self.queryParam.page_num = @(queryParam.page_num.integerValue + 1);
                [weakSelf.oriStuArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailCell* cell = [PayDetailCell cellWithTableView:tableView];
    PayDetailModel *model = self.oriStuArray[indexPath.row];
    cell.delegate = self;
    [cell refreshWithData:model];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.oriStuArray ? self.oriStuArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailModel *model = self.oriStuArray[indexPath.row];

    if ([model.payroll_check_status integerValue] == 1) {    //未验证
        _model = model;
        [self showAlertView];
    }
}

/*处理分割线没在最左边问题：ios8以后才有的问题*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 52, 0, 0)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 52, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 52, 0, 0)];
    }
}

/*处理下面多余的线*/
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改兼客信息" message:@"姓名或手机号填写有误，可重新修改，原先的工资不会被冒领，系统会将工资转移到修改后的人员账号中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *teltext = [alertView textFieldAtIndex:0];
    UITextField *nametext = [alertView textFieldAtIndex:1];
    nametext.placeholder = @"请输入兼客全名";
    nametext.text = _model.payroll_check_name;
    nametext.secureTextEntry = NO;
    nametext.returnKeyType = UIReturnKeyDone;
    
    teltext.placeholder = @"手机号码";
    teltext.delegate = self;
    teltext.text = _model.telphone;
    teltext.keyboardType = UIKeyboardTypeNumberPad;
    [teltext addTarget:self action:@selector(didChangeAction:) forControlEvents:UIControlEventEditingChanged];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    teltext.rightView = label;
    label.font = [UIFont systemFontOfSize:12.0f];
    teltext.rightViewMode = UITextFieldViewModeAlways;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *tel = [alertView textFieldAtIndex:0].text;
    NSString *name = [alertView textFieldAtIndex:1].text;
    [alertView endEditing:YES];
    //判断
    if (buttonIndex == 1){
        if (!tel || tel.length != 11) {
            [self toast:@"请输入有效的手机号码"];
            return;
        }else if (_model.true_name.length == 1){
           //长度为1的用户名
            if (!name || !name.length) {
                [self toast:@"姓名不能为空"];
                return;
            }
        }else if (!name || name.length < 2 || name.length > 12){
            [self toast:@"请输入2-12位字符的兼客名称"];
            return;
        }
        WEAKSELF
        [[XSJRequestHelper sharedInstance] entChangeSalaryUnConfirmStu:_model.item_id withTel:tel withTrueName:name block:^(id result) {
            [weakSelf.tableView.header beginRefreshing];
        }];
    }
}

- (void)toast:(NSString *)text{
    [UIHelper toast:text];
    WEAKSELF
    [UserData delayTask:0.5 onTimeEnd:^{
        [weakSelf showAlertView];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 11) { //置换最后一位
        return NO;
        return YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 11) {  //手机号正确才请求
        [[UserData sharedInstance] queryAccountInfo:textField.text block:^(JKModel *jkModel) {
            _model.true_name = jkModel.true_name;
            UILabel *label = (UILabel *)textField.rightView;
            if (jkModel.true_name.length) {
                NSMutableString *temp = [[NSMutableString alloc] initWithString:jkModel.true_name];
                if (jkModel.true_name.length == 1) {
                    [temp insertString:@"*" atIndex:0];
                }else{
                    [temp replaceCharactersInRange:(NSRange){0,1} withString:@"*"];
                }
                label.text = [NSString stringWithFormat:@"(%@)",[temp copy]];
                label.hidden = NO;
                [label sizeToFit];
            }
        }];
    }

}

- (void)didChangeAction:(UITextField *)sender{
    [sender.rightView setHidden:YES];
}

#pragma mark - PayDetailCellDelegate

- (void)sendMessage:(PayDetailModel *)model{
    [[MKMessageComposeHelper sharedInstance] showWithRecipientArray:@[model.telphone] body:model.payroll_check_sms onViewController:self block:nil];
}

@end
