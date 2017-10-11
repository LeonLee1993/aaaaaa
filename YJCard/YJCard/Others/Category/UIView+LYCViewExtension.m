//
//  UIView+LYCViewExtension.m
//  YJCard
//
//  Created by 李颜成 on 2017/6/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "UIView+LYCViewExtension.h"
#import <objc/runtime.h>
@implementation UIView (LYCViewExtension)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(void)setCornerRadiusEqualHalfWidth:(CGFloat)cornerRadiusEqualHalfWidth{
    self.layer.cornerRadius = self.frame.size.width/2.0;
}

-(CGFloat)cornerRadiusEqualHalfWidth{
    return self.layer.cornerRadius;
}

-(void)setDefaltBackGroudColor:(UIColor *)defaltBackGroudColor{
    self.backgroundColor = MainColor;
}

-(void)setDefaltViewBackGroudColor:(UIColor *)defaltViewBackGroudColor{
    self.backgroundColor = RGBColor(243, 243, 243);
}

-(UIColor *)defaltViewBackGroudColor{
    return  self.backgroundColor;
}

-(UIColor *)defaltBackGroudColor{
    return self.backgroundColor;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)borderWidth
{
    return self.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return self.borderColor;
    
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (CGSize)lyc_size
{
    return self.frame.size;
}

- (void)setLyc_size:(CGSize)lyc_size
{
    CGRect frame = self.frame;
    frame.size = lyc_size;
    self.frame = frame;
}

- (CGFloat)lyc_width
{
    return self.frame.size.width;
}

- (CGFloat)lyc_height
{
    return self.frame.size.height;
}

- (void)setLyc_width:(CGFloat)lyc_width
{
    CGRect frame = self.frame;
    frame.size.width = lyc_width;
    self.frame = frame;
}

- (void)setLyc_height:(CGFloat)lyc_height
{
    CGRect frame = self.frame;
    frame.size.height = lyc_height;
    self.frame = frame;
}

- (CGFloat)lyc_x
{
    return self.frame.origin.x;
}

- (void)setLyc_x:(CGFloat)lyc_x
{
    CGRect frame = self.frame;
    frame.origin.x = lyc_x;
    self.frame = frame;
}

- (CGFloat)lyc_y
{
    return self.frame.origin.y;
}

- (void)setLyc_y:(CGFloat)lyc_y
{
    CGRect frame = self.frame;
    frame.origin.y = lyc_y;
    self.frame = frame;
}

- (CGFloat)lyc_centerX
{
    return self.center.x;
}

- (void)setLyc_centerX:(CGFloat)lyc_centerX
{
    CGPoint center = self.center;
    center.x = lyc_centerX;
    self.center = center;
}

- (CGFloat)lyc_centerY
{
    return self.center.y;
}

- (void)setLyc_centerY:(CGFloat)lyc_centerY
{
    CGPoint center = self.center;
    center.y = lyc_centerY;
    self.center = center;
}

- (CGFloat)lyc_right
{
    //    return self.lyc_x + self.lyc_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)lyc_bottom
{
    // return self.lyc_y + self.lyc_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setLyc_right:(CGFloat)lyc_right
{
    self.lyc_x = lyc_right - self.lyc_width;
}

- (void)setLyc_bottom:(CGFloat)lyc_bottom
{
    self.lyc_y = lyc_bottom - self.lyc_height;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


@end
