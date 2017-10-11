//
//  HDPersonSetTrueNameViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonSetTrueNameViewController.h"
#define changedName @"http://test.cdtzb.com/api.php?mod=member&act=profile&method=real_name_authentication"
@interface HDPersonSetTrueNameViewController ()

@end

@implementation HDPersonSetTrueNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
}

- (void) setUp {
    self.title = @"实名认证";
    [self setNormalBackNav];
}

- (IBAction)submitBtnClicked:(UIButton *)sender {
    
        [self changUserName];

}

- (void)changUserName{
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    if(_personIDTextField.text.length>0&&_nickNameTextFiled.text.length>0){
        [mutDic setObject:_personIDTextField.text forKey:@"idcard"];
        [[CDAFNetWork sharedMyManager] post:changedName params:mutDic success:^(id json) {
            NSLog(@"%@",json[@"msg"]);
            NSLog(@"%@",json);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if(_nickNameTextFiled.text.length==0){
            hud.label.text = @"请输入姓名";
        }else if(_personIDTextField.text.length ==0){
            hud.label.text = @"请输入身份证号码";
        }
        [hud hideAnimated:YES afterDelay:1];
    }
}


@end
