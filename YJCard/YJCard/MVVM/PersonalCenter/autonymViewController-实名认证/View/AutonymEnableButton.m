//
//  AutonymEnableButton.m
//  YJCard
//
//  Created by paradise_ on 2017/8/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AutonymEnableButton.h"

@implementation AutonymEnableButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    if(userInteractionEnabled){
        self.backgroundColor = MainColor;
    }else{
        self.backgroundColor = RGBColor(181, 181, 181);
    }
}

@end
