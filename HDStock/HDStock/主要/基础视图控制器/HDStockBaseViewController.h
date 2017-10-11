//
//  HDStockBaseViewController.h
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAdvertisementModel.h"

@interface HDStockBaseViewController : UIViewController
/**此block用于反向传值：隐藏或显示导航栏*/
@property (nonatomic,copy) void(^myBlock)();

/** 创建导航栏返回按钮：带图片和文字*/
- (void) setNavCustemViewForLeftItemWithImage:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleCoclor:(UIColor *)titleCoclor custemViewFrame:(CGRect)thyFrame;
- (void) backItemWithCustemViewBtnClicked;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
/**设置导航栏左边按钮*/
- (void) setNavBarLeftItemWithStr:(NSString *) str;
-(void) backBtnItemClicked;

/**设置导航栏右边按钮*/
- (void) setNavBarRightSubmitItem;
/**提交按钮点击事件*/
- (void) submitBtnClicked;

/**取消按钮*/
- (void) setNavBarRightCancelItem;
- (void) cancelBtnItemClicked;

/**设置按钮*/
- (void) setNavRightSettingItem;
- (void) settingBtnClicked;

/**签到按钮*/
- (void) setNavBarQianDaoLeftItem ;
- (void) qianDaoBtnClicked;

/**颜色转换图片*/
- (UIImage*) createImageWithColor:(UIColor*) color;

/**设置导航栏的字体和大小*/
- (void) setNavDic;


/**添加按钮*/
- (void) setNavBarAddRightItem;
- (void) addBtnClicked;

/**导航栏左边占位按钮*/
- (void) setNavBarLeftPlaceholderItem;


/**设置导航栏右边按钮，带text参数*/
- (void) setNavBarRightItem:(NSString *) thyTitle;
- (void) rightBarBtnClciked;

/**设置导航栏右边按钮，带image参数*/
- (void) setNavBarRightItemWithImage:(UIImage *) thyImage;
- (void) rightBarImageBtnClciked;

/**设置导航栏title样式*/
- (void)setNavDicWithTitleFont:(CGFloat)font titleColor:(UIColor *)color title:(NSString *)title;
/**设置导航栏 带箭头和返回字样的返回按钮*/
- (void) setNormalBackNav;

/** 给子视图添加滚动视图作为背景*/
- (UIScrollView *) createBgSCWithFrame:(CGRect) frame bgColor:(UIColor *)bgColor;


- (void)pan:(UIPanGestureRecognizer *)pan;

- (void)panToPopView;


- (void)showNewStatuses:(NSString *)message fromLocation:(CGFloat)from;

- (void)turnToDetailViewController:(HDAdvertisementModel *)model;
@end
