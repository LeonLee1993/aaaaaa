//
//  PSYLabel.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYLabel.h"

@implementation PSYLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
