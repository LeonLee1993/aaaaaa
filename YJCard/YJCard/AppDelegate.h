//
//  AppDelegate.h
//  YJCard
//
//  Created by 李颜成 on 2017/6/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;
//-(void)shareSuccessByCode:(int) code;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) id<WXDelegate> wxDelegate;

@end

