//
//  NumberPadTF.m
//  YJCard
//
//  Created by paradise_ on 2017/8/1.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "NumberPadTF.h"

@implementation NumberPadTF

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        self.tintColor = [UIColor blackColor];
        self.borderStyle = UITextBorderStyleNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect SearchRect = [super leftViewRectForBounds:bounds];
    if(self.tag ==201){
    
    }else{
        
    }
    SearchRect.origin.x +=10;
    return SearchRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super editingRectForBounds:bounds];
    if(self.tag ==201){
        placeholderRect.origin.x += 22;
    }else{
        placeholderRect.origin.x += 16;
    }
    return placeholderRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    if(self.tag ==201){
        editingRect.origin.x += 22;
    }else{
        editingRect.origin.x += 14;
    }
    return editingRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    if(self.tag ==201){
        textRect.origin.x += 20;
    }else{
        textRect.origin.x += 14;
    }
    
    return textRect;
}

@end
