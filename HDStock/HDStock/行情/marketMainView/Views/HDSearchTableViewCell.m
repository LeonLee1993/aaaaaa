//
//  HDSearchTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSearchTableViewCell.h"

@implementation HDSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(HDSearchViewModel *)model{
    _model = model;
    if(![_model.Name isKindOfClass:[NSNull class]]){
        _titleLabel.text = _model.Name;
    }else{
        NSLog(@"没有值");
    }
    
    if(![_model.Symbol isKindOfClass:[NSNull class]]){
        _codeLabel.text = _model.Symbol;
        NSArray *arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey];
        if([arr containsObject:_model.Symbol]){
            _addToMarketButton.selected = YES;
        }else{
            _addToMarketButton.selected = NO;
        }
    }else{
        NSLog(@"没有值");
    }
    
    _addToMarketButton.layer.cornerRadius = 6;
    _addToMarketButton.layer.masksToBounds = YES;
    _addToMarketButton.layer.borderWidth = 1;
    if(_addToMarketButton.selected == YES){
        _addToMarketButton.borderColor = RGBCOLOR(102, 102, 102);
    }else{
        _addToMarketButton.borderColor = MAIN_COLOR;
    }
}

- (IBAction)addToMarketClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(_addToMarketButton.selected == YES){
        _addToMarketButton.borderColor = RGBCOLOR(102, 102, 102);
    }else{
        _addToMarketButton.borderColor = MAIN_COLOR;
    }
    self.addBlock(_model.Symbol);
}

@end
