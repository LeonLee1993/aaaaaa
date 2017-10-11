//
//  MarketRefreshButton.m
//  HDStock
//
//  Created by liyancheng on 17/2/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "MarketRefreshButton.h"

@implementation MarketRefreshButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(9, 5, 14, 12);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(28, 5, 40, 12);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGBCOLOR(153,153,153).CGColor;
    self.layer.cornerRadius = 12;
    
}

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
