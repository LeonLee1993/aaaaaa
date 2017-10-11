//
//  HomePageModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LastTradeInfoModel.h"

@interface HomePageModel : NSObject

@property (nonatomic, strong) NSNumber *isOpenFree;
@property (nonatomic, strong) NSNumber *isSetPayPwd;
@property (nonatomic, strong) NSNumber *isAuthen;
@property (nonatomic, strong) NSString *cashBalance;
@property (nonatomic, strong) NSString *totalBalance;
@property (nonatomic, strong) NSString *rebateBalance;
@property (nonatomic, strong) LastTradeInfoModel *lastTradeInfo;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

