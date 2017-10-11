//
//  NoHistroyAndNoTextCell.m
//  HDStock
//
//  Created by liyancheng on 17/2/24.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "NoHistroyAndNoTextCell.h"
#import "randomStockModel.h"

@implementation NoHistroyAndNoTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setRecommendArr:(NSArray *)recommendArr{
    NSInteger i = 200;
    for (randomStockModel * model in recommendArr) {
        UIButton *button = [self.contentView viewWithTag:i++];
        [button setTitle:model.name forState:UIControlStateNormal];
    }
}
- (IBAction)buttonClicked:(UIButton *)sender {
    self.buttonBlock(sender.tag);
}

@end
