//
//  buttonOfFirstCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buttonOfFirstCell.h"

@implementation buttonOfFirstCell

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    return CGRectMake(width/2-30, 43, 60, 15);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetWidth(contentRect);
    return CGRectMake(width/2-10, 15, 20, 20);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}

@end
