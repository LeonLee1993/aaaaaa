//
//  fullPageFailLoadView.m
//  HDStock
//
//  Created by liyancheng on 16/12/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "fullPageFailLoadView.h"

@implementation fullPageFailLoadView{
    CGRect framed;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        framed = frame;
        _fullfailLoad = [[HDFailLoadView alloc]init];
        [self addSubview:_fullfailLoad];
        self.backgroundColor= BACKGROUNDCOKOR;
    }
    return self;
}


-(void)layoutSubviews{
    UINavigationController *nav =(UINavigationController *)self.superview.parentController.parentViewController;
    if(!nav.navigationBar.hidden){
        _fullfailLoad.frame = CGRectMake(0, 64-framed.origin.y, SCREEN_WIDTH, 128);
    }else{
        _fullfailLoad.frame = CGRectMake(0, 64+64-framed.origin.y, SCREEN_WIDTH, 128);
    }
    [_fullfailLoad.button addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshButtonClicked{
    if([_delegate respondsToSelector:@selector(popMenuDidClickRefresh:)]){
        [_delegate popMenuDidClickRefresh:self];
    }
}

-(void)hide{
    self.hidden = YES;
    self.firstAddFlag = NO;
}

-(void)showWithAnimation{
    if(!self.firstAddFlag){
        self.hidden = NO;
        self.firstAddFlag = YES;
        [self.fullfailLoad hideTheSubViews];
    }
}

-(void)showWithoutAnimation{
    if(!self.firstAddFlag){
        
        self.hidden = NO;
        self.firstAddFlag = YES;
    }
    [self.fullfailLoad showTheSubViews];
}

@end
