//
//  TopViewEventViewModel.h
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopViewEventViewModel : NSObject
//扫一扫
@property (nonatomic, strong, readonly) RACCommand *ScanCommand;
//付款码
@property (nonatomic, strong, readonly) RACCommand *PayMoneyCommand;
//扫卡查余额
@property (nonatomic, strong, readonly) RACCommand *RemainCommand;
//卡片充值
@property (nonatomic, strong, readonly) RACCommand *ChargeCommand;

@end
