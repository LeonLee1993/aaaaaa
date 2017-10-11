//
//  LYCBaseViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYCPoorNetworkView.h"
@interface LYCBaseViewController : UIViewController

//- (void)setNavigationBarBackGroudColor:(UIColor *)color title:(NSString *)titleStr titleFont:(CGFloat )titleFont goBackImage:(UIImage *)backImage goBackTitle:(NSString *)goBackTitle titleColor:(UIColor *)titleColor;

@property (nonatomic,strong) AFHTTPSessionManager *mgr;
@property (nonatomic,strong) LYCPoorNetworkView * poorNetWorkView;

@end
