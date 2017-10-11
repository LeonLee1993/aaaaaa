//
//  ButtonOfPersonalTopView.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "ButtonOfPersonalTopView.h"

@implementation ButtonOfPersonalTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    return CGRectMake(width/2-20,28, 40, 15);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    return CGRectMake(width/2-10, 3, 20, 20);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self==[super initWithFrame:frame]){
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

@end
