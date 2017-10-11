//
//  HDLiveJinNangTableViewCell.m
//  HDStock
//
//  Created by hd-app01 on 16/11/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveJinNangTableViewCell.h"

@implementation HDLiveJinNangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) configUIWithModel:(HDLiveJinNangModel*)model {
    self.jinNangNameLabl.text = model.jinNangNameStr;
    self.expectedIncomeLabl.text = model.expectedIncomeStr;
    self.highestIncomeLabl.text = model.highestIncomeStr;
    self.currentIncomeLabl.text = model.currentIncomeStr;
    [self.headPicIMV sd_setImageWithURL:[NSURL URLWithString:model.headPicStr] placeholderImage:imageNamed(@"weidenglu") options:(SDWebImageProgressiveDownload)];
    self.nameLabl.text = model.nameStr;
//    self.niuSanLabl.text =
    self.fansNumberLabl.text = [[NSString alloc] initWithFormat:@"粉丝数:%@",model.fansNumberStr];
//    self.jinNangSuccessRateLabl.text =
    self.publishDateLabl.text = model.publishDateStr;
    self.validBusinessDayTimeLabl.text = model.validBusinessDayTimeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
