//
//  PayMoneyCodeNumButton.m
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PayMoneyCodeNumButton.h"

@implementation PayMoneyCodeNumButton

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
    }
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/120*48.5, contentRect.size.height/2-contentRect.size.height/50*8.5, contentRect.size.width/120*24, contentRect.size.width/120*17);
}

@end
