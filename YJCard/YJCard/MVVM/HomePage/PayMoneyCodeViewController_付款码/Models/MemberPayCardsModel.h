//
//  MemberPayCardsModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MemberPayCardsModel : NSObject

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *balance;
/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

