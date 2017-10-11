//
//  HDPersonalInformationCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPCCollectedVideoCell.h"

@implementation HDPCCollectedVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MyCollectedDataModel *)model{
    _model = model;
    
    if(![model.title isKindOfClass:[NSNull class]]){
        _titleLabel.text = model.title;
    }
    if(![model.dateline isKindOfClass:[NSNull class]]){
        _time.text = model.dateline;
    }
    
    if(![model.pic isKindOfClass:[NSNull class]]){
        [_image sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    }
    if(![model.viewnum isKindOfClass:[NSNull class]]){
        _viewNum.text = model.viewnum;
    }
}

@end
