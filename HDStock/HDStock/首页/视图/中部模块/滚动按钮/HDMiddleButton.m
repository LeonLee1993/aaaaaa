//
//  HDMiddleButton.m
//  HDStock
//
//  Created by hd-app02 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMiddleButton.h"


@implementation HDMiddleButton

- (instancetype)init{

    if (self = [super init]) {
        
        self.subTittle = [[UILabel alloc]init];
        [self addSubview:self.subTittle];
        
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#E3E3E3"].CGColor;
    }

    return self;

}

//修改图片内容位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat H = contentRect.size.height;
    CGFloat W = contentRect.size.width;
    
    return CGRectMake(0.0f, 0.0f, W, H * 93.0f / 138.0f);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGFloat H = contentRect.size.height;
    CGFloat W = contentRect.size.width;
    
    return CGRectMake(6.0f, H * 93.0f / 138.0f, W - 12.0f, (H - H * 93.0f / 138.0f) / 2.0f);
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat H = self.size.height;
    CGFloat W = self.size.width;
    
    self.subTittle.frame = CGRectMake(6.0f, H * 93.0f / 138.0f + (H - H * 93.0f / 138.0f) / 2.0f, W - 12.0f, (H - H * 93.0f / 138.0f) / 2.0f);

}

@end
