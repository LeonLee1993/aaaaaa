//
//  NoCollectedTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 17/2/14.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "NoCollectedTableViewCell.h"
#import "recomentStockView.h"
#import "randomStockModel.h"

@implementation NoCollectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)setRandomStockArr:(NSArray *)randomStockArr{
    NSInteger i = 400;
    for (randomStockModel *model  in randomStockArr) {
      recomentStockView *view=  [self.randomStockView viewWithTag:i++];
        view.nameLabel.text = model.name;
        view.attentionLabel.text = model.symbol;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonClicked:(UIButton *)sender {
    self.block(sender);//301 tag
}

- (IBAction)refreshButtonClicked:(UIButton *)sender {
    self.block(sender);//302 tag
    sender.selected = YES;
}

- (IBAction)collectAllTheRecommendClicked:(UIButton *)sender {
    self.block(sender);//303 tag
    sender.selected = YES;
    
}

@end
