//
//  TendentMainPageControl.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentMainPageControl.h"

@implementation TendentMainPageControl

-(id) initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
       self.activeImage = [UIImage imageNamed:@"滚动1"];
        self.inactiveImage = [UIImage imageNamed:@"滚动2"];
    }
    return self;
}

-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        CGSize size;
        
        size.height = 7;     //自定义圆点的大小
        
        size.width = 7;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        dot.clipsToBounds = NO;
        dot.layer.cornerRadius = 0;
        if (i==self.currentPage){
            dot.backgroundColor = MainColor;
        }
        else dot.backgroundColor = MainBackViewColor;
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}
@end
