//
//  HDFontChooseView.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/16.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDFontChooseView.h"



@implementation HDFontChooseView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        CGFloat W = frame.size.width;
        CGFloat H = frame.size.height;
        
        for(int i = 0;i < 3;i++){
        
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * W, 0, W, H)];
            if (i == 0) {
                
                [button setTitle:@"小" forState:UIControlStateNormal];
            }else if(i == 1){
            
                [button setTitle:@"中" forState:UIControlStateNormal];
            
            }else if(i == 2){
                
                [button setTitle:@"大" forState:UIControlStateNormal];
            }
            
            [button.titleLabel setTextColor:[UIColor blackColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [button setBackgroundColor:RGBCOLOR(238, 238, 238)];
            button.tag = 1200 + i;
            [button addTarget:self action:@selector(buttonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
        
            [self addSubview:button];
        
        
        }
    }

    return self;

}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat W = self.frame.size.width/3.0f;
    CGFloat H = self.frame.size.height;
    
    for(int i = 0;i < self.subviews.count;i++){
        
        UIButton * button = self.subviews[i];
        
        button.frame = CGRectMake(i * W, 0, W, H);
    
    }

}

- (void)buttonOnTouched:(UIButton * )button{

    [self.delegate chooseButtonOntouched:button];

}
@end
