//
//  UIView+LYCViewExtension.h
//  YJCard
//
//  Created by 李颜成 on 2017/6/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYCViewExtension)

@property (nonatomic, assign) CGSize lyc_size;
@property (nonatomic, assign) CGFloat lyc_width;
@property (nonatomic, assign) CGFloat lyc_height;
@property (nonatomic, assign) CGFloat lyc_x;
@property (nonatomic, assign) CGFloat lyc_y;
@property (nonatomic, assign) CGFloat lyc_centerX;
@property (nonatomic, assign) CGFloat lyc_centerY;

@property (nonatomic, assign) CGFloat lyc_bottom;
@property (nonatomic, assign) CGFloat lyc_right;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadiusEqualHalfWidth;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor * borderColor;
@property(nonatomic, assign) IBInspectable UIColor * defaltBackGroudColor;

@property(nonatomic, assign) IBInspectable UIColor * defaltViewBackGroudColor;//界面默认背景

+ (instancetype)viewFromXib;
@end
