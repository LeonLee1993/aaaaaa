//
//  HDPersonChangeNameViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonChangeNameViewController.h"


@interface HDPersonChangeNameViewController ()

@end

@implementation HDPersonChangeNameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUp];
    [self setNormalBackNav];
    self.title = @"修改昵称";
}

- (void) setUp {
    self.textBgViewToSelfViewVerSpace.constant = 25*WIDTH;
    self.saveBtnToTextBgViewVerSpace.constant = 25*WIDTH;
    _nameTextFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBackTo)];
    [_goBackView addGestureRecognizer:tap];
}

- (void)goBackTo{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveBtnClicked:(UIButton *)sender {
    if (self.nameTextFild.text.length > 0) {
        [self changUserName];
    }else {
        [MBProgressHUD showAutoMessage:@"请输入昵称"];
    }
}

- (void)changUserName{
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSDictionary *infoDic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    [mutDic setObject:infoDic[PCUserToken] forKey:@"token"];
    
    if(_nameTextFild.text.length<2||_nameTextFild.text.length>=20){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"昵称长度在2-20之间";
        [hud hideAnimated:YES afterDelay: 1];
    }else{
        if(_nameTextFild.text.length>0){
            [mutDic setObject:_nameTextFild.text forKey:@"nickname"];
            [[CDAFNetWork sharedMyManager] post:changedName params:mutDic success:^(id json) {
                
                if([json[@"code"] isEqual:@(1)]){
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = json[@"msg"];
                    [hud hideAnimated:YES afterDelay: 1];
                    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [mutDic setObject:_nameTextFild.text forKey:PCUserName];
                    [[LYCUserManager informationDefaultUser] loginWithDictionary:mutDic];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = json[@"msg"];
                    [hud hideAnimated:YES afterDelay: 1];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请输入昵称";
            [hud hideAnimated:YES afterDelay:1];
        }
    }
}





@end
