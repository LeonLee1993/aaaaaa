//
//  YYTimeLineModel.m
//  投融宝
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYTimeLineModel.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation YYTimeLineModel
{
    NSDictionary * _dict;
    NSString *Price;
    NSString *Volume;
}

- (NSString *)TimeDesc {
    if ( [_dict[@"time"] integerValue] == 1131) {
        return @"11:30/13:00";
    } else {
        if([_dict[@"time"] integerValue] > 1130){
            NSString *timeStr = _dict[@"time"];
            return [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
        }else{
            NSString *timeStr;
            if([_dict[@"time"] isEqualToString:@"0931"]){
                timeStr = @"0930";
            }else{
                timeStr = _dict[@"time"];
            }
            return [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
        }
    }
}

- (NSString *)DayDatail {
    NSString *timeStr = _dict[@"time"];
    return [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
}

//前一天的收盘价
- (CGFloat )AvgPrice {
    return [_dict[@"zrspj"] floatValue];
}

- (NSNumber *)Price {
    return _dict[@"TimeTrend"];
}

- (CGFloat)Volume {
    return [_dict[@"fscjl"] floatValue];
}

-(NSString *)zhangdiefu{
    return _dict[@"zhangdiefu"];
}

-(NSString *)zrspj{
    return _dict[@"zrspj"];
}

-(NSString *)TimeTrend{
    return _dict[@"TimeTrend"];
}

- (BOOL)isShowTimeDesc {
    //9:30-11:30,13:00-15:00
    //11:30和13:00挨在一起，显示一个就够了
    //最后一个服务器返回的minute不是960,故只能特殊处理
    return [_dict[@"time"] integerValue]-1 == 930 ||  [_dict[@"time"] integerValue] == 1130 ||  [_dict[@"time"] integerValue] == 1500;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
        Price = _dict[@"TimeTrend"];
        Volume = _dict[@"fscjl"];
    }
    return self;
}

@end
