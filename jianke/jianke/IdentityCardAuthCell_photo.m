//
//  IdentityCardAuthCell_photo.m
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IdentityCardAuthCell_photo.h"
#import "ParamModel.h"
#import "UIImageView+WebCache.h"

@interface IdentityCardAuthCell_photo (){
    PostIdcardAuthInfoPM *_postIdcardAuthInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;

@end

@implementation IdentityCardAuthCell_photo

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"IdentityCardAuthCell_photo";
    IdentityCardAuthCell_photo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"IdentityCardAuthCell_photo" bundle:nil];
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
        case IDCardAuthCellType_photo1:{
            [self.btnTitle setTitle:@"上传个人信息面" forState:UIControlStateNormal];
            [self updateImage:_postIdcardAuthInfo.id_card_url_front withPlaceholder:@"v250_idcard"];
            [self updateBtnStatus:postIdcardAuthInfo.isUpdateIdCardUrlfront];
        }
            break;
        case IDCardAuthCellType_photo2:{
            [self.btnTitle setTitle:@"上传国徽面" forState:UIControlStateNormal];
            [self updateImage:_postIdcardAuthInfo.id_card_url_back withPlaceholder:@"v250_idcardback"];
            [self updateBtnStatus:postIdcardAuthInfo.isUpdateIdCardUrlBack];
        }
            break;
        case IDCardAuthCellType_photo3:{
            [self.btnTitle setTitle:@"上传手持照" forState:UIControlStateNormal];
            [self updateImage:_postIdcardAuthInfo.id_card_url_third withPlaceholder:@"v250_idcard_2"];
            [self updateBtnStatus:postIdcardAuthInfo.isUpdateIdCardUrlthird];
        }
            break;
        default:
            break;
    }
    self.btnTitle.tag = type;
    self.btnUpload.tag = type;
    [self.btnTitle addTarget:self action:@selector(btnUploadOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnUpload addTarget:self action:@selector(btnUploadOnclick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateImage:(NSString *)url withPlaceholder:(NSString *)imageStr{
    if (url && url.length) {
        [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageStr]];
    }else{
        self.imgPhoto.image = [UIImage imageNamed:imageStr];
    }
}

- (void)updateBtnStatus:(BOOL)isUpdate{

    if(_postIdcardAuthInfo.id_card_verify_status.integerValue == 2 || _postIdcardAuthInfo.id_card_verify_status.integerValue == 3){
        self.btnTitle.hidden = YES;
        self.btnUpload.userInteractionEnabled = NO;
        return;
    }else{
        self.btnTitle.hidden = isUpdate;
        self.btnUpload.userInteractionEnabled = YES;
    };
    
}

- (void)btnUploadOnclick:(UIButton *)sender{
    [self.delegate updatePhoto:sender];
}

@end
