//
//  MyOrderTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/12.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

-(void)setModel:(MyOrderList *)model{
    _model = model;
    _time.text = model.created_at;
    _price.text = model.price;
    
    if([model.status isEqual:@(0)]){
        _state.text = @"服务中";
        _byButton.userInteractionEnabled = NO;
        [_byButton setTintColor:[UIColor grayColor]];
        _byButton.layer.borderColor = [UIColor grayColor].CGColor;
        [_byButton setTitle:@" 订阅中 " forState:UIControlStateNormal];
        [_byButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if ([model.status isEqual:@(1)]){
        _state.text = @"服务到期";
        _byButton.userInteractionEnabled = YES;
        _byStateImage.image = [UIImage imageNamed:@"wodedingdan_failed"];
        [_byButton setTitle:@" 继续订阅 " forState:UIControlStateNormal];
        _byButton.layer.borderColor = MAIN_COLOR.CGColor;
        [_byButton setTitleColor:MAIN_COLOR  forState:UIControlStateNormal];
    }else if([model.status isEqual:@(2)]){
        _state.text = @"未付款";
        _byButton.userInteractionEnabled = YES;
        _byStateImage.image = [UIImage imageNamed:@"wodedingdan_failed"];
        _byButton.layer.borderColor = MAIN_COLOR.CGColor;
        [_byButton setTitle:@"去付款" forState:UIControlStateNormal];
    }
    
    if([model.product_id isEqual:@(1)]){
        self.buiedImage.image = [UIImage imageNamed:@"v6"];
        self.titleLable.text = @"V6尊享版（服务周期：1个月）";
    }else if([model.product_id isEqual:@(2)]){
        self.buiedImage.image = [UIImage imageNamed:@"擒牛"];
        self.titleLable.text = @"擒牛（服务周期：1个月）";
    }else if([model.product_id isEqual:@(3)]){
        self.buiedImage.image = [UIImage imageNamed:@"降龙"];
        self.titleLable.text = @"降龙（服务周期：1个月）";
    }else if([model.product_id isEqual:@(4)]){
        self.buiedImage.image = [UIImage imageNamed:@"捉妖"];
        self.titleLable.text = @"捉妖（服务周期：1个月）";
    }
//    if(model.product_id)
}
- (IBAction)buyButtonClicked:(UIButton *)sender {
    self.block(_model.price,_model.product_id.stringValue);
}

@end
