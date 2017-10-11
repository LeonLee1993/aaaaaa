//
//  HDPersonChangePasswordViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonChangePasswordViewController.h"

@interface HDPersonChangePasswordViewController () 
@property (weak, nonatomic) IBOutlet UIButton *vertifyButton;
@property (nonatomic,assign) NSInteger countdown;
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@end

@implementation HDPersonChangePasswordViewController{
    NSString *_vertify;
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void) setUp {
    self.title = @"修改密码";
    [self setNormalBackNav];
    _certificationCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _NewPWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ReAssumPWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *dicInfo = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    NSString *telStr = dicInfo[PCUserPhone];
    NSString *preStr = [telStr substringToIndex:3];
    NSString *tailStr = [telStr substringFromIndex:7];
    _topBondTeleLabel.text = [NSString stringWithFormat:@"%@****%@",preStr,tailStr];
}

- (IBAction)getSCodeButtonClicked:(UIButton *)sender {
    _vertifyButton.userInteractionEnabled = NO;
    _countdown = 30;
    [self requestCode];
    sender.layer.borderColor = [UIColor grayColor].CGColor;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sender.titleLabel.text =[NSString stringWithFormat:@" 重新获取(30秒) "];
    [sender setTitle:@" 重新获取(30秒) " forState:UIControlStateNormal];
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)requestCode{
    NSDictionary *diction = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    NSString * url = [NSString stringWithFormat:getCode,diction[PCUserPhone],@"password",arc4random()%10000];
    
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        
        if([json[@"code"] isEqual:@(1)]){
            dic = json[@"data"][0];
            NSLog(@"%@",json);
            _vertify = [NSString stringWithFormat:@"%@",dic[@"verify"]];
            NSLog(@"%@",_vertify);
            _certificationCodeTF.text = _vertify;
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = json[@"msg"];
            [hud hideAnimated:YES afterDelay: 2];
            [self setButtonUseful];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"您的网络不给力!";
        [hud hideAnimated:YES afterDelay: 2];
        [self setButtonUseful];
    }];
}


- (void)countDown{
    _countdown --;
    _vertifyButton.titleLabel.text =[NSString stringWithFormat:@" 重新获取(%ld秒) ",(long)_countdown];
    [_vertifyButton setTitle:[NSString stringWithFormat:@" 重新获取(%ld秒) ",(long)_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [_Timer invalidate];
        [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
        _vertifyButton.userInteractionEnabled = YES;
        _vertifyButton.layer.borderColor = codeColor.CGColor;
        [_vertifyButton setTitleColor:codeColor forState:UIControlStateNormal];
    }
}

- (void)setButtonUseful{
    [_Timer invalidate];
    [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    _vertifyButton.userInteractionEnabled = YES;
    _vertifyButton.layer.borderColor = codeColor.CGColor;
    [_vertifyButton setTitleColor:codeColor forState:UIControlStateNormal];
}


- (IBAction)redefinePw:(UIButton *)sender {
    NSString *url = URL_ChangePW;
    NSDictionary *dicuser = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:_NewPWTF.text forKey:@"password"];
    [mutDic setObject:_ReAssumPWTF.text forKey:@"re_password"];
    [mutDic setObject:_certificationCodeTF.text forKey:@"verify"];
    [mutDic setObject:dicuser[PCUserPhone] forKey:@"username"];
    
    if(_certificationCodeTF.text.length!=4){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"验证码错误";
        [hud hideAnimated:YES afterDelay: 1];
    }
    else if(_NewPWTF.text.length<6||_NewPWTF.text.length>=20){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码长度在6-20之间";
        [hud hideAnimated:YES afterDelay: 1];
    }else if (![_NewPWTF.text isEqualToString:_ReAssumPWTF.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次输入密码不一致";
        [hud hideAnimated:YES afterDelay: 1];
    }else{
        [[CDAFNetWork sharedMyManager] post:url params:mutDic success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                NSDictionary *personDic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:personDic];
                [infoDic setObject:_ReAssumPWTF.text forKey:PCUserPassword];
                [[LYCUserManager informationDefaultUser] loginWithDictionary:infoDic];
                self.block();
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = json[@"msg"];
                [hud hideAnimated:YES afterDelay: 1];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}


@end
