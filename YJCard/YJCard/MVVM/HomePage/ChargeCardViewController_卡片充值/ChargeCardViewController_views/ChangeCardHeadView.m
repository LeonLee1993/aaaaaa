//
//  ChangeCardHeadView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChangeCardHeadView.h"

@implementation ChangeCardHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClickedToDissmiss:(id)sender {
    
    self.dissMissChangeCardViewBlock();
}

@end
