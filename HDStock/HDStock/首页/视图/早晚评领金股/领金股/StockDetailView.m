//
//  stockDetailView.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "StockDetailView.h"

@implementation StockDetailView

+ (instancetype)stockDetailView{
    
    NSArray * obj = [[NSBundle mainBundle]loadNibNamed:@"StockDetailView" owner:nil options:nil];

    return [obj lastObject];
}

@end
