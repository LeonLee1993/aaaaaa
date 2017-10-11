//
//  ChangeCardPayCodeViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/27.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChangeCardPayCodeViewController.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"

@interface ChangeCardPayCodeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *originalTF;
@property (weak, nonatomic) IBOutlet UITextField *newedPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *certifyPasswordTF;
@end

@implementation ChangeCardPayCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardNoLabel.text = self.chagePWCardNO;
    _originalTF.delegate = self;
    _newedPasswordTF.delegate =self;
    _certifyPasswordTF.delegate = self;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)commitButtonClicked:(id)sender {
    if([self.newedPasswordTF.text isEqualToString: self.certifyPasswordTF.text]&&self.newedPasswordTF.text.length == 6&&self.originalTF.text.length==6){
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        [mutDic setObject:self.chagePWCardID forKey:@"cardid"];
        [mutDic setObject:self.originalTF.text forKey:@"oldpwd"];
        [mutDic setObject:self.newedPasswordTF.text forKey:@"newpwd"];
        NSString * testStr = [NSString setUrlEncodeStringWithDic:mutDic];
        self.mgr = [[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,PaypwdedSet] params:testStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
                LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = rootVc;
                [MBProgressHUD showWithText:@"修改密码成功"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"not" forKey:PayCodeState];
                [MBProgressHUD showWithText:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showWithText:@"网络错误,重设密码失败"];
        } andProgressView:self.view progressViewText:@"重置密码中" progressViewType:LYCStateViewLoad ViewController:self];
        
    }else{
        
        if(self.originalTF.text==0){
            [MBProgressHUD showWithText:@"请输入原来的密码"];
        }else if(![self.newedPasswordTF.text isEqualToString: self.certifyPasswordTF.text]){
            [MBProgressHUD showWithText:@"密码前后不一致"];
        }else{
            [MBProgressHUD showWithText:@"密码长度应为6位"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string length]==1) {
        if ([textField.text length]>5)
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
    
    NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
    [fieldText replaceCharactersInRange:range withString:string];
    NSString *finalText=[fieldText copy];
    if ([finalText length]>6) {
        textField.text=[finalText substringToIndex:6];
        return NO;
    }
    return YES;
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
