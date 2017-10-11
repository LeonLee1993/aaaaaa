//
//  TendentTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentTableViewCell.h"
#import "RetailersModel.h"
#import "UIImageView+webCache.h"
@implementation TendentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(RetailersModel *)model{
    _model = model;
    self.title.text = model.name;
    self.function.text = model.phone;
    self.teleLabel.text = model.address;
    
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.distanceLabel.text = @"";
    }else{
        self.distanceLabel.text = model.distance;
    }
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]placeholderImage:[UIImage imageNamed:@"商户默认头像"]];
    if([model.isShowRebate isEqual:
        @(1)]&&model.discount.length>0){
        self.messageLabel.text = [NSString stringWithFormat:@"%@",model.discount];
        self.messageLabel.hidden = NO;
        self.messagelabelImage.hidden = NO;
    }else{
        self.messagelabelImage.hidden = YES;
        self.messageLabel.hidden = YES;
    }
}


@end
