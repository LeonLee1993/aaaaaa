//
//  HDPersonalInformationCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPCCollectedInformationCell.h"

@implementation HDPCCollectedInformationCell

-(void)setModel:(MyCollectedDataModel *)model{
    _model = model;
    if(![model.title isKindOfClass:[NSNull class]]){
        self.titleLabel.text = model.title;
    }
    if(![model.dateline isKindOfClass:[NSNull class]]){
        self.timeLabel.text = model.dateline;
    }
    if(![model.pic isKindOfClass:[NSNull class]]){
         [self.picImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    }
    
}

@end
