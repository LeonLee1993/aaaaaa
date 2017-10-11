//
//  HDPersonalCenterViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonalCenterViewController.h"
#import "HDPersonInfoViewController.h"

@interface HDPersonalCenterViewController ()

@end

@implementation HDPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self setNormalBackNav];
    
}

- (void) setUp {
    
    self.title = @"个人中心";
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRM(100, 100, 100, 100);
    btn.backgroundColor = COLOR(redColor);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void) btnClicked:(UIButton *)sender {
    
    HDPersonInfoViewController * vc = [HDPersonInfoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
