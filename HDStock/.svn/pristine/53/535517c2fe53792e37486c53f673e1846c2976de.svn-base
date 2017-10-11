//
//  HDLeftPersonalViewController.h
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "leftViewSetting.h"
#import "UIView_extra.h"
#import "HDLeftMainViewController.h"

@interface HDLeftPersonalViewController : UIViewController

// 滑动速度系数（建议在0.5 - 1之间）默认为0.5
@property (nonatomic,assign) CGFloat speed;

// 左侧滑窗控制器
@property (nonatomic,strong) HDLeftMainViewController *leftVc;

// 主视图控制器
@property (nonatomic,strong) UITabBarController *mainVc;

// 点击手势，是否允许点击恢复视图位置 默认开启
@property (nonatomic,strong) UITapGestureRecognizer *sideLipTapGes;

// 滑动手势
@property (nonatomic,strong) UIPanGestureRecognizer *panGes;

// 侧滑窗是否为关闭状态
@property (nonatomic,assign) BOOL sideClosed;

- (id) initWithLeftViewController:(HDLeftMainViewController *)leftVc andMainViewController:(UITabBarController *)mainVc;

- (void)closeLeftView;

- (void)openLeftView;

- (void)setPanGesEnabled:(BOOL)enabled;


@end
