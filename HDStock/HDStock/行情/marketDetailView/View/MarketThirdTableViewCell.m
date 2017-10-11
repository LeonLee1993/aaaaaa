//
//  MarketThirdTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MarketThirdTableViewCell.h"

@implementation MarketThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setTempFlag:(NSString *)tempFlag{
    CGSize titleDesc = [tempFlag boundingRectWithSize:CGSizeMake(WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    CGRect rectOfTitle = _title.frame;
    rectOfTitle.size.height = titleDesc.height;
    rectOfTitle.size.width = titleDesc.width;
    _title.frame = rectOfTitle;
    _title.text = tempFlag;
}

@end
