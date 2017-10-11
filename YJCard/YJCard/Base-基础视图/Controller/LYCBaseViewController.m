//
//  LYCBaseViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//
#import "GlobelGoBackButton.h"
#import "LYCBaseViewController.h"
#import "LYCPoorNetworkView.h"
@interface LYCBaseViewController ()

@end

@implementation LYCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(LYCPoorNetworkView *)poorNetWorkView{
    if(!_poorNetWorkView){
        _poorNetWorkView = [LYCPoorNetworkView viewFromXib];
//        UIWindow *window = [[[UIApplication sharedApplication]windows]lastObject];
        _poorNetWorkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _poorNetWorkView;
}

//- (void)setNavigationBarBackGroudColor:(UIColor *)color title:(NSString *)titleStr titleFont:(CGFloat )titleFont goBackImage:(UIImage *)backImage goBackTitle:(NSString *)goBackTitle titleColor:(UIColor *)titleColor{
//    
//    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:color]
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    btn.frame = CGRectMake(0, 0, 80, 44);
//    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [btn setTitle:goBackTitle forState:(UIControlStateNormal)];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [btn setTitleColor:MainColor forState:UIControlStateNormal];
//    [btn setImage:backImage forState:UIControlStateNormal];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -26.5, 0, 0)];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -21.5, 0, 0)];
//    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
//    [btn addTarget:self action:@selector(backItemWithCustemViewBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:titleFont],NSForegroundColorAttributeName:titleColor};
//    
//    self.title = titleStr;
//}

- (void)backItemWithCustemViewBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (UIImage*) createImageWithColor:(UIColor*) color
//{
//    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
//}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}


@end
