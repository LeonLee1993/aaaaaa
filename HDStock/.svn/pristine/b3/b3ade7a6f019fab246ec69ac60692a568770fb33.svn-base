//
//  buiedProductDetailThirdCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductDetailThirdCell.h"

@implementation buiedProductDetailThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickButton:(BuiedThirdButton *)sender {
    sender.selected = NO;
    UIView *view = [self.contentView viewWithTag:998];
    for (UIButton *butoon in view.subviews) {
        if(butoon.tag!=sender.tag){
            butoon.selected = YES;
        }
    }
    self.threeButtonBlock(sender.tag);
}

@end
