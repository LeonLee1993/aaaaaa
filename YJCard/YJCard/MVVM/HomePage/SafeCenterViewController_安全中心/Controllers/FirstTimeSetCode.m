//
//  FirstTimeSetCode.m
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "FirstTimeSetCode.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"

@interface FirstTimeSetCode ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *codeCertainTF;

@end

@implementation FirstTimeSetCode

- (void)viewDidLoad {
    [super viewDidLoad];
    _codeTF.delegate = self;
    _codeCertainTF.delegate = self;

}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commitButtonClicked:(id)sender {
    
    if([self.codeTF.text isEqualToString:self.codeCertainTF.text] && self.codeTF.text.length == 6){
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        [mutDic setObject:@"" forKey:@"oldpwd"];
        [mutDic setObject:self.codeCertainTF.text forKey:@"newpwd"];
        NSString * testStr = [NSString setUrlEncodeStringWithDic:mutDic];
       self.mgr = [[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,PaypwdedSet] params:testStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [MBProgressHUD showWithText:@"设置支付密码成功"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.window.rootViewController = rootVc;
                });

                
            }else{
                
                [MBProgressHUD showWithText:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } andProgressView:self.view progressViewText:@"密码设置中" progressViewType:LYCStateViewLoad ViewController:self];
        
    }else{
        
        if(![self.codeTF.text isEqualToString: self.codeCertainTF.text]){
            [MBProgressHUD showWithText:@"请确保两次密码一致"];
        }else{
            [MBProgressHUD showWithText:@"密码长度应为6位"];
        }
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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
