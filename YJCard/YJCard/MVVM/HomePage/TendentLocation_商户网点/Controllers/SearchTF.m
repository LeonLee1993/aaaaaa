//
//  SearchTF.m
//  YJCard
//
//  Created by paradise_ on 2017/8/17.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SearchTF.h"

@implementation SearchTF

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect SearchRect = [super leftViewRectForBounds:bounds];
    SearchRect.origin.x +=10;
    return SearchRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super editingRectForBounds:bounds];
    placeholderRect.origin.x +=15;
    return placeholderRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x +=13;
    return editingRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 13;
    return textRect;
}

@end
