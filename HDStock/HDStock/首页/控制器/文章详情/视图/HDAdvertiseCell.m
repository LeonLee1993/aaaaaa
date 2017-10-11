//
//  HDAdvertiseCell.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/11.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDAdvertiseCell.h"

@interface HDAdvertiseCell()

@property (nonatomic, strong) UIImageView * adverImageView;

@end

@implementation HDAdvertiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
 
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.adverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.adverImageView];
        self.adverImageView.userInteractionEnabled = YES;
        
        [self.adverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            //make.size.mas_equalTo(CGSizeMake(710.0f * FITWIDTHBASEONIPHONEPLUS, 166 * FITHEIGHTBASEONIPHONEPLUS));
            make.top.left.equalTo(self.contentView).offset(10);
            make.right.bottom.equalTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL{

    _imageURL = imageURL;

    [self.adverImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
