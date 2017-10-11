//
//  MarketStateButton.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MarketStateButton.h"

@implementation MarketStateButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectOfImage = CGRectMake(0, 0, contentRect.size.width, 2);
    return rectOfImage;
}




@end
