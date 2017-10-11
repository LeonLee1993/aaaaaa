//
//  myAssetTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "myAssetTableViewCell.h"
#import "HomePageModel.h"
@implementation myAssetTableViewCell

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

-(void)setModel:(HomePageModel *)model{
    _model = model;
    self.totalLeftMoneyLabel.text = model.totalBalance;
    self.totalLeftMoneyLabel.text = [NSString stringWithFormat:@"%@ 元",model.totalBalance];
    self.crashAmountLabel.text =[NSString stringWithFormat:@"现金金额: %@ 元",model.cashBalance];
    self.integralLabel.text = [NSString stringWithFormat:@"账户积分: %@ 元",model.rebateBalance];
}

@end
