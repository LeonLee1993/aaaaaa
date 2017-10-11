//
//  UIAlertTool.m

//  提示框封装
//
//  Created by zh on 15/11/26.
//  Copyright © 2015年 zh. All rights reserved.
//

#import "UIAlertTool.h"

static UIAlertViewShow _alertShow;

@interface UIAlertTool () <UIAlertViewDelegate>

@end

static cancle _cancel;
static myActionTag  _myActionTag;

@implementation UIAlertTool

+(void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherButtonTitleArr:(NSArray *)otherButtonTitleArr confirmAction:(void (^)(NSInteger))confirm cancleAction:(void (^)())cancle style:(UIAlertControllerStyle)style{
    
    _myActionTag = confirm;
    _cancel = cancle;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle();
    }];
    NSInteger myTag = 0;
    for (int i = 0 ; i < otherButtonTitleArr.count; i ++) {
        myTag ++;
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitleArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm(myTag);
        }];
        [alertController addAction:otherAction];
    }
    // Add the actions.
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)titleWithName:(NSString *)titleName  showMessage:(NSString *)showMssage btn1:(NSString *)btn1 btn2:(NSString *)btn2 actionWithName:(UIAlertViewShow)action
{
    _alertShow = action;
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:titleName message:showMssage delegate:[self self] cancelButtonTitle:btn1 otherButtonTitles:btn2, nil];
    [showAlert show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertShow(buttonIndex);
}




@end
