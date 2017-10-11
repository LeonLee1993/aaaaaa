//
//  TendentNothingView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentNothingView.h"

@implementation TendentNothingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)show{
    [self.mainVC.view addSubview:self];
}

- (void)hid{
    [self removeFromSuperview];
}

@end
