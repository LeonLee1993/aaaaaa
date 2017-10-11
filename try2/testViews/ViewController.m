//
//  ViewController.m
//  testView
//
//  Created by paradise_ on 2017/10/10.
//  Copyright © 2017年 YJGX. All rights reserved.
//

#import "ViewController.h"
#import <aframework/aframework.h>

@interface ViewController ()
@property (nonatomic,assign) NSInteger intValue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestViewController *tset = [[TestViewController alloc]init];
    [self.navigationController pushViewController:tset animated:YES];
    NSLog(@"hello");
}



@end

