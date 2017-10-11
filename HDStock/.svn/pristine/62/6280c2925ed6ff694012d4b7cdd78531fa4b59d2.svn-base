//
//  HDScrollWordsTableViewCell.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDScrollWordsTableViewCell.h"

@implementation HDScrollWordsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotNewsArray:(NSArray *)hotNewsArray{

    _hotNewsArray = hotNewsArray;
    
    self.wordsScorllView.onlyDisplayText = YES;
    self.wordsScorllView.autoScrollTimeInterval = 3;
    self.wordsScorllView.showPageControl = NO;
    self.wordsScorllView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.wordsScorllView.titleLabelHeight = self.wordsScorllView.bounds.size.height;
    self.wordsScorllView.titleLabelBackgroundColor = COLOR(whiteColor);
    self.wordsScorllView.titleLabelTextColor = COLOR(blackColor);
    self.wordsScorllView.titlesGroup = @[@"专注精研，只为炒股的你"];

    if (hotNewsArray.count != 0) {
        
        self.wordsScorllView.titlesGroup = hotNewsArray;
        
    }
    
}

@end
