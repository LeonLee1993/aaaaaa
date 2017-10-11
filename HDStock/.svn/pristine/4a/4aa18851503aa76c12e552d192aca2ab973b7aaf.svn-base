//
//  HDTopScrollCell.m
//  HDStock
//
//  Created by hd-app02 on 16/11/10.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDTopScrollCell.h"

@implementation HDTopScrollCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setImageUrlArray:(NSArray *)imageUrlArray{

    _imageUrlArray = imageUrlArray;
    
    self.ScrollView.autoScrollTimeInterval = 3.0f;
    self.ScrollView.placeholderImage = imageNamed(@"emptypic");
    self.ScrollView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    if (imageUrlArray.count != 0) {
        self.ScrollView.imageURLStringsGroup = self.imageUrlArray;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
