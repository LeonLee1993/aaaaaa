//
//  HDMiddleCell.m
//  HDStock
//
//  Created by hd-app02 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMiddleCell.h"

@implementation HDMiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _psyScrollButtonView.imageArray = @[imageNamed(@"home_product_V6"),imageNamed(@"home_product_catchcow"),imageNamed(@"home_product_catchdragon"),imageNamed(@"home_product_catchmonster")];

    _psyScrollButtonView.titleArray = @[@"V6尊享版",@"擒牛",@"降龙",@"捉妖"];
    _psyScrollButtonView.subTitleArray = @[@"把握当下机会 稳抓长足复利",@"动态监控 立足于牛",@"深度挖掘 决胜捞金",@"窥测形势 伺机而动"];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleArray:(NSArray *)titleArray{

    _titleArray = titleArray;
    
    

}

- (void)setSubTitleArray:(NSArray *)subTitleArray{

    _subTitleArray = subTitleArray;

}

@end
