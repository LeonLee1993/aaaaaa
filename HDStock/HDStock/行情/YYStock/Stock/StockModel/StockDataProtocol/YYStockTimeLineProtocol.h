//
//  YYStockTimeLineProtocol.h
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#ifndef YYStockTimeLineProtocol_h
#define YYStockTimeLineProtocol_h


#endif /* YYStockTimeLineProtocol_h */
#import <CoreGraphics/CoreGraphics.h>
//提供分时图数据源
@protocol YYStockTimeLineProtocol <NSObject>

@required

/**
 *  价格
 */
@property (nonatomic, readonly) NSNumber *Price;

/**
 *  前一天的收盘价
 */
@property (nonatomic, readonly) CGFloat AvgPrice;

/**
 *  成交量
 */
@property (nonatomic, readonly) CGFloat Volume;

/**
 *  日期
 */
@property (nonatomic, readonly) NSString *TimeDesc;


#pragma mark --- 接口返回数据参数
@property (nonatomic, strong) NSNumber *fscjl;
@property (nonatomic, strong) NSNumber *zhangdie;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber *fscje;
@property (nonatomic, strong) NSNumber *cjl;
@property (nonatomic, strong) NSNumber *cje;
@property (nonatomic, strong) NSString *TimeTrend;
@property (nonatomic, strong) NSString *unknown;
@property (nonatomic, strong) NSString *zhangdiefu;
@property (nonatomic, strong) NSString *zrspj;


/**
 是否绘制在View上
 */
@property (nonatomic, readonly) BOOL isShowTimeDesc;

/**
 *  长按时显示的详细日期
 */
@property (nonatomic, readonly) NSString *DayDatail;

@optional

- (instancetype)initWithDict: (NSDictionary *)dict;

@end
