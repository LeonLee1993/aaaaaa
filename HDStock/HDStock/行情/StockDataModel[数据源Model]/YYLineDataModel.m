//
//  YYLineDataModel.m
//  投融宝
//
//  Created by yate1996 on 16/10/5.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYLineDataModel.h"
@interface YYLineDataModel()

/**
 持有字典数组，用来计算ma值
 */
@property (nonatomic, strong) NSArray *parentDictArray;
@end
@implementation YYLineDataModel
{
    NSDictionary * _dict;
    NSString *Close;
    NSString *Open;
    NSString *Low;
    NSString *High;
    NSString *Volume;
    float MA5;
    float MA10;
    float MA20;
    
}

- (NSString *)Day {
    NSString *day = _dict[@"time"];
    return [NSString stringWithFormat:@"%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)]];
}

- (NSString *)DayDatail {
    NSString *day = _dict[@"time"];
    return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
}

- (NSNumber *)Open {
    return _dict[@"kpj"];
}

- (NSNumber *)Close {
    return _dict[@"spj"];
}

- (NSNumber *)High {
    return _dict[@"zgj"];
}

- (NSNumber *)Low {
    return _dict[@"zdj"];
}

- (CGFloat)Volume {
    return [_dict[@"drcjl"] floatValue];
}

- (BOOL)isShowDay {
    return [_dict[@"time"] hasSuffix:@"01"];
}

- (float)MA5 {
    return MA5;
}

- (float)MA10 {
    return MA10;
}

- (float)MA20 {
    return MA20;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {        
        _dict = dict;
        Close = _dict[@"spj"];
        Open = _dict[@"kpj"];
        High = _dict[@"zgj"];
        Low = _dict[@"zdj"];
        Volume = _dict[@"drcjl"];
        NSString *ma5Str = _dict[@"ma5"];
        NSString *ma10Str = _dict[@"ma10"];
        NSString *ma20Str = _dict[@"ma20"];
        MA5  = ma5Str.floatValue;
        MA10 = ma10Str.floatValue;
        MA20 = ma20Str.floatValue;
    }
    return self;
}

- (void)updateMA:(NSArray *)parentDictArray {
        _parentDictArray = parentDictArray;
//        NSInteger index = [_parentDictArray indexOfObject:_dict];
    

//            CGFloat average = [[[_parentDictArray valueForKeyPath:@"ma5"] valueForKeyPath:@"@avg.floatValue"] floatValue];
//            MA5 = @(average);
//            
//            CGFloat averagema10 = [[[_parentDictArray valueForKeyPath:@"ma10"] valueForKeyPath:@"@avg.floatValue"] floatValue];
//            MA10 = @(averagema10);
//   
//            CGFloat averagema30 = [[[_parentDictArray valueForKeyPath:@"ma30"] valueForKeyPath:@"@avg.floatValue"] floatValue];
//            MA20 = @(averagema30);
    
//    CGFloat average = [[_parentDictArray valueForKeyPath:@"ma5"] floatValue];
//    MA5 = @(10);
//    
////    CGFloat averagema10 = [[_parentDictArray valueForKeyPath:@"ma10"] floatValue];
//    MA10 = @(20);
//    
////    CGFloat averagema30 = [[_parentDictArray valueForKeyPath:@"ma30"] floatValue];
//    MA20 = @(30);
    
    
}

@end
