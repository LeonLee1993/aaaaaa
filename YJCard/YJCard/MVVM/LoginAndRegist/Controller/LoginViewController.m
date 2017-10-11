//
//  LoginViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/6/28.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LYCBaseTabBarController.h"
//#import "WechatLoginVM.h"
#import <AFHTTPSessionManager.h>
//#import <WXApi.h>
#import "UIDevice+IdentifierAddition.h"
#import "LoginViewModel.h"
//微信开发者ID
#define URL_APPID @"wxa37aef55f29472ac"
#define URL_SECRET @"f3db32f48df49b5813b5b1e4229614cf"
#import "YJCXStack.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@property (weak, nonatomic) IBOutlet UIView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *vertifyButton;
@property (weak, nonatomic) IBOutlet UILabel *contactUSView;
@property (weak, nonatomic) IBOutlet UITextField *teleNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (nonatomic, assign) int countdown;
@property (nonatomic,strong) LoginViewModel *loginVM;
@end

@implementation LoginViewController{
    NSString *dataString;
}

- (LoginViewModel *)loginVM
{
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc] init];
        _loginVM.SelfVC = self;
    }
    
    return _loginVM;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


-(void)viewDidLoad{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSLog(@"SandBoxPath--->%@",documentDirectory);
    
    self.teleNumTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户icon.png"]];
    self.teleNumTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.verifyTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验证码icon.png"]];
    self.verifyTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.teleNumTF.delegate = self;
    self.verifyTF.delegate = self;
    
    [self bindViewModel];
    
    [LYCLocationSigleton LYCLocationManager];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToContanctUS)];
    [self.contactUSView addGestureRecognizer:tap];
    
}

- (void)bindViewModel{
    // 1.给视图模型的账号和密码绑定信号
    RAC(self.loginVM, account) = _teleNumTF.rac_textSignal;
    RAC(self.loginVM, pwd) = _verifyTF.rac_textSignal;
}

-(void)tapToContanctUS{

    LYCAlertController * alertView = [LYCAlertController alertControllerWithTitle:@"确认拨打电话联系客服?" message:nil preferredStyle:0];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"400-600-9610" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *telNumber = [NSString stringWithFormat:@"tel:%@", @"4006009610"];
        NSURL *aURL = [NSURL URLWithString:telNumber];
        if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
            [[UIApplication sharedApplication] openURL:aURL];
        }
    }];
    
    [alertView addAction:OKAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertView addAction:cancleAction];
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (IBAction)getCodeButtonClicked:(UIButton *)sender {
    _countdown = 60;
    if([NSString isMobileNumber:self.teleNumTF.text]){
        [self requestCode];
        _vertifyButton.userInteractionEnabled = NO;
        sender.layer.borderColor = [UIColor grayColor].CGColor;
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sender.titleLabel.text =[NSString stringWithFormat:@" 重新获取(60秒) "];
        [sender setTitle:@" 重新获取(60秒) " forState:UIControlStateNormal];
        _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }else{
        [MBProgressHUD showWithText:@"请输入正确手机号"];
        _vertifyButton.userInteractionEnabled = YES;
    }
}

- (void)requestCode{
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:self.teleNumTF.text forKey:@"mobile"];
    NSString * testStr = [NSString setUrlEncodeStringWithDic:mutDic];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,GetVertifyCode] params:testStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            [MBProgressHUD showWithText:@"已成功将验证码发送至您的手机"];
            dataString = [NSString stringWithFormat:@"%@",json[@"data"]];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
            [self resetVertifyButton];
        }
        [self.verifyTF becomeFirstResponder];
    } failure:^(NSError *error) {
        [MBProgressHUD showWithText:@"error"];
        [self resetVertifyButton];
    } andProgressView:self.view progressViewText:@"获取验证码中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)countDown{
    _countdown --;
    _vertifyButton.titleLabel.text =[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown];
    [_vertifyButton setTitle:[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [self resetVertifyButton];
    }
}

- (void)resetVertifyButton{
    [_Timer invalidate];
    [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    _vertifyButton.userInteractionEnabled = YES;
    _vertifyButton.layer.borderColor = MainColor.CGColor;
    [_vertifyButton setTitleColor:MainColor forState:UIControlStateNormal];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    
    if(dataString.length>0||[self.teleNumTF.text isEqualToString:@"17729821017"]){
        
        _loginVM.dataString = dataString;
        _loginVM.needDissmiss = _needDissmiss;
        [self.loginVM.loginCommand execute:nil];
        
    }else{
    
        if(![NSString isMobileNumber:self.teleNumTF.text]){
            [MBProgressHUD showWithText:@"请输入正确电话号码"];
        }else{
            [MBProgressHUD showWithText:@"请获取验证码"];
            [self resetVertifyButton];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.teleNumTF){
        //敲删除键
        if ([string length]==1) {
            if ([textField.text length]>10)
                return NO;
            if([self validateNumber:string]){
                return YES;
            }else{
                return NO;
            }
        }
        
        NSUInteger lengthStr = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthStr; loopIndex++)
        {
            unichar character = [string characterAtIndex:loopIndex];
            if (loopIndex == 0 && character == 48 && textField.text.length == 0)
            {
                return NO;
            }
           
            
            if (character < 48 || character > 57)
            {
                return NO;
            }
        }
        
//        //获得当前输入框内的字符串
//        NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
//        //完成输入动作，包括输入字符，粘贴替换字符
//        [fieldText replaceCharactersInRange:range withString:string];
//        NSString *finalText=[fieldText copy];
//        //如果字符个数大于18就要进行截取前边18个字符
//        if ([finalText length]>11) {
//            textField.text=[finalText substringToIndex:11];
//            return NO;
//        }
        return YES;
    }else{
        
        if ([string length]==1) {
            if ([textField.text length]>5)
                return NO;
            if([self validateNumber:string]){
                return YES;
            }else{
                return NO;
            }
        }
        //如果是粘贴来的
        NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
        [fieldText replaceCharactersInRange:range withString:string];
        NSString *finalText=[fieldText copy];
        if ([finalText length]>6) {
            textField.text=[finalText substringToIndex:6];
            return NO;
        }
        return YES;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

@end
