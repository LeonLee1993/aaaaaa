//
//  HDStockSayingHistoryCell.m
//  HDStock
//
//  Created by hd-app02 on 2017/2/15.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDStockSayingHistoryCell.h"

@interface HDStockSayingHistoryCell()

@end

@implementation HDStockSayingHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.progressView.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)setModel:(HDHeadLineModel *)model{

    _model = model;
    
    self.titleLabel.text = model.title;
    
    NSDictionary * dic = [ZHFactory readPlistWithPlistName:@"audioPlist"];
    
    if ([dic objectForKey:[NSString stringWithFormat:@"%ld",(long)model.aid]]) {
        
        self.titleLabel.textColor = [UIColor grayColor];
        
    }
    
    self.timeLabel.text =  model.HourAndMinTime;
    
    self.viewLabel.text = [NSString stringWithFormat:@"%ld次播放", model.viewnum + 478];

}

@end
