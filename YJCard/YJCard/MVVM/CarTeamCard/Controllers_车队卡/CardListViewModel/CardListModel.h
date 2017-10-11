//
//  CardListModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CardListModel : NSObject

@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSNumber *cardId;
@property (nonatomic, strong) NSNumber *cardType;
@property (nonatomic, strong) NSString *createDateTime;
@property (nonatomic, strong) NSString *cardStatus;
/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

