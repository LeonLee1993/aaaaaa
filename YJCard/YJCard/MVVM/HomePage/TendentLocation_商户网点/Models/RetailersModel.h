//
//  RetailersModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface RetailersModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *isShowRebate;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSNumber *imgCount;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

