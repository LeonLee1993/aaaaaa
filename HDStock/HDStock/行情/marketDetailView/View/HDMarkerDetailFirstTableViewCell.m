//
//  HDMarkerDetailFirstTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMarkerDetailFirstTableViewCell.h"

@implementation HDMarkerDetailFirstTableViewCell

-(void)setModel:(fullScreenDataModel *)model{
    _model = model;
    self.jinkai.text = model.Open;
    self.chengjiaoliang.text = model.Volume;
    self.zuigao.text = model.High;
    self.zuidi.text = model.Low;
    self.currentPrice.text = [NSString stringWithFormat:@"%.2f",model.NewPrice.floatValue];
    NSString *tempPriceChange =[NSString stringWithFormat:@"%.2f",model.zhangdie.floatValue>0?[NSString stringWithFormat:@"%f",model.zhangdie.floatValue].floatValue:model.zhangdie.floatValue];
    self.currentPriceChange.text = tempPriceChange.floatValue>0?[NSString stringWithFormat:@"+%.2f",tempPriceChange.floatValue]:tempPriceChange;
    if(model.zhangdie.floatValue>0){
        self.currentPriceChange.textColor = RGBCOLOR(226, 59, 74);
    }else{
        self.currentPriceChange.textColor = RGBCOLOR(10,174,106);
    }
    NSString *tempChangeRate = [NSString stringWithFormat:@"%.2f%%",model.zhangdiefu.floatValue>0?[NSString stringWithFormat:@"%f",model.zhangdiefu.floatValue].floatValue:model.zhangdiefu.floatValue];
    self.currentPriceChangeRate.text =  tempChangeRate.floatValue>0? [NSString stringWithFormat:@"+%.2f",tempChangeRate.floatValue]:tempChangeRate;
    if(model.zhangdiefu.floatValue>0){
        self.currentPriceChangeRate.textColor = RGBCOLOR(226, 59, 74);
    }else{
        self.currentPriceChangeRate.textColor = RGBCOLOR(10,174,106);
    }
    
    if(self.currentPriceChange.text.floatValue>0){
        self.currentPriceChange.backgroundColor = [UIColor redColor];
        self.currentPriceChangeRate.backgroundColor = [UIColor redColor];
        self.currentPrice.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:1 animations:^{
            self.currentPriceChange.backgroundColor = [UIColor whiteColor];
            self.currentPriceChangeRate.backgroundColor = [UIColor whiteColor];
            self.currentPrice.backgroundColor = [UIColor whiteColor];
        }];
    }else{
        
        self.currentPriceChange.backgroundColor = [UIColor greenColor];
        self.currentPriceChangeRate.backgroundColor = [UIColor greenColor];
        self.currentPrice.backgroundColor = [UIColor greenColor];
        
        [UIView animateWithDuration:1 animations:^{
            self.currentPriceChange.backgroundColor = [UIColor whiteColor];
            self.currentPriceChangeRate.backgroundColor = [UIColor whiteColor];
            self.currentPrice.backgroundColor = [UIColor whiteColor];
        }];
    }
    
}

@end
