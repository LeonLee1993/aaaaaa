//
//  HDHeaderView.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/18.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDHeaderView.h"

@interface HDHeaderView()

@property (nonatomic, strong) UIButton * button;

@property (nonatomic, strong) UIView * view;

@end

@implementation HDHeaderView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.button = [[UIButton alloc]init];
        self.view = [[UIView alloc]init];
        
        self.button.enabled = NO;
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.button.backgroundColor = COLOR(whiteColor);
        [self.button setTitle:@"头条" forState:UIControlStateDisabled];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [self.button setImage:imageNamed(@"home_toutiao_icon") forState:UIControlStateDisabled];

        self.view.backgroundColor = [UIColor colorWithRed:238.0f/256.0f green:238.0f/256.0f blue:238.0f/256.0f alpha:1.0f];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.button];
        [self addSubview:self.view];
        
    }
    
    return self;

}


- (void)layoutSubviews{

    self.button.frame = CGRectMake(0, 0, self.width/3.0f, self.height);
    self.button.centerX = self.centerX;
    
    self.view.frame = CGRectMake(0, self.height - 1, self.width, 1);

}


@end
