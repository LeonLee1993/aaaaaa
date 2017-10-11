//
//  PCForgetPWViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCForgetPWViewController.h"

@interface PCForgetPWViewController ()
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@property (nonatomic, assign) int countdown;
@end

@implementation PCForgetPWViewController{
    NSString *_vertify;
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_firstTF becomeFirstResponder];
    self.title = @"忘记密码";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)VertifButtonClicked:(UIButton *)sender {
    
    _vertifyButton.userInteractionEnabled = NO;
    _countdown = 30;
    [self requestCode];
    sender.layer.borderColor = [UIColor grayColor].CGColor;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sender.titleLabel.text =[NSString stringWithFormat:@" 重新获取(30秒) "];
    [sender setTitle:@" 重新获取(30秒) " forState:UIControlStateNormal];
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

- (void)countDown{
    _countdown --;
    _vertifyButton.titleLabel.text =[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown];
    [_vertifyButton setTitle:[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [self setButtonUseful];
    }
}

- (void)requestCode{
   
    if(_firstTF.text.length>0){
    NSString * url = [NSString stringWithFormat:getCode,_firstTF.text,@"password",arc4random()%10000];
    
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        
        if([json[@"code"] isEqual:@(1)]){
            dic = json[@"data"][0];
            NSLog(@"%@",json);
            _vertify = [NSString stringWithFormat:@"%@",dic[@"verify"]];
            NSLog(@"%@",_vertify);
            _secondTF.text = _vertify;
        }else{
    
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"获取验证码失败";
            [hud hideAnimated:YES afterDelay: 1];
            [self setButtonUseful];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"获取验证码失败!";
        [hud hideAnimated:YES afterDelay:2];
        [self setButtonUseful];
    }];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入手机号";
        [hud hideAnimated:YES afterDelay:1];
        [self setButtonUseful];
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
    NSString *url = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/gbs/editpassword"];
    NSDictionary *dicuser = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    NSLog(@"%@",dicuser[PCUserPhone]);
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:_thirdTF.text forKey:@"password"];
    [mutDic setObject:_forthTG.text forKey:@"re_password"];
    [mutDic setObject:_secondTF.text forKey:@"verify"];
    [mutDic setObject:_firstTF.text forKey:@"username"];//实际上是电话号码
    if(_secondTF.text.length!=4){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"验证码长度为4位";
        [hud hideAnimated:YES afterDelay: 1];
    }else if(_thirdTF.text.length<6||_thirdTF.text.length>=20){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码长度在6-20之间";
        [hud hideAnimated:YES afterDelay: 1];
    }else if (![_thirdTF.text isEqualToString: _forthTG.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次输入密码不一致";
        [hud hideAnimated:YES afterDelay: 1];
    }else{
        [[CDAFNetWork sharedMyManager] post:url params:mutDic success:^(id json) {
//            if([json[@"msg"] isEqualToString:@"成功"]){
                if([json[@"code"] isEqual:@(1)]){
                    self.blocked();
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
//                else{
//                    NSLog(@"错误");
//                }
//            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if(![json[@"msg"] isKindOfClass:[NSNull class]]){
                    hud.label.text = json[@"msg"];
                }else{
                    hud.label.text = @"修改密码失败";
                }
                [hud hideAnimated:YES afterDelay: 1];
            }
            NSLog(@"%@",json[@"msg"]);
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}


@end
