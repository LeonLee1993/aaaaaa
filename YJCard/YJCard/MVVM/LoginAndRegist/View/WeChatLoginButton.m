//
//  WeChatLoginButton.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "WeChatLoginButton.h"
//extern CGFloat const 0.4;
@implementation WeChatLoginButton{
    CGFloat perPt;
    NSArray * colorArr;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    perPt = self.frame.size.width/80.0;
    [self setTitleColor:RGBColor(134,133,133) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.originColor = self.titleLabel.textColor;
    colorArr= [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(8*perPt, 9*perPt, 12*perPt, 12*perPt);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(28*perPt, 9*perPt , 56*perPt, 12*perPt);
}
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        [self setTitleColor:[UIColor colorWithRed:[colorArr[1] floatValue]-0.4 green:[colorArr[2]floatValue]-0.4 blue:[colorArr[3]floatValue]-0.4 alpha:1] forState:UIControlStateHighlighted];
    }else{
        [self setTitleColor:self.originColor forState:UIControlStateNormal];
    }
}

@end
