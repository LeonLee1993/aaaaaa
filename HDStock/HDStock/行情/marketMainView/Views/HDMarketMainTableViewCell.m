//
//  HDMarketMainTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMarketMainTableViewCell.h"

@implementation HDMarketMainTableViewCell


-(void)setModel:(marketListModel *)model{
    _model = model;
    _title.text = model.Name;
    _code.text = model.Symbol;
    _price.text = model.NewPrice;
    
    NSString *tempStr = [model.PriceChangeRatio substringToIndex:1];
    if([tempStr isEqualToString:@"-"]){
        _raiseRange.textColor = RGBCOLOR(10,174,106);
        _raiseRange.text = model.PriceChangeRatio;
        _price.textColor = RGBCOLOR(10,174,106);
    }else{
        _raiseRange.text = [NSString stringWithFormat:@"+%@",model.PriceChangeRatio];
    }
}

@end
