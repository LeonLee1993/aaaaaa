//
//  BuiedThirdButton.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "BuiedThirdButton.h"

@implementation BuiedThirdButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.bottomLine = [[UIView alloc]init];
        [self addSubview:self.bottomLine];
    }
    return self;
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 16, CGRectGetWidth(contentRect), 12);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomLine.frame = CGRectMake(CGRectGetWidth(self.frame)/8, CGRectGetMaxY(self.frame)-2, CGRectGetWidth(self.frame)/4*3, 2);
    self.bottomLine.backgroundColor = RGBCOLOR(25,121,202);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    if(self.selected){
        self.titleLabel.textColor = RGBCOLOR(153,153,153);
        self.bottomLine.hidden = YES;
    }else{
        self.titleLabel.textColor = RGBCOLOR(25,121,202);
        self.bottomLine.hidden = NO;
    }
    
}

@end
