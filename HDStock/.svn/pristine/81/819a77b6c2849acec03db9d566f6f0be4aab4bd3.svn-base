//
//  PSYButton.m
//  自定义宫格排版按钮
//
//  Created by hd-app02 on 16/11/10.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYButton.h"

@implementation PSYButton

//修改文本内容位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat H = contentRect.size.height;
    CGFloat W = contentRect.size.width;
    
    return CGRectMake(0.0f, H*3/4 + 7, W, H/4);
}

//修改图片内容位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat H = contentRect.size.height;
    CGFloat W = contentRect.size.width;
    
    return CGRectMake((W - H*3/4)/2, 0.0f, H*3/4, H*3/4);
}



@end
