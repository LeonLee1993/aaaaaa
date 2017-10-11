//
//  payAttentionButton.m
//  HDStock
//
//  Created by liyancheng on 17/1/10.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "payAttentionButton.h"

@implementation payAttentionButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setTitle:@"持续关注" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitle:@"已关注" forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)layoutSubviews{
    if(self.selected){
        self.backgroundColor = RGBCOLOR(243,243,243);
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.backgroundColor = RGBCOLOR(210,48,76);
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-50, contentRect.size.height/2-10, 100, 20);
}

-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
     self.alpha = 0.8;
    }else{
        self.alpha = 1.0;
    }
}

@end
