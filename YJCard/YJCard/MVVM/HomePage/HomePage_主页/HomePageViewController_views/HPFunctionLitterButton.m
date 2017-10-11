//
//  HPFunctionLitterButton.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "HPFunctionLitterButton.h"

@implementation HPFunctionLitterButton{
    CGFloat perPt;
    CGFloat imageWidth;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    perPt = self.frame.size.height/95.0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:RGBColor(76,76,76) forState:UIControlStateNormal];
    self.defaultColor = self.titleLabel.textColor;
    imageWidth = self.imageView.image.size.width/2;
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-perPt*imageWidth, perPt*15, perPt*imageWidth*2, perPt*28);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, perPt *51, contentRect.size.width, 13);
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        [self setTitleColor:RGBAColor(117, 117, 117,0.2) forState:UIControlStateHighlighted];
    }else{
        [self setTitleColor:self.defaultColor forState:UIControlStateNormal];
    }
}

@end
