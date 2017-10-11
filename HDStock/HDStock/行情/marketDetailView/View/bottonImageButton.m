//
//  bottonImageButton.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "bottonImageButton.h"

@implementation bottonImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if(self==[super initWithFrame:frame]){
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect);
    return CGRectMake(width/2-5, height/2-8, 65, 15);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect);
    return CGRectMake(width/2-25, height/2-8, 15, 15);
}



@end
