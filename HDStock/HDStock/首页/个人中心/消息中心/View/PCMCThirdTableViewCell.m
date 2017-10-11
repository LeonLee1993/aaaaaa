//
//  PCMCThirdTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMCThirdTableViewCell.h"

@implementation PCMCThirdTableViewCell


-(void)setModel:(systemMessageModel *)model{
    _model = model;
    if(![model.imgpath isKindOfClass:[NSNull class]]){
        [_image sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
    }
    
    if(![model.content isKindOfClass:[NSNull class]]){
        _title.text = model.content;
    }
    
    if(![model.time isKindOfClass:[NSNull class]]){
        NSString * str = ((NSArray *)[model.time componentsSeparatedByString:@" "])[0];
        _time.text = [str substringFromIndex:5];
    }
}

@end
