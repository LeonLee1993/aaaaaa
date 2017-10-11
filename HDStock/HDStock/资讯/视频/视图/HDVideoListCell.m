//
//  HDVideoListCell.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoListCell.h"

@implementation HDVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (kScreenIphone4 || kScreenIphone5) {
        
        self.timeLabelWidth.constant = 57;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HDNewsVideoRelatedModel *)model{

    _model = model;
    
    if (model.title) {
        self.titleLabel.text = model.title;
    }
    
    self.lookLabel.text = [NSString stringWithFormat:@"%ld", (long)model.viewnum + 478];
    
//    if(model.dateline){
//    
//        NSString * string = [model.dateline substringWithRange:NSMakeRange(5, 6)];
    
    self.timeLabel.text = model.dateline;
        
    //}
    
    [self.singelImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];


}


@end
