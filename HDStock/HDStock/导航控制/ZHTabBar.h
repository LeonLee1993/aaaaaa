//
//  ZHTabBar.h
//  自定义tabbar
//
//  Created by hd-app01 on 16/11/3.
//  Copyright © 2016年 hd-app01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHTabBar;
@protocol ZHTabBarDelegate <NSObject>
@optional
//-(void) tabBarPostBtnClicked:(ZHTabBar*)thyTabBar;

-(void) tabBarPlusBtnClick:(ZHTabBar*)thyTabBar;
@end

@interface ZHTabBar : UITabBar

/**设置tabbar代理，让点击了中间自定义的按钮后能响应*/
@property (nonatomic,weak) id <ZHTabBarDelegate> myDelegate;

@end
