//
//  MBProgressHUD+Extension.h
//  YJCard
//
//  Created by paradise_ on 2017/7/18.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)

+ (void)showWithText:(NSString *)textStr;

+ (id)showWithText:(NSString *)textStr andState:(MBProgressHUDMode)mode andView:(UIView *)view;

-(void)LYCHide;
+ (id)iOS8showWithText:(NSString *)textStr andView:(UIView *)view;
@end
