//
//  UIAlertTool.h

//  提示框封装
//
//  Created by zh on 15/11/26.
//  Copyright © 2015年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void(^UIAlertViewShow)(NSInteger buttonIndex);


typedef void (^cancle)();
typedef void (^myActionTag)(NSInteger tag);

@interface UIAlertTool : NSObject

+ (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherButtonTitleArr:(NSArray *)otherButtonTitleArr confirmAction:(void (^)(NSInteger tag))confirm cancleAction:(void (^)())cancle style:(UIAlertControllerStyle)style;

//ios之前调用 
+ (void)titleWithName:(NSString *)titleName   showMessage:(NSString *)showMssage btn1:(NSString *)btn1 btn2:(NSString *)btn2 actionWithName:(UIAlertViewShow)action;

@end





