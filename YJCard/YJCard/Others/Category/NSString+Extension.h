//
//  NSString+Extension.h
//  YJCard
//
//  Created by paradise_ on 2017/7/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSString *)URLEncode;

+ (NSString *)setUrlEncodeStringWithDic:(NSDictionary *)propertyDic;


+ (NSString *)StransformStringToFloatFormat:(CGFloat )floatValue;

+ (NSString *)StransformStringToFloatFormatRMB:(NSString *)floatValue;


+ (NSString *)setWebUrlEncodeStringWithDic:(NSMutableDictionary *)propertyDic;

+ (NSString *)subStringFromString:(NSString *)string by:(NSString *)subString1 to:(NSString *)subString2;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

@end
