//
//  ProductDetailModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Operating_strategyModel.h"

@interface ProductDetailModel : NSObject

@property (nonatomic, strong) NSNumber *operation_period;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *macro_analysis;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *second_lose_price;
@property (nonatomic, strong) NSNumber *top_gain;
@property (nonatomic, strong) NSNumber *second_price;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *buy_reason;
@property (nonatomic, strong) NSNumber *category;
@property (nonatomic, strong) NSNumber *first_win_price;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *today_rose;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *expected_return;
@property (nonatomic, strong) NSNumber *first_price;
@property (nonatomic, strong) NSNumber *second_win_price;
@property (nonatomic, strong) NSString *now_price;
@property (nonatomic, strong) NSString *industry_analysis;
@property (nonatomic, strong) NSNumber *first_lose_price;
@property (nonatomic, strong) NSMutableArray <Operating_strategyModel *> *operating_strategy;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

