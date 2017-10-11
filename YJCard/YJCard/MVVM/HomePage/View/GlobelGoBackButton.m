//
//  GlobelGoBackButton.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "GlobelGoBackButton.h"
//extern CGFloat const 0.4;
@implementation GlobelGoBackButton{
    CGFloat perPt;
    NSMutableArray * colorArr ;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    colorArr = @[].mutableCopy;
    perPt = self.frame.size.width/80.0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.originColor = self.titleLabel.textColor;
    NSArray *arr = [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
    [colorArr addObjectsFromArray:arr];
    if(colorArr.count==3){
        [colorArr addObject:@"1"];
    }
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(12*perPt,contentRect.size.height/2-7.5*perPt,7.5*perPt,15*perPt);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(23*perPt, contentRect.size.height/2-8*perPt, 56*perPt, 16*perPt);
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        
        [self setTitleColor:[UIColor colorWithRed:[colorArr[1] floatValue]-0.4 green:[colorArr[2]floatValue]-0.4 blue:[colorArr[2]floatValue]-0.4 alpha:1] forState:UIControlStateHighlighted];
    }else{
        [self setTitleColor:self.originColor forState:UIControlStateNormal];
    }
}


@end
