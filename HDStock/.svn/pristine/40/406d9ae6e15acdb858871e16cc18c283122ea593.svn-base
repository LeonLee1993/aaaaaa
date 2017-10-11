//
//  HDScrollViewsTableViewCell.m
//  HDStock
//
//  Created by hd-app02 on 16/11/17.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDScrollViewsTableViewCell.h"

@implementation HDScrollViewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init{

    if (self = [super init]) {
        
        _atcView = [[ATCarouselView alloc]init];
        
        [self.contentView addSubview:_atcView];
        
    }

    return self;

}

- (void)layoutSubviews{

    _atcView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 95 / 207);
    
    _atcView.images = @[imageNamed(@"banner"),imageNamed(@"big_news")];


}

@end
