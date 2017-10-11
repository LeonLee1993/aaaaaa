//
//  HDHeadLineBaseCell.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/31.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDHeadLineBaseCell.h"
#import "HDHeadLineModel.h"

@implementation HDHeadLineBaseCell

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
    
    if (kScreenIphone5 || kScreenIphone4) {
        self.fromLabel.text = model.from;
        self.fromLabel.font = systemFont(11);
        self.timeLabel.font = systemFont(11);
        self.tagLabel.font = systemFont(9);
        self.tabBGViewWidth.constant = 22;
        self.tabBGViewHeight.constant = 11;
        
    }else{
        NSString * str = @"来源：";
        
        NSString * text = [str stringByAppendingString:model.from];
        self.fromLabel.text = text;
        self.fromLabel.font = systemFont(12);
        self.timeLabel.font = systemFont(12);
        self.tagLabel.font = systemFont(10);
        self.tabBGViewWidth.constant = 29;
        self.tabBGViewHeight.constant = 15;
        
    }
    
    self.timeLabel.text = model.dateline;

    if (model.tags_name) {
        [self.tagBGView setHidden:NO];
        
        self.tagLabel.text = model.tags_name.allValues[0];
        
    }else{
    
        [self.tagBGView setHidden:YES];
    
    }

}


@end
