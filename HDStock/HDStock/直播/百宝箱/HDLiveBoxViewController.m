//
//  HDLiveBoxViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveBoxViewController.h"

@interface HDLiveBoxViewController ()

@end

@implementation HDLiveBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self fitFrame];
    
}


- (void) fitFrame {
    CGRect frame = self.view.frame;
    frame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-SCREEN_SIZE_WIDTH*9.0/16-90;
    self.view.frame = frame;
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
