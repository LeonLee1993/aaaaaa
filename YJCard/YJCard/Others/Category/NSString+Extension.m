//
//  NSString+Extension.m
//  YJCard
//
//  Created by paradise_ on 2017/7/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "NSString+Extension.h"
#import "YJCXStack.h"

@implementation NSString (Extension)
- (NSString *)URLEncode
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}


+ (NSString *)setUrlEncodeStringWithDic:(NSMutableDictionary *)propertyDic{
    NSMutableString * encodeStr = [[NSMutableString alloc]init];
     NSString *DateString = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    [propertyDic setObject:@"c90f14e8697f4f8fb770a88c8ecbe34e" forKey:@"appkey"];
    if(!propertyDic[@"version"]){
        [propertyDic setObject:@"1" forKey:@"version"];
    }
    [propertyDic setObject:DateString forKey:@"timestamp"];
    [propertyDic setObject:@"1" forKey:@"platform"];
    [propertyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
          [encodeStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[obj URLEncode]]];
    }];
    NSString * resultStr = [encodeStr substringToIndex:encodeStr.length-1];
    NSString *results = [resultStr URLEncode];
    NSString *endStr = [YJCXStack encripyWith:results];
    return endStr;
}


+ (NSString *)setWebUrlEncodeStringWithDic:(NSMutableDictionary *)propertyDic{
    NSMutableString * encodeStr = [[NSMutableString alloc]init];
    [propertyDic setObject:@"1" forKey:@"platform"];
    [propertyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [encodeStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[obj URLEncode]]];
    }];
    NSString * resultStr = [encodeStr substringToIndex:encodeStr.length-1];
    NSString *results = [resultStr URLEncode];
    NSString *endStr = [YJCXStack encripyWith:results];
    return endStr;
}

+ (NSString *)StransformStringToFloatFormat:(CGFloat )floatValue{
    NSString *string = [NSString stringWithFormat:@"%.2f",floatValue];
    return string;
}

+ (NSString *)StransformStringToFloatFormatRMB:(NSString * )floatValue{
    NSString *string = [NSString stringWithFormat:@"¥%@",floatValue];
    return string;
}

+ (NSString *)subStringFromString:(NSString *)string by:(NSString *)subString1 to:(NSString *)subString2{
    
    NSString * tempString = [[NSString alloc]init];
    
    NSRange range1 = [string rangeOfString:subString1];
    NSRange range2 = [string rangeOfString:subString2];
    
    if (range1.location != NSNotFound && range2.location != NSNotFound) {
        
        NSString * subedString = [string getSubstringFrom:range1.location + range1.length to:range2.location - 1];
        
        tempString = subedString;
        
    }
    
    return tempString;
}

- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0325-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         *///中国移动:139、138、137、136、135、134、159、158、157、150、151、152、147（数据卡）、188、187、182、183、184、178
    NSString * CM = @"^1(34[0-8]|(78|47|3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         *///中国联通:130、131、132、156、155、186、185、145（数据卡）、176
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|45|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         *///中国电信:133、153、189、180、181、177、173（待放）虛拟运营商: 1700、1705、1707、1708、1709
    NSString * CT = @"^1((33|53|8[091]|77|73)[0-9][0-9]|349[0-9]|170[05789])\\d{6}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
