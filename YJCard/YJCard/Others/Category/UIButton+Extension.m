//
//  UIButton+Extension.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "UIButton+Extension.h"
#import "objc/runtime.h"
//extern CGFloat const 0.4;
@implementation UIButton (Extension)

-(void)lyc_setHighlighted{
//    objc_setAssociatedObject(self, @"originColorKey", self.titleLabel.textColor, OBJC_ASSOCIATION_RETAIN);
}

-(void)setFontSizeByScreen:(CGFloat)fontSizeByScreen{
//    if(ScreenWidth==320){
//        self.titleLabel.font = [UIFont systemFontOfSize:fontSizeByScreen*1];
//    }else if (ScreenWidth==375){
//        self.titleLabel.font = [UIFont systemFontOfSize:fontSizeByScreen*1.15];
//    }else if (ScreenWidth ==414){
//        self.titleLabel.font = [UIFont systemFontOfSize:fontSizeByScreen*1.3];
//    }
}

-(CGFloat)fontSizeByScreen{
    return  self.titleLabel.font.pointSize;
}

@end
