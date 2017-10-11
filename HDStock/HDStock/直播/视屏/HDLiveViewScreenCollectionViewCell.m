//
//  HDLiveViewScreenCollectionViewCell.m
//  HDStock
//
//  Created by hd-app01 on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveViewScreenCollectionViewCell.h"

@implementation HDLiveViewScreenCollectionViewCell


- (void) configUIWithModel:(HDLiveViewScreenModel*)model {
    [self.picIMV sd_setImageWithURL:[NSURL URLWithString:model.picStr] placeholderImage:imageNamed(@"") options:(SDWebImageProgressiveDownload)];
//    self.financeObserveLabl.text =
    self.titleLabl.text = model.titleStr;
    self.timeLabl.text = model.timeStr;
    self.playNumLabl.text = model.playNumStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

@end
