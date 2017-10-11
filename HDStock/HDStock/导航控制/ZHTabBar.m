//
//  ZHTabBar.m
//  自定义tabbar
//
//  Created by hd-app01 on 16/11/3.
//  Copyright © 2016年 hd-app01. All rights reserved.
//

#import "ZHTabBar.h"
#import "UIView+ZHExtension.h"
#import "UIImage+Image.h"

#define ZHMagin (10 * WIDTH)
//#define LBMagin 10
@interface ZHTabBar ()

@property (nonatomic,strong) UIButton * plusBtn;

@property (nonatomic,strong) UILabel * plusLab;

@end

@implementation ZHTabBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        //覆盖原生Tabbar的上横线
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
        //背景图片为透明色
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
        
        //设置为半透明
        //self.translucent = YES;
        //中间自定义按钮
        _plusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"service"] forState:UIControlStateHighlighted];
        [_plusBtn addTarget:self action:@selector(postBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plusBtn];
        [self.plusBtn setContentMode:UIViewContentModeCenter];
        
        self.plusLab = [UILabel new];
        [self addSubview:self.plusLab];
    }

    return self;
}


- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //覆盖原生Tabbar的上横线
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
        //背景图片为透明色
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
        
        
        //设置为半透明
        self.translucent = YES;
        //中间自定义按钮
        UIButton * plusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"service"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(postBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
        self.plusLab = [UILabel new];
        [self addSubview:self.plusLab];
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    Class class = NSClassFromString(@"UITabBarButton");
    
    //确定自定义按钮位置和大小
    CGSize imageSize = [UIImage imageNamed:@"service"].size;
    //CGFloat pw = self.width/5.0f - ZHMagin * 2;
    CGFloat pw = imageSize.width;
    CGFloat ph = imageSize.height;
    //CGFloat ph = pw * 102.0f / 106.0f;

    if (kScreenIphone4 || kScreenIphone5) {
    
        self.plusBtn.frame = CGRectMake(self.width/5.0f*2.0f + ZHMagin - 5.0f, -ph * 0.4, pw + 10.0f, ph + 10.0f);
    
    }else{
    self.plusBtn.frame = CGRectMake(self.width/5.0f*2.0f + ZHMagin, -ph * 0.4, pw, ph);
    }

    //确定自定义label位置和大小
    self.plusLab.text = @"牛工厂";
    self.plusLab.font = [UIFont systemFontOfSize:11];
    self.plusLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.plusLab sizeToFit];
    self.plusLab.centerX = self.plusBtn.centerX;
    self.plusLab.centerY = self.size.height - self.plusLab.height/2.0f -2;
    int index = 0;
    for (UIView * btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            btn.width = self.width/5;
            btn.x = btn.width*index;
            
            index++;
        }
        if (index == 2) {
            index++;
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];
    [self bringSubviewToFront:self.plusLab];
    
}

- (void) postBtnDidClick {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isHidden) {
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];
        if ([self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        }else {
            return [super hitTest:point withEvent:event];
        }
    }else {
        return [super hitTest:point withEvent:event];
    }
}


@end
