//
//  PCMCSecondTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMCSecondTableViewCell.h"

@implementation PCMCSecondTableViewCell

-(void)setModel:(systemMessageModel *)model{
    _model = model;
    if(![model.imgpath isKindOfClass:[NSNull class]]){
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
    }
    
    if(![model.content isKindOfClass:[NSNull class]]){
        NSString * tempStr = model.content;
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        style1.headIndent = 0;
        style1.firstLineHeadIndent = 0;
        style1.lineSpacing = 6;
        NSAttributedString *attibuteStr = [[NSAttributedString alloc]initWithString:tempStr attributes:@{NSParagraphStyleAttributeName:style1,NSForegroundColorAttributeName:RGBCOLOR(51, 51, 51),NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _title.attributedText = attibuteStr;
    }
    
    if(![model.time isKindOfClass:[NSNull class]]){
        _timeLabel.text = model.time;
    }
}

@end
