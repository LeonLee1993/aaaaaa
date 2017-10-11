//
//  CardDetailModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CardDetailModel : NSObject

@property (nonatomic, strong) NSString *totalPayAmount;
@property (nonatomic, strong) NSString *totalRewardAmount;
@property (nonatomic, strong) NSString *totalConsumCash;
@property (nonatomic, strong) NSString *totalConsumRebate;
@property (nonatomic, strong) NSString *cashBalance;
@property (nonatomic, strong) NSString *rebateBalance;
@property (nonatomic, strong) NSString *cardNo;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

