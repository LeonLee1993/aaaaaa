//
//  LYCHelper.h
//  YJCard
//
//  Created by paradise_ on 2017/7/27.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCHelper : NSObject

@property (nonatomic,strong) UIViewController * selfVC;
//显示警告栏
+ (void)presentAlerControllerWithMessage:(NSString *)message andVC:(id)viewController;

//根据文字的一些属性来得到文字的占位空间
/*
 string:需要计算的字符串
 attridic:属性字典
 lineSpace:字间距
 borderspace:两边的距离 左右空加起来
 */
#pragma mark - 得到String的Size
+ (CGSize)getsizeOfString:(NSString *)string andAttribute:(NSDictionary *)attridic andLineSpace:(NSInteger )lineSpace andBorderSpace:(NSInteger )borderspace fontSize:(CGFloat )fontSize;


#pragma mark - 验证身份证号码
+ (BOOL)validateIDCardNumber:(NSString *)value;

#pragma mark - 分享功能
+ (void)shareBoardBySelfDefined;

#pragma mark - 单例
+ (instancetype)helper;
@end
