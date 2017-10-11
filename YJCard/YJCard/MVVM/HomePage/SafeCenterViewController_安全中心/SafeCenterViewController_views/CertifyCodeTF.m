//
//  CertifyCodeTF.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "CertifyCodeTF.h"
NSString * const YTUnclickableTextFieldSpace = @" ";
@interface CertifyCodeTF ()

@property (nonatomic,strong) UIView * bottomLine;

@end

@implementation CertifyCodeTF

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        self.textAlignment = NSTextAlignmentCenter;
        self.bottomLine = [[UIView alloc]init];
        [self addSubview:self.bottomLine];
        self.tintColor = MainColor;
        self.borderStyle = UITextBorderStyleNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.bounds), self.frame.size.width, 0.5);
    self.bottomLine.backgroundColor = MainColor;
}

- (BOOL)becomeFirstResponder {
    self.text = YTUnclickableTextFieldSpace;
    return [super becomeFirstResponder];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}



@end
