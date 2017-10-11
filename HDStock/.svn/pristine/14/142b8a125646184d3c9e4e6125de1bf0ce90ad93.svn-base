//
//  HDPSYMessageAlertManager.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPSYMessageAlertManager.h"
#import "HDPSYMessageAlert.h"

@implementation HDPSYMessageAlertManager

+ (void)showMessage:(NSString *)string{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    HDPSYMessageAlert * alert = [[HDPSYMessageAlert alloc]initWithFrame:CGRectMake(0, - rect.size.height, SCREEN_WIDTH, rect.size.height)];
    
    [window addSubview:alert];
    
    NSLog(@"%@",NSStringFromClass([window.rootViewController class]));
    
    [UIView animateWithDuration:5 animations:^{
        alert.frame = CGRectMake(0, NAV_STATUS_HEIGHT, SCREEN_WIDTH, rect.size.height);

    } completion:^(BOOL finished) {
        
        
    }];
    
}


@end
