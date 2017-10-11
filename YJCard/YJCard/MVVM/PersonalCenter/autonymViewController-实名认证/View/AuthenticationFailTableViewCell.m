//
//  AuthenticationFailTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/8/11.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AuthenticationFailTableViewCell.h"

@implementation AuthenticationFailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)recommitButtonClicked:(id)sender {
    self.resetBlock();
}


@end
