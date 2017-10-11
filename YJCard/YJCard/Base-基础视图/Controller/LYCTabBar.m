//
//  LYCTabBar.m
//  YJCard
//
//  Created by paradise_ on 2017/8/21.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCTabBar.h"

@implementation LYCTabBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /**** 按钮的尺寸 ****/
    CGFloat buttonW = self.lyc_width / 3;
    CGFloat buttonH = self.lyc_height;
    
    CGFloat tabBarButtonY = 5;
    // 按钮索引
    int tabBarButtonIndex = 0;
    
    for (UIView *subview in self.subviews) {
        // 过滤掉非UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        
//        // 设置frame
        CGFloat tabBarButtonX = tabBarButtonIndex * buttonW;
        subview.frame = CGRectMake(tabBarButtonX, tabBarButtonY, buttonW, buttonH);
        
        // 增加索引
        tabBarButtonIndex++;
 
    }
    
}

@end
