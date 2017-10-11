//
//  ThirdImageTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ThirdImageTableViewCell.h"
#import "HomePageModel.h"
@implementation ThirdImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += 10;
    frame.origin.y += 7;
    frame.size.height -= 7;
    //    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setModel:(HomePageModel *)model{
    
}

@end
