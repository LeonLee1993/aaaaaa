//
//  TendentIconButton.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentIconButton.h"

@implementation TendentIconButton{
    CGFloat perPt;
    CGFloat imageWidth;
    CGFloat imageHeight;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    perPt = self.frame.size.width/50.0*1.2;
    self.defaultColor = self.titleLabel.textColor;

    
    UIImage *image = [UIImage imageNamed:@"地图icon"];
    imageWidth = image.size.width/2;
    imageHeight = image.size.height/2;
    
    [self setImage:[UIImage imageNamed:@"地图icon"] forState:UIControlStateNormal];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:UIControlStateNormal];
    imageWidth = self.imageView.image.size.width/2;
    imageHeight = self.imageView.image.size.height/2;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-perPt*imageWidth, contentRect.size.width/2-(perPt*(imageHeight+2)), perPt*imageWidth*2, perPt*imageHeight*2);
}



@end
