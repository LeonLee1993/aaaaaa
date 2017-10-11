//
//  HDMarketSearchTF.m
//  HDStock
//
//  Created by liyancheng on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMarketSearchTF.h"

@implementation HDMarketSearchTF

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect SearchRect = [super leftViewRectForBounds:bounds];
    SearchRect.origin.x +=10;
    return SearchRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super editingRectForBounds:bounds];
    placeholderRect.origin.x +=20;
    return placeholderRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x +=18;
    return editingRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 18;
    return textRect;
}

@end
