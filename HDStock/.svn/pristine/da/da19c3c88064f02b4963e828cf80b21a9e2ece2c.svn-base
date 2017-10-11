//
//  MarketAddButton.m
//  HDStock
//
//  Created by liyancheng on 17/2/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "MarketAddButton.h"

@implementation MarketAddButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(28, 14, 17, 17);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(49, 14, 70, 16);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = RGBCOLOR(240,163,88);
    self.layer.cornerRadius = 22;
}

//-(void)setSelected:(BOOL)selected{
//    if(selected){
//        self.alpha = 0.7;
//    }else{
//        self.alpha = 1;
//    }
//}

-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.alpha = 0.7;
    }else{
        self.alpha = 1;
    }
}

@end
