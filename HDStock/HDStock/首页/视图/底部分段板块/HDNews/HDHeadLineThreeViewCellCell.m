//
//  HDHeadLineThreeViewCellCell.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/31.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDHeadLineThreeViewCellCell.h"

@implementation HDHeadLineThreeViewCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HDHeadLineModel *)model{
    
    _model = model;
    
    if (!model.title) {
        
        self.titleLabel.text = @"还没数据呢";
        
    }else{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:GolbleFont,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:model.title attributes:attributes];
    
    }
    NSString * str = @"来源：";
    
    NSString * text = [str stringByAppendingString:model.from];
    self.fromLabel.text = text;
    
    self.timeLabel.text = model.dateline;
    
    [self.imageOne sd_setImageWithURL:[NSURL URLWithString:model.manypic0]placeholderImage:imageNamed(@"emptypic_littleone")];
    
    [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:model.manypic1]placeholderImage:imageNamed(@"emptypic_littleone")];
    
    [self.imageThree sd_setImageWithURL:[NSURL URLWithString:model.manypic2]placeholderImage:imageNamed(@"emptypic_littleone")];
    if (model.tags_name) {
        [self.tagBGView setHidden:NO];
        
        self.tagLabel.text = model.tags_name.allValues[0];
        
    }else{
        
        [self.tagBGView setHidden:YES];
        
    }
}

@end
