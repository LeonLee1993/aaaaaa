//
//  UIColor+HexColor.h
//  HDGolden
//
//  Created by hd-app01 on 16/10/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

/**  默认alpha的16进制颜色*/
+ (UIColor *)colorWithHexString:(NSString *)color;

/**  设置alpha的16进制颜色*/
+ (UIColor *)colorWithHexString:(NSString *)color withAlpha:(float)alpha;

@end
