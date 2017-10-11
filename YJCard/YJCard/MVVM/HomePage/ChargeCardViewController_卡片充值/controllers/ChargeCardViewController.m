//
//  ChargeCardViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChargeCardViewController.h"
#import "ChargeCardWithChargeCardViewController.h"

@interface ChargeCardViewController ()

@end

@implementation ChargeCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)chargeWithRechargeCard:(id)sender {
    ChargeCardWithChargeCardViewController *chargeView = [[ChargeCardWithChargeCardViewController alloc]init];
    [self.navigationController pushViewController:chargeView animated:YES];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
