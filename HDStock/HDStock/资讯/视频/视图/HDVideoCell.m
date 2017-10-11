//
//  HDVideoCell.m
//  HDStock
//
//  Created by hd-app02 on 16/11/20.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoCell.h"

@implementation HDVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setModel:(HDHeadLineModel *)model{

    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 4;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:GolbleFont,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    if (model.title) {
        
        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:model.title attributes:attributes];
        
    }
    
    //self.titleLabel.text = model.title;
    
    self.timeLabel.text = model.dateline;
    
    self.lookLabel.text = [NSString stringWithFormat:@"%ld",(long)model.viewnum + 478];
    
    if (model.tags_name) {
        [self.tagBGView setHidden:NO];
        [self.tagLabel setHidden:NO];
        self.tagLabel.text = model.tags_name.allValues[0];
        
    }else{
        [self.tagLabel setHidden:YES];
        [self.tagBGView setHidden:YES];
        
    }
    
}

@end
