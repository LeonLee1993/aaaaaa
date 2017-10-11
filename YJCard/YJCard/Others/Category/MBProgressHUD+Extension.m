//
//  MBProgressHUD+Extension.m
//  YJCard
//
//  Created by paradise_ on 2017/7/18.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "AppDelegate.h"

@implementation MBProgressHUD (Extension)

+ (void)showWithText:(NSString *)textStr{
    
    if(textStr.length>0){
        UIWindow *win=[[UIApplication sharedApplication].windows objectAtIndex:1];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
        if(IS_IOS_8){
            hud.mode = MBProgressHUDModeText;
        }else{
            hud.mode = MBProgressHUDModeText;
        }
//        hud.label.font = [UIFont systemFontOfSize:15];
        hud.detailsLabel.text = textStr;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        [hud hideAnimated:YES afterDelay:2];
    }
}

+ (id)iOS8showWithText:(NSString *)textStr andView:(UIView *)view{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = textStr;
    return hud;
}


+ (id)showWithText:(NSString *)textStr andState:(MBProgressHUDMode)mode andView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    hud.label.text = textStr;
    return hud;
}

-(void)LYCHide{
    [self setHidden:YES];
}



@end
