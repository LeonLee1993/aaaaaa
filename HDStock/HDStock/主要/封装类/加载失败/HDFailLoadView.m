//
//  HDFailLoadView.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDFailLoadView.h"

@interface HDFailLoadView(){



}

@end


@implementation HDFailLoadView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {

        _imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageview.image = [UIImage imageNamed:@"jiazaishibai_pic"];
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.text = @"股博士走丢了";
        _label.font = [UIFont systemFontOfSize:11];
        _label.textColor = [UIColor darkGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        
        _button = [[UIButton alloc]initWithFrame:CGRectZero];
        [_button setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _hud = [[PSYProgresHUD alloc]init];
        
        [self addSubview:_hud];
        
        [self addSubview:_imageview];
        [self addSubview:_label];
        [self addSubview:_button];
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        _imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageview.image = [UIImage imageNamed:@"jiazaishibai_pic"];
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.text = @"股博士走丢了";
        _label.font = [UIFont systemFontOfSize:11];
        _label.textColor = [UIColor darkGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        
        _button = [[UIButton alloc]initWithFrame:CGRectZero];
        [_button setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _hud = [[PSYProgresHUD alloc]init];
        
        [self addSubview:_hud];
        
        [self addSubview:_imageview];
        [self addSubview:_label];
        [self addSubview:_button];
    }

    return self;
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    _imageview.frame = CGRectMake(0, 0, self.height * 3 /5 * 79 / 66, self.height * 3 /5);
    
    _imageview.centerX = self.centerX;
    
    _label.frame = CGRectMake(0, CGRectGetMaxY(_imageview.frame) + 15, self.width, 12);
    
    _button.frame = CGRectMake(0, CGRectGetMaxY(_label.frame) + 10, self.width, 12);

    _hud.frame = CGRectMake(0, 0, 414 * FITWIDTHBASEONIPHONEPLUS
                            , 128 * FITHEIGHTBASEONIPHONEPLUS);
    _hud.center = self.center;

}


- (void)hideTheSubViews{

    _imageview.hidden = YES;
    _label.hidden = YES;
    _button.hidden = YES;
    [_hud showAnimated:YES];

}

- (void)showTheSubViews{

    [_hud hideAnimated:YES];
    _imageview.hidden = NO;
    _label.hidden = NO;
    _button.hidden = NO;

}

@end
