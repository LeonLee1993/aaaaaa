//
//  HDPersonChangePhoneNumViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonChangePhoneNumViewController.h"

@interface HDPersonChangePhoneNumViewController ()

@end

@implementation HDPersonChangePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
}

- (void) setUp {
    self.title = @"更换手机";
    [self setNormalBackNav];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
