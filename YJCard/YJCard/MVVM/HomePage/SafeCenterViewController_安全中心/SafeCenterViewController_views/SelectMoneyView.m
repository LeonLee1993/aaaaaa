//
//  SelectMoneyView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SelectMoneyView.h"
//选择需要免密金额的View

@implementation SelectMoneyView

-(void)hidTheImage{
    NSString * moneyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode];
    UILabel *label = [self viewWithTag:202];
    
    if(moneyStr.length>0){
        
        if([label.text isEqualToString:moneyStr]){
            UIImageView *iamge = [self viewWithTag:201];
            iamge.hidden = NO;
        }else{
            UIImageView *iamge = [self viewWithTag:201];
            iamge.hidden = YES;
        }
        
    }else{
        if([label.text isEqualToString:@"200元/笔"]){
            UIImageView *iamge = [self viewWithTag:201];
            iamge.hidden = NO;
        }else{
            UIImageView *iamge = [self viewWithTag:201];
            iamge.hidden = YES;
        }
    }
}

-(void)showTheImage{
    UIImageView *iamge = [self viewWithTag:201];
    iamge.hidden = NO;
}

@end
