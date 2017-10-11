//
//  LYCStateViews.m
//  YJCard
//
//  Created by paradise_ on 2017/8/1.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCStateViews.h"

@implementation LYCStateViews{
    MBProgressHUD * mainHud;
}

+ (instancetype)LYCshowStateViewTo:(UIView *)view withState:(LYCStateViewState) state andTest:(NSString *)text{
    
    
    LYCStateViews * stateView = [[self alloc]initWithMianView:view];
    [view addSubview:stateView];
    stateView.textStr = text;
    stateView.lycStateViewState = state;
    
    stateView.userInteractionEnabled = NO;
   
    return stateView;
}

- (id)initWithMianView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.frame];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(IS_IOS_8){
        mainHud = [MBProgressHUD iOS8showWithText:self.textStr andView:self];
    }else{
        mainHud = [MBProgressHUD showWithText:self.textStr andState:MBProgressHUDModeIndeterminate andView:self];
    }
    if(self.lycStateViewState  == LYCStateNoUerInterface){
        
    }else{
        mainHud.userInteractionEnabled = NO;
    }
}

-(void)LYCHidStateView{
    
    for (UIView *hud in [UIApplication sharedApplication].keyWindow.subviews) {
        
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            [hud removeFromSuperview];
        }
        
    }
    self.hidden = YES;

}

-(void)LYCShowStateView{
    self.hidden = NO;
}

@end
