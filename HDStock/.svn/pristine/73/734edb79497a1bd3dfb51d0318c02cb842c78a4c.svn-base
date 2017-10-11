//
//  PCMessageCenterTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMessageCenterTableViewCell.h"

@implementation PCMessageCenterTableViewCell

-(void)setModel:(MessageCenterModel *)model{
    _model = model;
    if(![_model.num isKindOfClass:[NSNull class]]){
        if([model.num isEqual:@(0)]){
            _numberOfMessage.text = @"";
            
        }else{
            _numberOfMessage.text = [NSString stringWithFormat:@" %@ ",model.num];
        }
    }
    
    if(![_model.time isKindOfClass:[NSNull class]]){
        _time.text = model.time;
    }
    
    if(![_model.content isKindOfClass:[NSNull class]]){
        _message.text = model.content;
    }
}

@end
