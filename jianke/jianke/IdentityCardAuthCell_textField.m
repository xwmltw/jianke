//
//  IdentityCardAuthCell_textField.m
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IdentityCardAuthCell_textField.h"

@interface IdentityCardAuthCell_textField(){
    PostIdcardAuthInfoPM *_postIdcardAuthInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UITextField *tfText;

@end

@implementation IdentityCardAuthCell_textField

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"IdentityCardAuthCell_textField";
    IdentityCardAuthCell_textField *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"IdentityCardAuthCell_textField" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return cell;
}

- (void)setData:(PostIdcardAuthInfoPM *)postIdcardAuthInfo withIDCardAuthCellType:(IDCardAuthCellType)type{
    _postIdcardAuthInfo = postIdcardAuthInfo;
    
    switch (type) {
        case IDCardAuthCellType_name:{
            self.imgIcon.image = [UIImage imageNamed:@"v250_account_box"];
            self.tfText.placeholder = @"姓名";
            [self updateTfText:_postIdcardAuthInfo.true_name];
        }
            break;
        case IDCardAuthCellType_idNum:{
            self.imgIcon.image = [UIImage imageNamed:@"card_icon_card"];
            self.tfText.placeholder = @"身份证";
            [self updateTfText:_postIdcardAuthInfo.id_card_no];
        }
            break;
            
        default:
            break;
    }
    
    self.tfText.tag = type;
    [self.tfText addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

}

- (void)updateTfText:(NSString *)text{
    if (text && text.length) {
        self.tfText.text = text;
    }
}

- (void)textFieldEndEdit:(UITextField *)sender{
    if (sender.tag == IDCardAuthCellType_name) {
        if (sender.text.length > 0) {
            _postIdcardAuthInfo.true_name = sender.text;
        }
    }else if (sender.tag == IDCardAuthCellType_idNum){
        if (sender.text.length > 0) {
            _postIdcardAuthInfo.id_card_no = sender.text;
        }
    }
}

- (void)textFieldChanged:(UITextField *)sender {
    if (sender.tag == IDCardAuthCellType_name) {
        if (sender.text.length > 10) {
            sender.text = [sender.text substringToIndex:10];
        }
        _postIdcardAuthInfo.true_name = sender.text;
    }else if (sender.tag == IDCardAuthCellType_idNum){
        if (sender.text.length > 18) {
            sender.text = [sender.text substringToIndex:18];
        }
        _postIdcardAuthInfo.id_card_no = sender.text;
    }
}

@end
