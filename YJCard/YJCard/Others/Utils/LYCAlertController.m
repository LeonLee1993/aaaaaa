//
//  LYCAlertController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/31.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCAlertController.h"

@interface LYCAlertController ()

@end

@implementation LYCAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_IOS_8){
    
    }else{
        for (UIAlertAction * action in self.actions) {
            [action setValue:MainColor forKey:@"titleTextColor"];
        }
    }
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
