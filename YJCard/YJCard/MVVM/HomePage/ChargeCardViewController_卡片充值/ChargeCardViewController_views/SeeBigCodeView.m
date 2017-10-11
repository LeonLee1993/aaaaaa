//
//  SeeBigCodeView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SeeBigCodeView.h"

@implementation SeeBigCodeView



+ (instancetype)initWithView:(UIView *)view andViewFrame:(CGRect )viewframe andCodeType:(LYCSeeBigCodeType)type{
    static SeeBigCodeView *instance = nil;
        instance = [[self alloc]init];
        instance.codeView = view;
        instance.codeViewFrame = viewframe;
        instance.codeType = type;
        instance.frame = [UIScreen mainScreen].bounds;
    return instance;
}

-(void)didMoveToSuperview{
    
    if(self.codeType == orginalCodeIsBite){
        _codeView.alpha = 0;
        _codeView.frame = self.codeViewFrame;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_codeView];
        [UIView animateWithDuration:1 animations:^{
            _codeView.alpha = 1;
            _codeView.frame = CGRectMake(0, 0, self.codeViewFrame.size.width *1.2, self.codeViewFrame.size.width *1.2);
            _codeView.center = self.center;
            self.backgroundColor = [UIColor whiteColor];
        }];
    }else{
        _codeView.alpha = 0;
        _codeView.frame = self.codeViewFrame;
        UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        codeLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.codeView.frame)+10);
        codeLabel.text = self.barCodeStr;
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:codeLabel];
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_codeView];
        [UIView animateWithDuration:1 animations:^{
            _codeView.alpha = 1;
            _codeView.frame = CGRectMake(0, 0, self.codeViewFrame.size.width * 1.7, self.codeViewFrame.size.height * 1.7);
            _codeView.transform = CGAffineTransformMakeRotation(M_PI_2);
            _codeView.center = CGPointMake(self.center.x+30, self.center.y);
            
            codeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            codeLabel.frame = CGRectMake(0, 0, codeLabel.frame.size.width * 1.7, codeLabel.frame.size.height * 1.7);
            codeLabel.center = CGPointMake(_codeView.frame.origin.x - 20, self.center.y);
            
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

-(void)dealloc{
//    NSLog(@"delloc");
}

@end
