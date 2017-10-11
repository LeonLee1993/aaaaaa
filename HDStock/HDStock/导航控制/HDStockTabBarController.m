//
//  HDStockTabBarController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockTabBarController.h"
#import "PersonalproductViewController.h"
@interface HDStockTabBarController ()

@end

@implementation HDStockTabBarController
#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#999999"];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = MAIN_COLOR;
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setThyTabBar];

}

- (void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
    //[self layoutControllerSubViews];

}

- (void)layoutControllerSubViews{
    
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"statusBarRect%@",NSStringFromCGRect(statusBarRect));
    NSLog(@"tabBar%@",NSStringFromCGRect(self.tabBar.frame));
    NSLog(@"tabBarbounds%@",NSStringFromCGRect(self.view.bounds));
    
    if (statusBarRect.size.height == 20) {
        
        self.tabBar.y  = SCREEN_HEIGHT - 49;
        
    }else{
        
        self.tabBar.y  = SCREEN_HEIGHT - 69;
    }
    [self.view layoutSubviews];
}


- (void) setThyTabBar {
    
    self.HDtabBar.tintColor = MAIN_COLOR;
    self.HDtabBar.myDelegate = self;
    
    [self setValue:self.HDtabBar forKey:@"tabBar"];
    
    self.delegate = self;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"home_subtable_bg"]];
    [imageView setContentMode:UIViewContentModeTop];
    imageView.clipsToBounds = YES;
    [self.tabBar insertSubview:imageView atIndex:0];
}

//- (void) setUpOneChildVcWithVc:(UIViewController*)vc tbbarImage:(NSString *)imageStr tbbarSelectedImage:(NSString *)selectedImageStr title:(NSString*)title {
//    
//    HDStockCenterNavigationController * nav = [[HDStockCenterNavigationController alloc] initWithRootViewController:vc];
//    [self addChildViewController:nav];
//    
//    vc.view.backgroundColor = [UIColor whiteColor];
//    vc.tabBarItem.image = [[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc.tabBarItem.title = title;
//    vc.title = title;
//    
//}


/** 自定义的tabbr上的按钮点击事件协议方法*/
- (void)tabBarPlusBtnClick:(ZHTabBar *)thyTabBar {
    NSString * classStr = NSStringFromClass([PersonalproductViewController class]);
    id targetVC = [[NSClassFromString(classStr) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetVC];
    [self presentViewController:nav animated:YES completion:^{
        
        
    }];

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
