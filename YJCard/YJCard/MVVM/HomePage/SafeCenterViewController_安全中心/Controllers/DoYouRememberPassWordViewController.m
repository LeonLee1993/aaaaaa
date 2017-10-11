//
//  DoYouRememberPassWordViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "DoYouRememberPassWordViewController.h"
#import "ResetCodeVC.h"
#import "ResetCodeWithCertifyViewController.h"

@interface DoYouRememberPassWordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelWithPhoneNum;

@end

@implementation DoYouRememberPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSString * userTelNumberStr = userInfoDic[UserTelNum];
    
    NSString *preStr = [userTelNumberStr substringToIndex:3];
    NSString *subStr = [userTelNumberStr substringFromIndex:userTelNumberStr.length-2];
    NSString * usetTelStr = [NSString stringWithFormat:@"%@******%@",preStr,subStr];
    
    NSString * telStr = [NSString stringWithFormat:@"%@%@",@"您是否记得账号 ",usetTelStr];
    
    NSRange range = [telStr rangeOfString:usetTelStr];
    NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc]initWithString:telStr];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range];
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    self.labelWithPhoneNum.attributedText = mutStr;
}

- (IBAction)doNotRememberClicked:(id)sender {
    ResetCodeWithCertifyViewController *resetWith = [[ResetCodeWithCertifyViewController alloc]init];
    [self.navigationController pushViewController:resetWith animated:YES];
}


- (IBAction)rememberClicker:(id)sender {
    ResetCodeVC *resetVC = [[ResetCodeVC alloc]init];
    [self.navigationController pushViewController:resetVC animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
