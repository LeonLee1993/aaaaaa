//
//  LastTradeInfoModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LastTradeInfoModel : NSObject

@property (nonatomic, strong) NSString *tradeId;
@property (nonatomic, strong) NSNumber *tradeType;
@property (nonatomic, strong) NSString *tradeStation;
@property (nonatomic, strong) NSString *tradeDateTime;
@property (nonatomic, strong) NSString *tradeMoney;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

