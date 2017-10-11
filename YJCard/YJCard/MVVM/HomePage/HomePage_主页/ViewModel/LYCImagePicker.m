//
//  LYCImagePicker.m
//  HDStock
//
//  Created by liyancheng on 16/12/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCImagePicker.h"

@interface LYCImagePicker ()

@end

@implementation LYCImagePicker

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                                     forBarPosition:UIBarPositionAny
                                                         barMetrics:UIBarMetricsDefault];
        [self.navigationBar setTitleTextAttributes:@{
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                                     }];
    }
    return self;
}

- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
