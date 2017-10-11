//
//  PCRegisterPwordViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCRegisterPwordViewController.h"
#import "AppDelegate.h"
#import "PCSignInEyeButton.h"
#import "UserProtocalViewController.h"

@interface PCRegisterPwordViewController ()
@property (weak, nonatomic) IBOutlet PCSignInEyeButton *firstButton;
@property (weak, nonatomic) IBOutlet PCSignInEyeButton *secondButton;

@end

@implementation PCRegisterPwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_setPWTF becomeFirstResponder];
    _setPWTF.secureTextEntry = !_firstButton.selected;
    _centionPWTF.secureTextEntry = !_secondButton.selected;
}
- (IBAction)completedButtonClicked:(UIButton *)sender {
    if(_acceptButton.selected == NO){
        [self signAcount];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"同意股博士用户协议后才能注册";
        [hud hideAnimated:YES afterDelay: 1];
    }
    
}


- (void)signAcount{
    
    NSString *url = resignStr;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:_telStr forKey:@"phone_number"];
    [mutDic setObject:_setPWTF.text forKey:@"password"];
    [mutDic setObject:_centionPWTF.text forKey:@"repassword"];
    [mutDic setObject:_codeStr forKey:@"verify_str"];
    
    if(_codeStr.length != 4){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"验证码长度为4位";
        [hud hideAnimated:YES afterDelay: 1];
    }else if(_setPWTF.text.length<6||_setPWTF.text.length>=20){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码长度在6-20之间";
        [hud hideAnimated:YES afterDelay: 1];
    }else if (![_setPWTF.text isEqualToString: _centionPWTF.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次输入密码不一致";
        [hud hideAnimated:YES afterDelay: 1];
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        [manager POST:url parameters:mutDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if([responseObject[@"msg"] isEqualToString:@"success"]){
                NSLog(@"%@",responseObject[@"msg"]);
                NSLog(@"%@",responseObject);
                NSMutableDictionary *infoDic = @{}.mutableCopy;
                [infoDic setObject:responseObject[@"msg"] forKey:PCUserState];
                [infoDic setObject:responseObject[@"data"][@"token"] forKey:PCUserToken];
                [infoDic setObject:_telStr forKey:PCUserName];
                [infoDic setObject:_setPWTF.text forKey:PCUserPassword];
                [infoDic setObject:_telStr forKey:PCUserPhone];
                
                [[LYCUserManager informationDefaultUser] loginWithDictionary:infoDic];
                [[LYCUserManager informationDefaultUser] autoLogin];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay: 1];
                self.block();
                [self.navigationController popToRootViewControllerAnimated:YES];

            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay: 1];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
- (IBAction)firstEye:(PCSignInEyeButton *)sender {
    sender.selected = !sender.selected;
    _setPWTF.secureTextEntry = sender.selected;
}
- (IBAction)secondEye:(PCSignInEyeButton *)sender {
    sender.selected = !sender.selected;
    _centionPWTF.secureTextEntry = !sender.selected;
}
- (IBAction)tapToSeeProtocol:(UIButton *)sender {
    UserProtocalViewController *protocal = [[UserProtocalViewController alloc]init];
    [self.navigationController pushViewController:protocal animated:YES];
}
- (IBAction)acceptButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
