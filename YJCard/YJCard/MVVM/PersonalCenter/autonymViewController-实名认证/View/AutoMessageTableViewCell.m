//
//  AutoMessageTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/8/11.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AutoMessageTableViewCell.h"

@implementation AutoMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFrame:(CGRect)frame{
    frame.origin.y += 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    
    self.nameLabel.text = infoDic[@"memberName"];
    self.IdLabel.text = infoDic[@"memberIDCard"];
    self.ProvinceLabel.text = infoDic[@"province"];
    self.cityLabel.text = infoDic[@"city"];
    
}
@end
