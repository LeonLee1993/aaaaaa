//
//  fullScreenDataModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface fullScreenDataModel : NSObject

@property (nonatomic, strong) NSString *Volume;
@property (nonatomic, strong) NSString *Open;
@property (nonatomic, strong) NSString *High;
@property (nonatomic, strong) NSNumber *zhangdie;
@property (nonatomic, strong) NSString *Low;
@property (nonatomic, strong) NSString *Amount;
@property (nonatomic, strong) NSString *Symbol;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *NewPrice;
@property (nonatomic, strong) NSNumber *zhangdiefu;

//@property (nonatomic, strong) NSNumber *fscjl;
//@property (nonatomic, strong) NSString *time;
//@property (nonatomic, strong) NSNumber *fscje;
//@property (nonatomic, strong) NSNumber *cjl;
//@property (nonatomic, strong) NSNumber *cje;
//@property (nonatomic, strong) NSString *TimeTrend;
//@property (nonatomic, strong) NSString *unknown;
//@property (nonatomic, strong) NSString *zrspj;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

