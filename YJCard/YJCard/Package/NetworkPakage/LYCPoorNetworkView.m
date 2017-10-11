//
//  LYCPoorNetworkView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/22.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCPoorNetworkView.h"

@implementation LYCPoorNetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)reloadButtonClicked:(id)sender {
    [self hid];
    if(self.reloadBlock){
        self.reloadBlock();
    }
}

- (IBAction)dissmissButtonClicked:(id)sender {
    [self hid];
}

-(void)show{
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:self];
    
}

- (void)hid{
    [self removeFromSuperview];
}



@end
