//
//  ManualAddCell.m
//  jianke
//
//  Created by fire on 16/7/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKModel.h"
#import "UIColor+Extension.h"
#import "XSJConst.h"
#import "NSString+XZExtension.h"
#import "Masonry.h"

@interface ManualAddCell (){
    JKModel *_jkModel;
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraintLeft;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)deleteAction:(id)sender;
- (IBAction)chooseSex:(id)sender;
- (IBAction)nameDIdAction:(UITextField *)sender;
- (IBAction)telDidChange:(id)sender;
- (IBAction)nameDidEndEdit:(UITextField *)sender;
- (IBAction)autoRequestAction:(UITextField *)sender;

@end

@implementation ManualAddCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"ManualAddCell";
    ManualAddCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"ManualAddCell" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - 设置数据

- (void)setJkModel:(JKModel *)jkModel withIndexPath:(NSIndexPath *)indexPath isLastItem:(BOOL)isLastItem{
    
    _jkModel = jkModel;
    _indexPath = indexPath;
    _telField.text = jkModel.telphone;
    [self.telField addTarget:self action:@selector(tfTelEditChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self setNameLabelText:jkModel.true_name];
       
    [self setSex:[jkModel.sex integerValue]];
    
    //判断是否最后一条目,如果是,删除按钮隐藏,并调整cell高度
    self.deleteBtn.hidden = isLastItem;
}

#pragma mark - 事件响应

//输入name
- (IBAction)nameDIdAction:(UITextField *)sender {
    _jkModel.input_name = sender.text;
}

- (IBAction)telDidChange:(id)sender {
    self.nameLabel.hidden = YES;
}

- (IBAction)nameDidEndEdit:(UITextField *)sender {
    _jkModel.input_name = sender.text;
}

//性别选择
- (IBAction)chooseSex:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            [self setHighlightedButton:_manButton normalButton:_womanButton];
            [self moveLintTo:_manButton.x];
            _jkModel.sex = @1;
            break;
        case 101:
            [self setHighlightedButton:_womanButton normalButton:_manButton];
            [self moveLintTo:_womanButton.x];
            _jkModel.sex = @0;
            break;
    }
}

//删除操作
- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteCellForIndexPath:)]) {
        [self.delegate deleteCellForIndexPath:_indexPath];
    }
}

//获取手机号相关信息
- (IBAction)autoRequestAction:(UITextField *)sender {
    _jkModel.telphone = sender.text;
    
    if (sender.text.length != 11) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(queryAccountInfo:withIndexPath:)]) {
        [self.delegate queryAccountInfo:sender.text withIndexPath:_indexPath];
    }
}

/** 手动刷新cell内容 */
- (void)updateCell:(JKModel *)jkModel{
    //设置nameLabel
    [self setNameLabelText:jkModel.true_name];
    [self setSex:[jkModel.sex integerValue]];
}

/** 设置带星号姓名 */
- (void)setNameLabelText:(NSString *)name{
    if (name && name.length) {
        NSMutableString *temp = [[NSMutableString alloc] initWithString:name];
        if (name.length == 1) {
            [temp insertString:@"*" atIndex:0];
        }else{
            [temp replaceCharactersInRange:(NSRange){0,1} withString:@"*"];
        }
        _nameLabel.text = [NSString stringWithFormat:@"(%@)",[temp copy]];
        _nameLabel.hidden = NO;
        
    }else{
        _nameLabel.hidden = YES;
    }
}

/** 设置性别 */
- (void)setSex:(NSInteger)sexType{
    if (sexType == 1) {
        [self setHighlightedButton:_manButton normalButton:_womanButton];
        [self moveLintTo:0];
    }else if (sexType == 0){
        [self setHighlightedButton:_womanButton normalButton:_manButton];
        [self moveLintTo:SCREEN_WIDTH/2];
    }
}

#pragma mark - 其他方法

//设置高亮
- (void)setHighlightedButton:(UIButton *)hightBtn normalButton:(UIButton *)normalBtn{
    [hightBtn setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [normalBtn setTitleColor:[UIColor XSJColor_tGrayMiddle] forState:UIControlStateNormal];
}

//动画
- (void)moveLintTo:(CGFloat)x{
    self.lineConstraintLeft.constant = x;
}

- (void)tfTelEditChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
