//
//  TendentListModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RetailersModel.h"

@interface TendentListModel : NSObject

@property (nonatomic, strong) NSNumber *pageCount;
@property (nonatomic, strong) NSMutableArray <RetailersModel *> *retailers;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

