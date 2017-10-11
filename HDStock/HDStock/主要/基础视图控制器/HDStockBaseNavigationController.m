//
//  HDStockBaseNavigationController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseNavigationController.h"
#import "HDHomePageViewController.h"
#define kNavBarColor [UIColor whiteColor]

@interface HDStockBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HDStockBaseNavigationController

+ (void)load
{
    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
//    
//    [bar setBackgroundImage:[UIImage createImageWithColor:kNavBarColor] forBarMetrics:UIBarMetricsDefault];
//    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
//    
//    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:17];
//    [bar setTitleTextAttributes:dic];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count && ![viewController isKindOfClass:[HDHomePageViewController class]] ) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
    
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
