//
//  PersonalSetttingVController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/15.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PersonalSetttingVController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface PersonalSetttingVController ()

@end

@implementation PersonalSetttingVController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutAction:(id)sender {
    LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"确认要退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserInfoKey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:PayCodeState];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserInfoKey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:DefaultMoneyWithNoCode];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserNeedCodeKey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"BaiduPushDeviceToken"];
        LoginViewController *login = [[LoginViewController alloc]init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = login;
    }];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
