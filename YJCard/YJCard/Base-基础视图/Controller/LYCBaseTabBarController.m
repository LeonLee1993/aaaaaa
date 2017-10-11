//
//  LYCBaseTabBarController.m
//  YJCard
//
//  Created by 李颜成 on 2017/6/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseTabBarController.h"
#import "LYCBaseNacVC.h"
#import "LYCTabBar.h"

#import "HomePageViewController.h"//首页
#import "CarTeamCardManageViewController.h"//车队卡
#import "PersonalMainViewController.h"//我的

@interface LYCBaseTabBarController ()

@end

@implementation LYCBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildViewControllers];
    [self setupItemTitleTextAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    [self setupTabBar];
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    
    [self setSelectedIndex:1];

}

- (void)setupItemTitleTextAttributes
{
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [UITabBar appearance].translucent = NO;
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MainColor;
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage tagIndex:(NSInteger )index
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.tag = index;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}

- (void)setupChildViewControllers
{
    [self setupOneChildViewController:[[LYCBaseNacVC alloc] initWithRootViewController:[[HomePageViewController alloc] init]] title:@"" image:@"首页-未选中" selectedImage:@"首页-选中" tagIndex:201];
    
    [self setupOneChildViewController:[[LYCBaseNacVC alloc] initWithRootViewController:[[CarTeamCardManageViewController alloc] init]] title:@"" image:@"卡片-未选中" selectedImage:@"卡片-选中" tagIndex:202];
    
    [self setupOneChildViewController:[[LYCBaseNacVC alloc] initWithRootViewController:[[PersonalMainViewController alloc] init]] title:@"" image:@"我的-未选中" selectedImage:@"我的-选中" tagIndex:203];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)setupTabBar{
    [self setValue:[[LYCTabBar alloc] init] forKeyPath:@"tabBar"];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 201:
        {
            [MobClick event:@"tabBarSelectedHome"];
        }
            break;
            
        case 202:
        {
            [MobClick event:@"tabBarSelectedCardManager"];
        }
            break;
            
        case 203:
        {
            [MobClick event:@"tabBarSelectedPersonalCenter"];
        }
            break;
            
        default:
            break;
    }
}

@end
