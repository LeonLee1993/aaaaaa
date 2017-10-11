//
//  CTManagerCollectionViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/7/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "CTManagerCollectionViewCell.h"
#import "CardListModel.h"

@implementation CTManagerCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setModel:(CardListModel *)model{
    _model = model;
    NSMutableDictionary * attributeDic = @{}.mutableCopy;
    attributeDic[NSKernAttributeName] = @(2);
    //        UIFont *font = [UIFont fontWithName:@"Heiti TC" size:30];
    NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:model.cardNo attributes:attributeDic];
    self.cardNOLabel.attributedText = attribute;
    _stateLable.text = model.cardStatus;
    if(![_stateLable.text isEqualToString:@"正常"]){
        _stateLable.alpha = 0.5;
    }else{
        _stateLable.alpha = 1;
    }
    
    
    if([model.cardType isEqual:@(0)]){
        self.selfImageView.image = [UIImage imageNamed:@"卡BG绿色"];
        self.littleImageView.image = [UIImage imageNamed:@"logo-绿"];
        self.cardTypeLabel.text = @"实体卡";
    }else{
        self.selfImageView.image = [UIImage imageNamed:@"卡BG蓝色"];
        self.littleImageView.image = [UIImage imageNamed:@"logo-蓝"];
        self.cardTypeLabel.text = @"电子卡";
    }
}

@end
