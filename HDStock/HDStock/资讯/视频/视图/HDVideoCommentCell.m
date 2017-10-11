//
//  HDVideoCommentCell.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoCommentCell.h"

@implementation HDVideoCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HDNewsCommentsModel *)model{

    _model = model;
    
    self.userName.text = model.username;

    self.timeLabel.text = model.dateline;
    
    self.massageLabel.text = model.message;

}

@end
