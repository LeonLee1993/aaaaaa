//
//  MyPlanModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MyPlanModel : NSObject

@property (nonatomic, strong) NSNumber *status;
// @property (nonatomic, strong) Null *update_time;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *close_time;
@property (nonatomic, strong) NSString *cycle;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

