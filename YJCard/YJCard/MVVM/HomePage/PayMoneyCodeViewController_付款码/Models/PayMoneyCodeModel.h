//
//  PayMoneyCodeModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MemberPayCardsModel.h"

@interface PayMoneyCodeModel : NSObject

@property (nonatomic, strong) NSString *payCode;
@property (nonatomic, strong) NSMutableArray <MemberPayCardsModel *> *memberPayCards;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

