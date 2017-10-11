//
//  SystemSettingViewController.h
//  HDStock
//
//  Created by liyancheng on 16/11/25.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCBaseViewController.h"
@class HDLeftMainViewController;
@interface SystemSettingViewController : LYCBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *goBackImage;
@property (weak, nonatomic) IBOutlet UIView *cacheView;
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIView *goBackView;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIView *resignPresentCountView;

@property (weak,nonatomic) HDLeftMainViewController *hdLeft;

@end
