//
//  HDLiveGuPingTableViewCell.m
//  HDStock
//
//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveGuPingTableViewCell.h"

@implementation HDLiveGuPingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) configUIWIthModel:(HDLiveGuPingModel*)model {
    self.titleLabl.text = model.title;
    self.sourceLabl.text = [[NSString alloc] initWithFormat:@"来源:%@",model.source];
    self.timeLabl.text = model.time;
    [self.picIMV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:imageNamed(@"") options:(SDWebImageProgressiveDownload)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
