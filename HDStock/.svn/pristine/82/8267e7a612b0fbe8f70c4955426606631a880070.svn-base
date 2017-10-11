//
//  buiedProductDetailForthCellTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductDetailForthCellTableViewCell.h"

@implementation buiedProductDetailForthCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(Operating_strategyModel *)model{
    _model = model;
    NSDictionary *dic = (NSDictionary *)model;
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.headIndent = 0;
    style1.firstLineHeadIndent = 0;
    style1.lineSpacing = 3;
    
    if(![dic[@"content"] isKindOfClass:[NSNull class]]){
    NSAttributedString * descAtt = [[NSAttributedString alloc]initWithString:dic[@"content"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
    self.descLabel.attributedText = descAtt;
    }
    
    if(![dic[@"create_time"] isKindOfClass:[NSNull class]]){
        _timeLabel.text = dic[@"create_time"];
    }
    
//    if(![dic[@"king_product_id"] isKindOfClass:[NSNull class]]){
//        _tagLabel.text = ((NSNumber *)dic[@"king_product_id"]).stringValue;
//    }
}

@end
