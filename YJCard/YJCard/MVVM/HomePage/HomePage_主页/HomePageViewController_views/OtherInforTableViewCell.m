//
//  OtherInforTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "OtherInforTableViewCell.h"
#import "LastTradeInfoModel.h"
@implementation OtherInforTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 11;
    frame.size.height -= 11;
    [super setFrame:frame];
}

-(void)setModel:(LastTradeInfoModel *)model{
    
    _model = model;
    
    NSArray * timeLabelArr = [model.tradeDateTime componentsSeparatedByString:@" "];

    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",timeLabelArr[0],timeLabelArr[1]];
    
    self.tradeMoneyLabel.text = [NSString stringWithFormat:@"%@ 元",model.tradeMoney];
    
    self.locationLabel.text = model.tradeStation;

}

@end
