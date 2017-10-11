//
//  BuiedPruductTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "BuiedPruductTableViewCell.h"

@implementation BuiedPruductTableViewCell

-(void)setModel:(ProductDetailModel *)model{
    _model = model;
    _time.text = model.create_date;
//    _text.attributedText = [model.buy_reason ]
    if(![model.buy_reason isKindOfClass:[NSNull class]]){
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        style1.headIndent = 0;
        style1.firstLineHeadIndent = 0;
        style1.lineSpacing = 9;
        NSAttributedString * string = [[NSAttributedString alloc]initWithString:model.buy_reason attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
        self.text.attributedText = string;
    }
    
}

-(void)setListModel:(ProductListModel *)listModel{
    _listModel = listModel;
    
    if(listModel.operating_strategy !=nil&&![listModel.operating_strategy isKindOfClass:[NSNull class]]){
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        style1.headIndent = 0;
        style1.firstLineHeadIndent = 0;
        style1.lineSpacing = 5;
        NSAttributedString * string = [[NSAttributedString alloc]initWithString:listModel.operating_strategy attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
        self.text.attributedText = string;
    }else{
        self.text.text=@"";
    }
    
    if(![listModel.create_date isKindOfClass:[NSNull class]]&&listModel.create_date!=nil){
        self.time.text = listModel.create_date;
        if(![listModel.category isKindOfClass:[NSNull class]]){
            NSString *tempStr = [listModel.create_date substringFromIndex:5];
            NSArray *temparr = [tempStr componentsSeparatedByString:@"-"];
            if([listModel.category isEqualToString:@"1"]){
                _title.text = [NSString stringWithFormat:@"《V6尊享版》之%@月%@日策略",temparr[0],temparr[1]];
            }else if([listModel.category isEqualToString:@"2"]){
                _title.text = [NSString stringWithFormat:@"《擒牛》之%@月%@日策略",temparr[0],temparr[1]];
            }else if([listModel.category isEqualToString:@"3"]){
                _title.text = [NSString stringWithFormat:@"《降龙》之%@月%@日策略",temparr[0],temparr[1]];
            }else if([listModel.category isEqualToString:@"4"]){
                _title.text = [NSString stringWithFormat:@"《捉妖》之%@月%@日策略",temparr[0],temparr[1]];
            }
        }
    }
}

@end
