//
//  TendentStateView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentStateView.h"

@interface TendentStateView()


@end

@implementation TendentStateView

-(void)setStateViewString:(NSString *)stateViewString{
    UILabel *lable = [self viewWithTag:202];
    lable.text = stateViewString;
}

-(void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    UILabel *lable = [self viewWithTag:202];
    UIImageView *imageView = [self viewWithTag:203];
    
    if(self.isMainView){
        if(isOn){
            imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            imageView.transform = CGAffineTransformIdentity;
        }
    }else{
        if(isOn){
            imageView.transform = CGAffineTransformMakeRotation(M_PI);
            lable.textColor = RGBColor(51, 51, 51);
        }else{
            imageView.transform = CGAffineTransformIdentity;
            lable.textColor = RGBColor(102, 102, 102);
        }
    }
}

@end
