//
//  HDVertionCheckAlertShowView.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDVertionCheckAlertShowView.h"

@implementation HDVertionCheckAlertShowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alertView = [[HDVertionCheckAlertView alloc]initWithFrame:CGRectZero];
        [self.alertView.cancelButton addTarget:self action:@selector(buttonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView.sureButton addTarget:self action:@selector(buttonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.alertView];
        [self addBackgroundView];
        [self addTapGesture];
    }
    return self;
}

- (void)addBackgroundView {

    UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self insertSubview:backgroundView atIndex:0];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)addTapGesture {
    self.userInteractionEnabled = YES;
    //单指单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];

    [self addGestureRecognizer:singleTap];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(265.0f * FITWIDTHBASEONIPHONEPLUS, 290.0f * FITHEIGHTBASEONIPHONEPLUS));
        make.center.equalTo(self);
        
    }];

}

- (void)buttonOnTouched:(UIButton *)button{

    [self.delegate upDateTheVertion:button];
    
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    
    
}

- (void)showAlertView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}

- (void)dismissAlertView{
    
    [self removeFromSuperview];

}
@end
