//
//  PSYProgressNormalHUD.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "PSYProgressNormalHUD.h"

@implementation PSYProgressNormalHUD

+ (void)showHUDwithtext:(NSString *)text to:(UIViewController *)viewcontroller{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewcontroller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#1C1C1C" withAlpha:0.8];
    [hud hideAnimated:YES afterDelay: 2];

}

@end
