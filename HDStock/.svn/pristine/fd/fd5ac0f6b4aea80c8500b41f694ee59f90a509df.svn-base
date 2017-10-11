//
//  HDNewsFlashCell.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDNewsFlashCell.h"

@implementation HDNewsFlashCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(HDFlashNewsModel *)model{

    _model = model;
    
    NSString * string = [model.create_time substringWithRange:NSMakeRange(11, 5)];
    
    self.timeLabel.text = string;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    self.newsLabel.attributedText = [[NSAttributedString alloc] initWithString:model.content attributes:attributes];

}

@end
