//
//  MyPlanTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyPlanTableViewCell.h"

@implementation MyPlanTableViewCell

-(void)setModel:(MyPlanModel *)model{
    _model = model;
    
    if(![model.title isKindOfClass:[NSNull class]]){
        _title.text = model.title;
    }
    
    if(![model.create_time isKindOfClass:[NSNull class]]){
        _timelabel.text = model.create_time;
    }
    
    if(![model.cycle isKindOfClass:[NSNull class]]){
        _plantime.text = model.cycle;
    }
    
    if(![model.pic isKindOfClass:[NSNull class]]){
        [_image sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    }

    if(![model.close_time isKindOfClass:[NSNull class]]){
        _closeTIme.text = model.close_time;
    }
}

@end
