//
//  RefreshButtonOfMarket.m
//  HDStock
//
//  Created by liyancheng on 17/2/28.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "RefreshButtonOfMarket.h"

@implementation RefreshButtonOfMarket

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setSelected:(BOOL)selected{
    if(self.selected){
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.keyPath = @"transform.rotation.z";
        anim.toValue = @(M_PI*2);
        anim.repeatCount = MAXFLOAT;
        anim.duration = 1;
        [self.imageView.layer addAnimation:anim forKey:nil];
    }else{
        [self.imageView.layer removeAllAnimations];
    }
}

@end
